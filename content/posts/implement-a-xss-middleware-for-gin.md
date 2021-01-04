+++
title = "实现一个 Gin 的 XSS 中间件"
date = 2021-01-04T20:32:00+08:00
lastmod = 2021-01-04T20:32:29+08:00
draft = false
+++

## 前言 {#前言}

本着造轮子不如用轮子的心态, 当然是搜一搜网上有没有现成的轮子了, 找了好大一圈发现只有一个
轮子 `XssMw`[^fn:1](17 stars). 然后大概扫了一眼这个项目的代码, 还是蛮简单的, 注释也比较丰富,
但是代码里面有很多用于调试的 `fmt.Printf`, 作为一个有代码洁癖的人, 肯定是受不了这个. 而
且这个项目好像很久没有更新了, 差不多有一年了, 所以就决定自己造轮子了.

XssMw 底层是使用的 `bluemonday`[^fn:2] 这个库来过滤字符串, 本身只是做了一个解析请求, 再
过滤的操作. 看了下 `bluemonday` 有 1.7k stars, 库质量应该还是不错的. 所以我的思路和
`XssMw` 一致, 但尽量简化代码.


## 基本思路 {#基本思路}

基本思路就是先将请求参数进行解析, 然后对解析后里的字符串进行过滤, 过滤之后, 再重新组装成请
求参数.

[gin-xss-flow.png](https://i.loli.net/2021/01/04/L38ChAV7vMPQfqS.png)


## 参数解析 {#参数解析}

参数解析算是整个中间件里面最麻烦的事情了, 对于一些纯文本的参数来说就比较简单, 直接过滤就
行了. 但是对于 `JSON`, `MessagePack` 这种序列化格式来说就比较麻烦, 就需要先反序列化一下.


### Plain Text {#plain-text}

直接使用 `bluemonday` 过滤就行了. 因为 `bluemonday` 会进行 `HTML` 转义(写死在代码里面,
不可配置), 需要反转一下, 不过这里也有一个风险点, 如果输入里面包含了转义字符, 也会被转义.

```go
func XSSFilterPlain(p *bluemonday.Policy, s string) string {
    sanitized := p.Sanitize(s)
    return html.UnescapeString(sanitized)
}
```


### JSON 解析 {#json-解析}

表面上 `Go` 里面解析 `JSON` 不像动态语言那样方便, 需要先定义类型. 但是别忘了, `Go` 里面
也有万能的 `interface{}`, 直接看代码:

```go
func XSSFilterJSON(p *bluemonday.Policy, s string) (string, error) {
    var data interface{}
    err := json.Unmarshal([]byte(s), &data)
    if err != nil {
        return "", err
    }

    b := strings.Builder{}
    e := json.NewEncoder(&b)
    e.SetEscapeHTML(false)
    err = e.Encode(xssFilterJSONData(p, data))
    if err != nil {
        return "", err
    }
    // use `TrimSpace` to trim newline char add by `Encode`.
    return strings.TrimSpace(b.String()), nil
}

func xssFilterJSONData(p *bluemonday.Policy, data interface{}) interface{} {
    if s, ok := data.([]interface{}); ok {
        for i, v := range s {
            s[i] = xssFilterJSONData(p, v)
        }
        return s
    } else if m, ok := data.(map[string]interface{}); ok {
        for k, v := range m {
            m[k] = xssFilterJSONData(p, v)
        }
        return m
    } else if str, ok := data.(string); ok {
        return XSSFilterPlain(p, str)
    }
    return data
}
```


### Form 解析 {#form-解析}

`GET` 形式的 form 和 `POST` 形式的 form 本质一样, 只是一个放在 `URL` 里的, 一个放在
`Request Body` 里面的.

```go
func XSSFilterQuery(p *bluemonday.Policy, s string) (string, error) {
    values, err := url.ParseQuery(s)
    if err != nil {
        return "", err
    }

    for k, v := range values {
        values.Del(k)
        for _, vv := range v {
            values.Add(k, XSSFilterPlain(p, vv))
        }
    }

    return values.Encode(), nil
}
```


### Multipart Form 解析 {#multipart-form-解析}

Multipart form 是类似下面这种的结构, 我们可以直接当成纯文本解析即可.

```text

------WebKitFormBoundaryAXJUb5Hid7KfCup1
Content-Disposition: form-data; name="f=>&name"

fdsf
------WebKitFormBoundaryAXJUb5Hid7KfCup1
Content-Disposition: form-data; name="lname"

jack
------WebKitFormBoundaryAXJUb5Hid7KfCup1--
```


### Gin 中间件 {#gin-中间件}

完成了上面这些, 编写中间件就简单了, 参考 `gin.Context.ShouldBind` 的实现, 先获取
binding, 根据 binding 的类型进行不同种类的过滤. 对于一些用户登录等包含密码的场景, 这个中
间件还需要提供白名单的机制. 对在白名单中的 URL 不进行过滤.

```go
func XSS(whitelistURLs []string) gin.HandlerFunc {
    // Do this once for each unique policy, and use the policy for the life of the
    // program Policy creation/editing is not safe to use in multiple goroutines.
    p := bluemonday.UGCPolicy()

    return func(c *gin.Context) {
        for _, u := range whitelistURLs {
            if strings.HasPrefix(c.Request.URL.String(), u) {
                c.Next()
                return
            }
        }

        sanitizedQuery, err := XSSFilterQuery(p, c.Request.URL.RawQuery)
        if err != nil {
            err = errors.Wrap(err, "filter query")
            c.Error(err)
            c.Abort()
            return
        }
        c.Request.URL.RawQuery = sanitizedQuery

        var sanitizedBody string
        bding := binding.Default(c.Request.Method, c.ContentType())
        body, err := c.GetRawData()
        if err != nil {
            err = errors.Wrap(err, "read body")
            c.Error(err)
            c.Abort()
            return
        }

        // XSSFilterJSON() will return error when body is empty.
        if len(body) == 0 {
            c.Next()
            return
        }

        switch bding {
        case binding.JSON:
            sanitizedBody, err = XSSFilterJSON(p, string(body))
            err = errors.Wrap(err, "filter json")
        case binding.FormMultipart:
            sanitizedBody = XSSFilterPlain(p, string(body))
        case binding.Form:
            sanitizedBody, err = XSSFilterQuery(p, string(body))
            err = errors.Wrap(err, "filter form")
        }
        if err != nil {
            c.Error(err)
            c.Abort()
            return
        }
        c.Request.Body = ioutil.NopCloser(strings.NewReader(sanitizedBody))

        c.Next()
    }
}
```


## 总结 {#总结}

这个简单的 XSS 中间件总共也就 100 多行代码, 相比 `XssMw` 的 600 多行少了很多, 不过基本功
能差别不大, 有以下几点可以继续优化.

1.  更强大的白名单过滤, 支持类似 `/posts/{id}/comments` URL
2.  解决纯文本过滤中的 `HTML` 转义问题.
3.  支持 `XML`, `MessagePack` 格式

[^fn:1]: [GitHub - dvwright/xss-mw: XssMw is an middleware designed to "auto remove XSS...](https://github.com/dvwright/xss-mw)
[^fn:2]: [GitHub - microcosm-cc/bluemonday: bluemonday: a fast golang HTML sanitizer (i...](https://github.com/microcosm-cc/bluemonday)
