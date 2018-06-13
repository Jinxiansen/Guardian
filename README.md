
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


### [《中文版🇨🇳》](README_CN.md)

Guardian is a **[Vapor 3](https://vapor.codes)** based Middleware that limits the number of requests from the client based on the **IP address + access URL**.
It works by adding the client's IP address to the cache and counting the number of requests that the client can make within the lifecycle defined when the GuardianMiddleware is added, and returns HTTP 429 (too many requests) when the limit is reached. After the time limit expires, the request can be re-initiated,And support custom return data. 
The reason Guardian generates is because [gatekeeper](https://github.com/nodes-vapor/gatekeeper) only supports vapor 2 , thanks very much to the original author! 🍺

> Consider that if there is a public IP address in the LAN, increase the unit threshold appropriately.


## Installation 📦

Update your `Package.swift` file:

```swift
.package(url: "https://github.com/Jinxiansen/Guardian.git", from: "3.0.0")
```


## Usage 🚀

### There are two ways to use：

* **Global use：**


`Guardian` Configurable fields: Maximum number of visits, time units, and cache to use.

If you do not provide your own cache, Guardian will create its own memory cache.

```swift
// Each api URL is limited to 20 times per minute
let guardian = GuardianMiddleware(rate: Rate(limit: 20, interval: .minute)) 
```
or 


on `configure.swift`

1. **Import header files**

```swift
import Guardian
```

2. **Join before services**

```swift

var middlewares = MiddlewareConfig() 

middlewares.use(GuardianMiddleware(rate: Rate(limit: 25, interval: .minute), closure: { (req) -> EventLoopFuture<Response>? in
	let view = ["result":"429","message":"The request is too fast. Please try again later!"]
	return try view.encode(for: req)
}))

services.register(middlewares)

```


#### Method Two:

* **Routing group use:**

#### Adding Middleware to a Routing Group

```Swift
 
let group = router.grouped(GuardianMiddleware(rate: Rate(limit: 25, interval: .minute)))

group.get("welcome") { req in
    return "hello,world !"
}
```

### Support custom return data 📌
Guardian adds support for custom return data, as in the following example:

Return a **JSON** object:

```Swift
middlewares.use(GuardianMiddleware(rate: Rate(limit: 20, interval: .minute), closure: { (req) -> EventLoopFuture<Response>? in
	let view = ["result":"429","message":"The request is too fast. Please try again later!"]
	return try view.encode(for: req)
}))
```

or return a **Leaf/Html** web page:

```Swift 
middlewares.use(GuardianMiddleware(rate: Rate(limit: 25, interval: .minute), closure: { (req) -> EventLoopFuture<Response>? in
	let view = try req.view().render("leaf/busy")
	return try view.encode(for: req)
}))
```

or Custom returns other types of data...

### Rate.Interval Enumeration types

Currently supported setup intervals are:

```swift
case .second
case .minute
case .hour
case .day
```

## Contacts	![](image/zz.jpg)

#### If you have any questions or suggestions you can raise one [Issues](https://github.com/Jinxiansen/Guardian/issues) or contact me:
Email : [@JinXiansen](hi@jinxiansen.com)

Twitter : [@Jinxiansen](https://twitter.com/jinxiansen)

## License 📄


Guardian is released under the [MIT license](LICENSE). See LICENSE for details.
