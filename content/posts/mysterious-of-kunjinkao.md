+++
title = "锟斤拷之谜"
date = 2021-04-11T16:17:00+08:00
lastmod = 2021-04-11T16:17:22+08:00
draft = false
+++

## 前言 {#前言}

前段时间一位同学在群里问, 为什么他在 Windows 写的 matlab 代码在 Linux 下运行输出的日志文
件显示乱码了. 我把他发过来的日志文件用 utf8 编码打开, 出现了问号, 再用 gbk 编码打开, 就
出现了 "锟斤拷" 字样. 看到这三个字, 大概就知道是编码的问题了, 很常见.


## 原因 {#原因}

经过反复实验以及网上查阅资料, 大概弄清楚了原因, 可以参考以下代码:

```py
words = "一些文字"
print(f"original text: {words}")

utf8_decoded = words.encode("gbk").decode(errors="replace")
print(f"decode gbk encoded bytes with utf8: {utf8_decoded}")

gbk_decoded = utf8_decoded.encode().decode("gbk")
print(f"re-encode with utf8 and decode with gbk: {gbk_decoded}")
```

```text
original text: 一些文字
decode gbk encoded bytes with utf8: һЩ����
re-encode with utf8 and decode with gbk: 一些锟斤拷锟斤拷
```

我们先把一个中文字符串用 gbk 编码, 再用 utf8 解码, 这时就会就会出现问号, 接着, 再把这些
有问号的字符串用 utf8 编码, 接着 gbk 解码, 就会出现 "锟斤拷" 字样.

日志文件出现乱码的原因也就清楚了: 在 Winodws 上编写的代码格式是 gbk 的, 但是在 Linux 上
运行的时候是以 utf8 格式打开, 导致有部分无法解析的字节就变成了问号, 打印日志的时候就直接
把问号打印出来了. 我们再用 gbk 打开, 就变成了 "锟斤拷".


## 扩展 {#扩展}

编码中出现的 "�" 是 Unicode 中一个特殊字符, 叫做 replacement character, 码位(code point)
是 U+FFFD. 两个问号就可以解码成 gbk 中的 "锟斤拷", 代码:

```py
two_replace_chars = '\uFFFD'.encode() * 2
print(two_replace_chars)
print(two_replace_chars.decode())
print(two_replace_chars.decode('gbk'))
```

```text
b'\xef\xbf\xbd\xef\xbf\xbd'
��
锟斤拷
```

如果想要深入了解字符编码的相关知识, 推荐阅读: [彻底弄懂 Unicode编码 - 李宇仓 | Li Yucang](https://liyucang-git.github.io/2019/06/17/%E5%BD%BB%E5%BA%95%E5%BC%84%E6%87%82Unicode%E7%BC%96%E7%A0%81/)


## 参考链接 {#参考链接}

-   [Unicode HOWTO — Python 3.9.4 documentation](https://docs.python.org/3/howto/unicode.html)
-   [锟斤拷是什么？ - 舰长的回答 - 知乎](https://www.zhihu.com/question/23024782/answer/36719691)
-   [锟斤拷\_百度百科](https://baike.baidu.com/item/%E9%94%9F%E6%96%A4%E6%8B%B7)
