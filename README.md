# SWRouter

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-✓-4BC51D.svg)](https://cocoapods.org)

一个基于Swinject的iOS路由框架，提供类型安全的路由管理和依赖注入功能。

## 🌟 特性

- **类型安全**: 使用Swift的强类型系统，编译时检查路由参数
- **依赖注入**: 基于Swinject的依赖注入容器
- **错误处理**: 完善的错误处理机制，支持开发和生产环境
- **灵活配置**: 支持无参数、单参数、多参数路由
- **线程安全**: 线程安全的单例模式
- **易于使用**: 简洁的API设计，易于集成和使用

## 📋 要求

- iOS 9.0+
- Swift 5.0+
- Xcode 12.0+

## 🚀 安装

### CocoaPods

```ruby
pod 'SWRouter'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/your-username/SWRouter.git", from: "1.0.0")
]
```

## 📖 快速开始

### 1. 定义路由键

```swift
enum RouteKey: RoutableKey {
    case home
    case detail
    case profile
    case settings
    
    var routeKey: String {
        switch self {
        case .home: return "home"
        case .detail: return "detail"
        case .profile: return "profile"
        case .settings: return "settings"
        }
    }
}
```

### 2. 注册路由

```swift
// 在AppDelegate中注册路由
func setupRouter() {
    let router = Router.shared
    
    // 无参数路由
    router.register(UIViewController.self, route: RouteKey.home) { resolver in
        return HomeViewController()
    }
    
    // 单参数路由
    router.register(UIViewController.self, route: RouteKey.detail) { resolver, userId in
        return DetailViewController(userId: userId)
    }
    
    // 多参数路由
    router.register(UIViewController.self, route: RouteKey.profile) { resolver, userId, isEditable in
        return ProfileViewController(userId: userId, isEditable: isEditable)
    }
}
```

### 3. 使用路由

```swift
// 无参数跳转
pushRoute(RouteKey.home, animated: true)

// 单参数跳转
pushRoute(RouteKey.detail, arg: "user123")

// 多参数跳转
pushRoute(RouteKey.profile, arguments: "user123", true)

// Present方式跳转
presentRoute(RouteKey.detail, arg: "user123", animated: true)
```

## 🔧 核心功能

### 路由注册

支持多种参数类型的路由注册：

```swift
// 无参数
router.register(UIViewController.self, route: RouteKey.home) { resolver in
    return HomeViewController()
}

// 单参数
router.register(UIViewController.self, route: RouteKey.detail) { resolver, userId in
    return DetailViewController(userId: userId)
}

// 双参数
router.register(UIViewController.self, route: RouteKey.profile) { resolver, userId, isEditable in
    return ProfileViewController(userId: userId, isEditable: isEditable)
}

// 三参数
router.register(UIViewController.self, route: RouteKey.settings) { resolver, userId, section, isAdmin in
    return SettingsViewController(userId: userId, section: section, isAdmin: isAdmin)
}
```

### 依赖注入

```swift
// 注册服务
router.container.register(UserService.self) { _ in
    return UserService()
}

// 在路由中使用依赖
router.register(UIViewController.self, route: RouteKey.userList) { resolver in
    let userService = resolver.resolve(UserService.self)!
    return UserListViewController(userService: userService)
}
```

### 错误处理

```swift
// 手动处理路由结果
switch Router.shared.viewController(for: route) {
case .success(let vc):
    navigationController?.pushViewController(vc, animated: true)
case .failure(let error):
    handleRouterError(error)
}

// 自动错误处理（在UIViewController扩展中）
pushRoute(RouteKey.detail, arg: "user123") // 自动处理错误
```

## 🎯 高级功能

### 条件路由

```swift
let isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")

if isAdmin {
    router.register(UIViewController.self, route: RouteKey.admin) { resolver in
        return AdminViewController()
    }
} else {
    router.register(UIViewController.self, route: RouteKey.user) { resolver in
        return UserViewController()
    }
}
```

### 工厂模式路由

```swift
enum ProductType {
    case electronics, clothing, books
}

router.register(UIViewController.self, route: RouteKey.product) { (resolver, productType: ProductType) in
    switch productType {
    case .electronics:
        return ElectronicsViewController()
    case .clothing:
        return ClothingViewController()
    case .books:
        return BooksViewController()
    }
}
```

### 链式依赖注入

```swift
// 注册网络服务
router.container.register(NetworkService.self) { _ in
    return NetworkService()
}

// 注册数据服务，依赖网络服务
router.container.register(DataService.self) { resolver in
    let networkService = resolver.resolve(NetworkService.self)!
    return DataService(networkService: networkService)
}

// 注册视图控制器，依赖数据服务
router.register(UIViewController.self, route: RouteKey.data) { resolver in
    let dataService = resolver.resolve(DataService.self)!
    return DataViewController(dataService: dataService)
}
```

### 动态路由

```swift
let dynamicRoutes = [
    "feature1": Feature1ViewController.self,
    "feature2": Feature2ViewController.self,
    "feature3": Feature3ViewController.self
]

for (key, viewControllerType) in dynamicRoutes {
    router.register(viewControllerType, route: DynamicRouteKey(key: key)) { resolver in
        return viewControllerType.init()
    }
}
```

### 路由拦截器

```swift
router.register(UIViewController.self, route: RouteKey.secure) { resolver in
    // 检查用户是否已登录
    if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
        // 如果未登录，返回登录页面
        return LoginViewController()
    }
    return SecureViewController()
}
```

## 🛠️ API 参考

### Router

```swift
public class Router {
    static public let shared: Router
    
    // 视图控制器获取方法
    public func viewController(for route: RoutableKey) -> Result<UIViewController, RouterError>
    public func viewController<A>(for route: RoutableKey, arg: A) -> Result<UIViewController, RouterError>
    public func viewController<A, B>(for route: RoutableKey, arguments arg1: A, _ arg2: B) -> Result<UIViewController, RouterError>
    public func viewController<A, B, C>(for route: RoutableKey, arguments arg1: A, _ arg2: B, _ arg3: C) -> Result<UIViewController, RouterError>
    
    // 路由注册方法
    public func register<Service>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver) -> Service)
    public func register<Service, A>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A) -> Service)
    public func register<Service, A, B>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A, B) -> Service)
    public func register<Service, A, B, C>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A, B, C) -> Service)
}
```

### UIViewController 扩展

```swift
extension UIViewController {
    // Push方法
    public func pushRoute(_ route: RoutableKey, animated: Bool = true)
    public func pushRoute<A>(_ route: RoutableKey, animated: Bool = true, arg: A)
    public func pushRoute<A, B>(_ route: RoutableKey, animated: Bool = true, arguments arg1: A, _ arg2: B)
    public func pushRoute<A, B, C>(_ route: RoutableKey, animated: Bool = true, arguments arg1: A, _ arg2: B, _ arg3: C)
    
    // Present方法
    public func presentRoute(_ route: RoutableKey, animated: Bool = true, completion: (() -> Void)? = nil)
    public func presentRoute<A>(_ route: RoutableKey, arg: A, animated: Bool = true, completion: (() -> Void)? = nil)
    public func presentRoute<A, B>(_ route: RoutableKey, arguments arg1: A, _ arg2: B, animated: Bool = true, completion: (() -> Void)? = nil)
    public func presentRoute<A, B, C>(_ route: RoutableKey, arguments arg1: A, _ arg2: B, _ arg3: C, animated: Bool = true, completion: (() -> Void)? = nil)
}
```

### RouterError

```swift
public enum RouterError: Error, LocalizedError, Equatable {
    case routeNotFound(String)
    case invalidParameters(String)
    case dependencyInjectionFailed(String)
    case middlewareBlocked(String)
    case invalidRouteKey(String)
}
```

## 📱 示例项目

查看 `Example/` 目录中的完整示例项目，包含：

- 基础路由功能演示
- 高级功能示例
- 错误处理演示
- 依赖注入示例
- 完整的测试用例

运行示例：

```bash
cd Example
pod install
open SWRouter.xcworkspace
```

## 🧪 测试

项目包含完整的测试套件：

```bash
# 运行所有测试
xcodebuild test -workspace Example/SWRouter.xcworkspace -scheme SWRouter-Example -destination 'platform=iOS Simulator,name=iPhone 14'
```

测试覆盖：
- ✅ 基础路由功能 (100%)
- ✅ 错误处理 (100%)
- ✅ 依赖注入 (100%)
- ✅ Container 扩展 (100%)
- ✅ 路由覆盖 (100%)
- ✅ 线程安全 (100%)
- ✅ 性能测试 (100%)
- ✅ 内存管理 (100%)

## 🔄 迁移指南

如果你正在从旧版本迁移，请参考 [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) 了解详细的迁移步骤。

主要变化：
- API返回类型从 `UIViewController?` 改为 `Result<UIViewController, RouterError>`
- 新增完善的错误处理机制
- 改进的依赖注入支持

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发环境设置

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

### 代码规范

- 遵循 Swift 官方代码规范
- 添加适当的注释和文档
- 确保所有测试通过
- 更新相关文档

## 📄 许可证

本项目基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

- [Swinject](https://github.com/Swinject/Swinject) - 依赖注入框架
- 所有贡献者和用户

## 📞 联系方式

- 项目主页: [GitHub](https://github.com/your-username/SWRouter)
- 问题反馈: [Issues](https://github.com/your-username/SWRouter/issues)
- 邮箱: your-email@example.com

---

⭐ 如果这个项目对你有帮助，请给它一个星标！
