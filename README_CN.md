

<p align="center">
    <img height="80" src="image/Guardian.png"/>
    <br>
    <br>
    <a href="https://github.com/Jinxiansen/Guardian">
        <img src="https://img.shields.io/badge/Guardian-1.0.5-brightgreen.svg" alt="Guardian Version">
    </a>
    <a href="http://swift.org">
        <img src="https://img.shields.io/badge/Swift-4.1-brightgreen.svg" alt="Swift Version">
    </a>
    <a href="http://vapor.codes">
        <img src="https://img.shields.io/badge/Vapor-3-F6CBCA.svg" alt="Vapor Version">
    </a>
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="GitHub license">
    </a>
</p>

### [[English]](README.md)

**Guardian** 是一个基于 Swift 服务端框架 **[Vapor 3](https://vapor.codes)** 的 Middleware，它根据IP地址 + 访问的 URL 来限制自客户端的请求数量,支持自定义返回数据类型。
它的工作原理是将客户端 IP 地址添加到缓存中，并计算客户端在添加 GuardianMiddleware 时定义的生命周期内可以做出的请求次数，并在达到限制时返回 HTTP 429（太多请求）。 当限制时间过了后，可以重新发起请求。

> 考虑到如果局域网内公用1个 IP 地址，可以适当增大单位阈值。


## 安装 📦

更新你的 `Package.swift` 文件：

```swift
.package(url: "https://github.com/Jinxiansen/Guardian.git", from: "3.0.0")
```


## 使用 🚀

### 使用方法有两种：

* **全局使用：**

`Guardian ` 可配置的字段：最大访问次数、时间单位和要使用的缓存。
 如果你不提供自己的缓存，Guardian 将自行创建在内存缓存。

```swift
let guardian = GuardianMiddleware(rate: Rate(limit: 20, interval: .minute)) //例如：每个 api 地址每分钟限20次调用

```

在 `configure.swift` 

1. **导入头文件**

```swift
import Guardian
```

2. **在 services 注册之前加入**

```swift
var middlewares = MiddlewareConfig() 

middlewares.use(GuardianMiddleware(rate: Rate(limit: 22, interval: .minute)))

services.register(middlewares)

```


#### 方法二：

* **局部使用：**

#### 将中间件添加到路由组

```Swift
let group = router.grouped(GuardianMiddleware(rate: Rate(limit: 25, interval: .minute)))

group.get("welcome") { req in
    return "hello,world !"
}
```


### 支持自定义返回数据 📌
**Guardian** 增加了对自定义返回数据的支持，如下例所示:

返回一个 **JSON** 对象。

```Swift
middlewares.use(GuardianMiddleware(rate: Rate(limit: 20, interval: .minute), closure: { (req) -> EventLoopFuture<Response>? in
	let view = ["result":"429","message":"The request is too fast. Please try again later!"]
	return try view.encode(for: req)
}))
```

或返回**leaf/Html** * web页面，

```Swift 
middlewares.use(GuardianMiddleware(rate: Rate(limit: 25, interval: .minute), closure: { (req) -> EventLoopFuture<Response>? in
	let view = try req.view().render("leaf/busy")
	return try view.encode(for: req)
}))
```

或者 自定义返回其他类型数据...

#### Rate.Interval 的枚举类型

目前支持设置的时间单位有：

```swift
case .second
case .minute
case .hour
case .day
```

## Contacts	![](image/zz.jpg)

#### 如果有什么疑问和建议可以提1个 [Issues](https://github.com/Jinxiansen/Guardian/issues) 或联系我：
Email : [@晋先森](hi@jinxiansen.com)

Twitter : [@Jinxiansen](https://twitter.com/jinxiansen)

## License 📄


Guardian is released under the [MIT license](LICENSE). See LICENSE for details.
