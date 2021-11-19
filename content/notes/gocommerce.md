+++
title = "GoCommerce"
date = 2021-11-19T00:00:00+08:00
lastmod = 2021-11-19T17:16:27+08:00
draft = false
+++

-   [netlify/gocommerce: A headless e-commerce for JAMstack sites](https://github.com/netlify/gocommerce)


## summary {#summary}

相对完整的一个 http 项目, 但也比较简单, 没有 mvc 分层, api 层直接调用 gorm 操作数据库,
所以说很简单.


## tech stack {#tech-stack}

| Use    | Package                 |
|--------|-------------------------|
| Router | github.com/go-chi/chi   |
| UUID   | github.com/pborman/uuid |


## contextKey {#contextkey}

context 的 key 实现有点意思, 实现了 Stringer 接口, 至于相对于直接用 string 的好处, 没想
明白.

```go
type contextKey string

func (c contextKey) String() string {
    return "api context key " + string(c)
}

const (
    tokenKey           = contextKey("jwt")
    configKey          = contextKey("config")
    couponsKey         = contextKey("coupons")
    requestIDKey       = contextKey("request_id")
    adminFlagKey       = contextKey("is_admin")
    mailerKey          = contextKey("mailer")
    // ...
)
```


## gcontext {#gcontext}

通过 `context.WithValue()` 来向 context 中设置值, 提供 get 函数来取对应的 value.

```go
// WithPaymentProviders adds the payment providers to the context.
func WithPaymentProviders(ctx context.Context, provs map[string]payments.Provider) context.Context {
    return context.WithValue(ctx, paymentProviderKey, provs)
}

// GetPaymentProviders reads the payment providers from the context
func GetPaymentProviders(ctx context.Context) map[string]payments.Provider {
    provs, _ := ctx.Value(paymentProviderKey).(map[string]payments.Provider)
    return provs
}
```


## health check {#health-check}

Just a get api returns some server info:

```go
// HealthCheck endpoint
func (a *API) HealthCheck(w http.ResponseWriter, r *http.Request) error {
    return sendJSON(w, http.StatusOK, map[string]string{
        "version":     a.version,
        "name":        "GoCommerce",
        "description": "GoCommerce is a flexible Ecommerce API for JAMStack sites",
    })
}
```


## request id {#request-id}

```go
func withRequestID(w http.ResponseWriter, r *http.Request) (context.Context, error) {
    id := uuid.NewRandom().String()
    ctx := r.Context()
    ctx = gcontext.WithRequestID(ctx, id)
    return ctx, nil
}
```


## routes {#routes}

简单地封装了一下 chi, 入口函数: `NewAPIWithVersion()`.

gocommerce 的 apiHandler 实际上就是标准库的 HandlerFunc 加了一个 error 返回值:

```go
type apiHandler func(w http.ResponseWriter, r *http.Request) error

// net/http
type HandlerFunc func(ResponseWriter, *Request)
```


## service exit {#service-exit}

就是起一个协程, 监听系统信号, 如果有信号, 就调用 `server.Shutdown()` 退出:

```go
// WaitForShutdown blocks until the system signals termination or done has a value
func waitForTermination(log logrus.FieldLogger, done <-chan struct{}) {
    signals := make(chan os.Signal, 1)
    signal.Notify(signals, os.Interrupt, syscall.SIGTERM, syscall.SIGINT)
    select {
    case sig := <-signals:
        log.Infof("Triggering shutdown from signal %s", sig)
    case <-done:
        log.Infof("Shutting down...")
    }
}
```
