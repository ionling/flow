+++
title = "OpenTelemetry 指东"
date = 2022-09-14T18:23:36+08:00
draft = false
+++

# OpenTelemetry 指东 (以 Golang 为例)

## OpenTelemetry

[OpenTelemetry] is a collection of tools, APIs, and SDKs. Use it to instrument,
generate, collect, and export telemetry data (metrics, logs, and traces) to help you
analyze your software’s performance and behavior.[^1]

使用 [OpenTelemetry] 可以了解很多系统运行的信息, 这些数据可以分成三类: Traces, Metrics,
Logs, 分别代表链路追踪, 应用的指标与日志. 在 OTel 中这些类别被称为
[Signals](https://opentelemetry.io/docs/concepts/signals/).

我们先通过一个 demo 看看 OpenTelemetry 到底是啥:

以下截图来自 [Uptrace] 的 [Demo](https://app.uptrace.dev/play).

1.链路追踪:
![trace-timelines](https://user-images.githubusercontent.com/20399569/187582125-ab7fbd86-bf36-4313-804d-f9a06968a92c.png)
![trace-attributes](https://user-images.githubusercontent.com/20399569/189274190-a62cb72d-dec6-48e7-90b7-4dc057e53c0b.png)

1.1 热力图:
![heatmap](https://user-images.githubusercontent.com/20399569/189274313-7446853e-1d77-4030-be12-27b71e8d9180.png)

1.2 直方图:
![histogram](https://user-images.githubusercontent.com/20399569/189274484-46325fd1-14b0-4752-b4ca-9de3d7c4bd20.png)

2.度量:
![metrics](https://user-images.githubusercontent.com/20399569/187582983-4646a8ea-c3ac-438d-81f2-b82418376ad7.png)

3.日志:
![logs](https://user-images.githubusercontent.com/20399569/187583216-6240a3fd-4490-43c5-89b4-c4cac4203932.png)

这三部分对于一个系统来说都是很重要的部分, 链路追踪可以看到每个服务, 每个逻辑的耗时以及其
他属性, 比如 HTTP 请求的状态, IP 来自哪个位置等等. 度量可以用来收集一些系统指标. 日志就
更不用说了, 排查问题所必须的.

## Uptrace

### 介绍

[Uptrace] 是一个 OpenTelemetry 的工具, 同时支持 Traces, Metrics, Logs, 官网的介绍:

> All-in-one tool to optimize performance and monitor errors & logs

> Uptrace is a cost-effective tracing solution that helps you monitor, understand, and
> optimize complex distributed systems. Be confident in your production and deliver better
> code faster than ever.

选择这个工具的原因是因为他的文档很详细, 详细地对比各个竟品工具. 心想文档能写这么巴适, 做
的东西一定也不会差到哪里去. [Uptrace] 文档里面提到的 [SigNoz] 也不错, GitHub 都已经 7.5K
(20220901) 了. 虽然 Uptrace 只有 847 颗星, 但我还是觉得 Uptrace 是最棒的.

Uptrace 的比较文档:

- [Top 7 Free Distributed Tracing Tools [updated for 2022]](https://uptrace.dev/get/compare/distributed-tracing-tools.html)
- [Top 6 DataDog Competitors and Alternatives [2022 comparison]](https://uptrace.dev/get/compare/datadog-competitors.html)
- [Top Grafana Alternatives [comparison 2022]](https://uptrace.dev/get/compare/grafana-alternatives.html)
- [DataDog vs Prometheus [key features]](https://uptrace.dev/get/compare/datadog-vs-prometheus.html)

Uptrace 底层使用的数据库是 [ClickHouse], 相对于传统的行式数据库 (MySQL, Postgres) 来说,
它是列式的, 更适合 OLAP 场景.

## 名词解释

- OTel: OpenTelemetry
- OTLP: OpenTeLemetry Protocol
- Span: Trace 的最小单位, 包含时间, 以及其他各种属性

## 接入 SDK

Uptrace 提供了工具函数来接入他们自己的服务, 当然其本质就做一些初始化的工作, 底层还是
[opentelemetry-go], see [doc](https://uptrace.dev/docs/go.html):

```go
import "github.com/uptrace/uptrace-go/uptrace"

uptrace.ConfigureOpentelemetry(
    // copy your project DSN here or use UPTRACE_DSN env var
    uptrace.WithDSN("https://<key>@uptrace.dev/<project_id>"),
    uptrace.WithServiceName("myservice"),
    uptrace.WithServiceVersion("1.0.0"),
)
```

## Traces

Traces 就是链路追踪, 作用不再赘述, 我们直接开始接入链路吧.

### Trace Kratos

kratos 框架自带了 OpenTelemetry 支持, 仅需几行配置就可以接入, 直接加入 tracing 中间件即
可:

```go
import "github.com/go-kratos/kratos/v2/middleware/tracing"

func NewServer() {
	var opts = []grpc.ServerOption{
		grpc.Middleware(
			tracing.Server(),
		),
	}
}

func NewClient() {
	return grpc.DialInsecure(
		context.Background(),
		grpc.WithMiddleware(
			tracing.Client(),
		),
	)
}
```

### Trace Redis

go-redis 自带了 OTel 支持:

```go
import "github.com/go-redis/redis/extra/redisotel/v8"

func NewRDB() {
	rdb.AddHook(redisotel.NewTracingHook())
}
```

### Trace SQL

同样的使用 otelsql 就可以了:

```go
import "github.com/uptrace/opentelemetry-go-extra/otelsql"

func NewDB() {
	sqlDB, err := otelsql.Open(
		dbcf.Driver, source,
		otelsql.WithDBName(dbcf.Database),
		otelsql.WithDBSystem(dbcf.Driver),
	)
}
```

### Manual

看了上面的例子后, 大家可以发现对于一些场景的 trace 场景, 我们可以直接使用社区提供的库就
行了. 但有些情况下没有对应的 OTel 库, 或者觉得别人的库不是很方便, 这里就需要手动操作了.

这里就简简单单过一下, 详细的例子还是去参考
[官方文档](https://opentelemetry.io/docs/instrumentation/go/manual/)
和社区开源的 Instrumentation 库.

```go
import (
	"go.opentelemetry.io/otel"

	"go.opentelemetry.io/otel/trace"
)

func Demo(ctx context.Context) {
	// 使用全局 TracerProvider 创建一个新的 Tracer.
	tracer := otel.Tracer("tracer-name")
	ctx, span := tracer.Start(ctx, "span-name")
	defer span.End()

	// 设置 span status
	if err := do(); err != nil {
		span.SetStatus(codes.Error, err.Error())
		// RecordError() 不会设置 span status, 只是简单的记录一下错误.
		span.RecordError(err)
	}

	// 当你不想创建一个 span 时, 你可以从 ctx 中获取当前 span.
	span := trace.SpanFromContext(ctx)
	span.SetAttributes(attribute.Bool("is_true", true))
}
```

### Semantic Conventions

一个 Span 用户可以自己定义属性 (Attributes), 如果每个用户, 每个库, 每个软件都对同一个属
性 (例如 HTTP Method) 叫不同的名字, 那么就会造成混乱与很多不便, 所以我们需要一个规范来统
一些常见的属性. 这个规范就叫做
[Trace Semantic Conventions](https://opentelemetry.io/docs/reference/specification/trace/semantic_conventions/).
我们定义属性的时候, 就最好遵循这个规范, 这样也方便工具 (Uptrace 之类的) 处理.

## Logs

日志, 一个应用最基础的分析模块, 目前 Uptrace 的日志模块还不像专业的日志工具 (ELK) 那么好
用, 所以一般只记录 WARN 及以上等级的日志. 打印日志的时候需要 **带上** ctx, 这样才能保证
日志和对应链路是在关联的.

```go
import (
	"github.com/sirupsen/logrus"
	"github.com/uptrace/opentelemetry-go-extra/otellogrus"
)

func Demo(ctx context.Context) {
	/// logrus
	logrus.AddHook(otellogrus.NewHook(otellogrus.WithLevels(
		logrus.PanicLevel,
		logrus.FatalLevel,
		logrus.ErrorLevel,
		logrus.WarnLevel,
	)))
	logrus.WithContext(ctx).Log()
}
```

## Metrics

TODO

## Golang 中 Span 是怎样传递的?

### 进程内

Golang 中 Span 是存在 ctx 里面的, see
[code](https://github.com/open-telemetry/opentelemetry-go/blob/0078faeb0e84d44dced8230b251b260fb2b912e5/trace/context.go#L48):

```go
// SpanFromContext returns the current Span from ctx.
//
// If no Span is currently set in ctx an implementation of a Span that
// performs no operations is returned.
func SpanFromContext(ctx context.Context) Span {
	if ctx == nil {
		return noopSpan{}
	}
	if span, ok := ctx.Value(currentSpanKey).(Span); ok {
		return span
	}
	return noopSpan{}
}
```

因此在 tracing 的时候, 也比较麻烦, 需要将 `context.Context` 一直往下传递, 因为 span 存在
ctx 里面 如果本身的旧代码比如 DB 操作函数不支持 ctx 参数的话, 是无法做 tracing 的, 有的
只是几个零散的 span.

一些其他语言, 平台 (Java, .NET) 提供的语言特性 (比如 thread-local variable), 可以很方便
的进行 tracing, 感兴趣的可以阅读下面的例子:

- [Java manual Instrumentation](https://opentelemetry.io/docs/instrumentation/java/manual/)
- [.NET manual Instrumentation](https://opentelemetry.io/docs/instrumentation/net/manual/)

### 进程外

不同的进程间进行通信, 需要将 context 从一个进程传播 (propagate) 到另外一个进程里. 怎么传
播呢, 这时候我们就需要载体 (Carrier) 和传播者 (Propagator) , 一般来说, Propagator 使用
OTel 内置的, HTTP 的 Carrier 是 Header, gRPC 的 Carrier 是 Metadata. Propagator 把
`trace_id`, `span_id` 还有其他信息放到 (Inject) Carrier 中, 在新的进程里 Propagator 把这
些信息取出来 (Extract), 这样就完成了一次链路的传播.

目前 OTel 只定义了文本类型的 Carrier 和 Propagator, see
[code](https://github.com/open-telemetry/opentelemetry-go/blob/9c2a0c2d6983cf3db6bb1432dc7d7bf3e391b852/propagation/propagation.go#L15):

```go
// TextMapCarrier is the storage medium used by a TextMapPropagator.
type TextMapCarrier interface {
	// Get returns the value associated with the passed key.
	Get(key string) string

	// Set stores the key-value pair.
	Set(key string, value string)

	// Keys lists the keys stored in this carrier.
	Keys() []string
}

// TextMapPropagator propagates cross-cutting concerns as key-value text
// pairs within a carrier that travels in-band across process boundaries.
type TextMapPropagator interface {
	// Inject set cross-cutting concerns from the Context into the carrier.
	Inject(ctx context.Context, carrier TextMapCarrier)

	// Extract reads cross-cutting concerns from the carrier into a Context.
	Extract(ctx context.Context, carrier TextMapCarrier) context.Context

	// Fields returns the keys whose values are set with Inject.
	Fields() []string
}
```

## 编写能够被追踪的代码

前面已经分析过 Golang 中的 OTel 的实现基于 Context, 所以我们编写的函数, 最好都加上 ctx
参数, 一般的 API 服务就是框架, 数据层, 日志三层, 还有可能比较耗时, 需要进行分析调优的地
方都加上, 方便以后扩展.

## 扩展阅读

- 寻找 OTel 相关的库, 插件, 可以去: [Registry](https://opentelemetry.io/registry/)
- 想要了解 OpenTelemetry 的历史与未来, 可以看: [OpenTelemetry-可观察性的新时代-阿里云开发者社区](https://developer.aliyun.com/article/710154)

## 参考资料

- [Sentry+OpenTelemetry 前后端全链路打通总结 · Yeqown](https://yeqown.xyz/2021/12/15/Sentry-OpenTelemetry%E5%89%8D%E5%90%8E%E7%AB%AF%E5%85%A8%E9%93%BE%E8%B7%AF%E6%89%93%E9%80%9A%E6%80%BB%E7%BB%93/)
- [得物云原生全链路追踪 Trace2.0 架构实践 · 得物技术](https://xie.infoq.cn/article/8f4b171b1992c6d95e4426230)

[^1]: https://opentelemetry.io/

[opentelemetry]: https://opentelemetry.io/
[uptrace]: https://uptrace.dev/
[signoz]: https://signoz.io/
[clickhouse]: https://clickhouse.com/
[opentelemetry-go]: https://github.com/open-telemetry/opentelemetry-go
