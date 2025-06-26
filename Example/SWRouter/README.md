# SWRouter 示例项目

这个示例项目展示了如何使用 SWRouter 框架进行 iOS 应用的路由管理。

## 主要特性

### 1. 基础路由功能
- **无参数路由**: 简单的页面跳转
- **单参数路由**: 传递单个参数到目标页面
- **多参数路由**: 传递多个参数到目标页面
- **依赖注入**: 自动注入服务依赖

### 2. 高级功能
- **条件路由**: 根据用户权限动态注册不同的页面
- **工厂模式路由**: 根据参数类型创建不同的视图控制器
- **链式依赖注入**: 服务之间的依赖关系管理
- **动态路由**: 运行时动态注册路由
- **路由拦截器**: 权限验证和路由拦截

### 3. 错误处理
- **开发环境**: 显示详细的错误信息弹窗
- **生产环境**: 记录错误日志，显示用户友好的错误信息

## 项目结构

```
Example/SWRouter/
├── AppDelegate.swift          # 应用入口，路由注册
├── HomeViewController.swift   # 主页面，展示各种路由功能
├── RouteKey.swift            # 路由键定义
├── AdvancedExample.swift     # 高级功能示例
├── DetailViewController.swift # 详情页面（单参数）
├── ProfileViewController.swift # 个人资料页面（双参数）
├── SettingsViewController.swift # 设置页面（三参数）
├── UserListViewController.swift # 用户列表页面（依赖注入）
├── UserService.swift         # 用户服务
└── ViewController.swift      # 错误处理示例
```

## 使用方法

### 1. 路由注册

在 `AppDelegate.swift` 中注册路由：

```swift
// 注册无参数的视图控制器
router.register(UIViewController.self, route: RouteKey.home) { resolver in
    return HomeViewController()
}

// 注册带单个参数的视图控制器
router.register(UIViewController.self, route: RouteKey.detail) { resolver, userId in
    return DetailViewController(userId: userId)
}

// 注册带两个参数的视图控制器
router.register(UIViewController.self, route: RouteKey.profile) { resolver, userId, isEditable in
    return ProfileViewController(userId: userId, isEditable: isEditable)
}

// 注册带三个参数的视图控制器
router.register(UIViewController.self, route: RouteKey.settings) { resolver, userId, section, isAdmin in
    return SettingsViewController(userId: userId, section: section, isAdmin: isAdmin)
}
```

### 2. 路由使用

在视图控制器中使用路由：

```swift
// 无参数跳转
pushRoute(RouteKey.home, animated: true)

// 单参数跳转
pushRoute(RouteKey.detail, arg: "user123")

// 双参数跳转
pushRoute(RouteKey.profile, arguments: "user123", true)

// 三参数跳转
pushRoute(RouteKey.settings, arguments: "user123", "general", false)

// Present 方式跳转
presentRoute(RouteKey.detail, arg: "user123", animated: true)
```

### 3. 错误处理

新的 Router API 使用 `Result` 类型返回结果：

```swift
switch Router.shared.viewController(for: route) {
case .success(let vc):
    navigationController?.pushViewController(vc, animated: true)
case .failure(let error):
    handleRouterError(error)
}
```

### 4. 依赖注入

注册服务：

```swift
router.container.register(UserService.self) { _ in
    return UserService()
}
```

在路由中使用依赖：

```swift
router.register(UIViewController.self, route: RouteKey.userList) { resolver in
    let userService = resolver.resolve(UserService.self)!
    return UserListViewController(userService: userService)
}
```

## 高级功能示例

### 1. 条件路由

根据用户权限注册不同的页面：

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

### 2. 工厂模式路由

根据参数类型创建不同的视图控制器：

```swift
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

### 3. 链式依赖注入

服务之间的依赖关系：

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

### 4. 动态路由

运行时动态注册路由：

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

### 5. 路由拦截器

权限验证和路由拦截：

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

## 错误类型

SWRouter 定义了以下错误类型：

- `routeNotFound`: 路由未找到
- `invalidParameters`: 参数无效
- `dependencyInjectionFailed`: 依赖注入失败
- `middlewareBlocked`: 中间件拦截
- `invalidRouteKey`: 无效的路由键

## 运行示例

1. 打开 `SWRouter.xcworkspace`
2. 选择 `SWRouter-Example` target
3. 运行项目
4. 在主页面中点击不同的按钮来体验各种路由功能

## 注意事项

1. 确保在使用路由之前已经注册了相应的路由
2. 参数类型必须与注册时的类型匹配
3. 在开发环境中，路由错误会显示弹窗；在生产环境中，错误会被记录到日志中
4. 使用依赖注入时，确保所有依赖的服务都已经注册 