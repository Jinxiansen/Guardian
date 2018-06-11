
# Guardian 🦁
[![Swift Version](https://img.shields.io/badge/Swift-4-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-3-F6CBCA.svg)](http://vapor.codes)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Guardian 是一个基于 Swift 服务端框架 **[Vapor 3](https://vapor.codes)** 的 Middleware，它根据IP地址 + 访问的 URL 来限制自客户端的请求数量。
它的工作原理是将客户端 IP 地址添加到缓存中，并计算客户端在添加 GuardianMiddleware 时定义的生命周期内可以做出的请求次数，并在达到限制时返回 HTTP 429（太多请求）。 当限制时间过了后，可以重新发起请求。

> 考虑到如果局域网内公用1个 IP 地址，可以适当增大单位阈值。


## 📦 安装

更新你的 `Package.swift` 文件：

```swift
.package(url: "https://github.com/Jinxiansen/Guardian.git", from: "1.0.5")
```


## 使用 🚀

### 使用方法有两种：

* **全局使用：**

`Guardian ` 有两个可配置的字段：最大频率及时间单位和要使用的缓存。
 如果你不提供自己的缓存，Guardian 将创建自己的内存缓存。

```swift
let guardian = GuardianMiddleware(rate: Rate(limit: 20, interval: .minute))

```

1. **导入头文件**

```swift
import Guardian
```

2. **在 services 注册之前加入**

```swift
var middlewares = MiddlewareConfig() 

middlewares.use(GuardianMiddleware.init(rate: Rate(limit: 2, interval: .minute)))

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


### Rate.Interval 的枚举类型

目前支持设置的时间间隔有：

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


JHUD is released under the [MIT license](LICENSE). See LICENSE for details.
