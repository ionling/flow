+++
title = "Golang Multi Errors"
date = 2023-02-14T15:38:00+08:00
lastmod = 2023-02-14T15:39:46+08:00
draft = false
+++

Golang 默认不支持 wrap 多个 err, 可以手动拼接字符串:
`fmt.Errorf("err1: %s, err2: %s", err1, err2)`.
但是这样会丢失原来 error 的信息, `errors.Is()` 与 `errors.As()` 也失效了.
有一些第三方库实现了这个功能:

1.  [GitHub - uber-go/multierr: Combine one or more Go errors together](https://github.com/uber-go/multierr)
2.  [GitHub - hashicorp/go-multierror: A Go (golang) package for representing a li...](https://github.com/hashicorp/go-multierror)

阅读了它们的源码后, 感觉 Uber 的实现更方便点,
Hashicorp 的需要手动 `Unwrap()` 之后才能[支持](https://github.com/hashicorp/go-multierror/blob/f5ce595699358810928e7b02198c3d230901798f/multierror.go#L82) `errors.Is()`, `errors.As()`,
并且, 他的这个实现也只对[第一个错误](https://github.com/hashicorp/go-multierror/blob/f5ce595699358810928e7b02198c3d230901798f/multierror.go#L115)进行了支持. 怪不得 [otelcol](https://github.com/open-telemetry/opentelemetry-collector-contrib) [不使用](https://github.com/open-telemetry/opentelemetry-collector-contrib/pull/13763) Hashicorp 的实现.

1.20 官方[支持了](https://tip.golang.org/doc/go1.20#errors) wrap 多个 error, 如果只是简单的 wrap errors 就可以不使用第三方包了,
(第三方包里的一些工具函数还是挺方便的):

```go
func Example() {
    err1 := errors.New("error1")
    err2 := errors.New("error2")
    err := fmt.Errorf("err1: %w, err2: %w", err1, err2)
    // Or
    err = errors.Join(err1, err2)
}
```

参考链接:

-   [Go: Multiple Errors Management. Error management in Go is always prone… | by ...](https://medium.com/a-journey-with-go/go-multiple-errors-management-a67477628cf1)
-   [Collect and handle multiple errors in Go](https://gist.github.com/grahamking/51beb2bc5ae8fbbc06ae7341f3381d64)
