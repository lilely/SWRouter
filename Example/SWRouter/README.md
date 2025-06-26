# SWRouter 使用示例

这个示例项目展示了如何使用 SWRouter 进行路由管理和依赖注入。

## 功能特性

### 1. 基础路由功能
- **无参数路由**: 展示如何注册和跳转到不需要参数的视图控制器
- **单参数路由**: 展示如何传递单个参数到目标视图控制器
- **双参数路由**: 展示如何传递两个参数到目标视图控制器
- **三参数路由**: 展示如何传递三个参数到目标视图控制器
- **依赖注入**: 展示如何使用 Swinject 进行依赖注入

### 2. 高级路由功能
- **条件路由**: 根据条件动态注册不同的路由
- **工厂模式路由**: 使用工厂模式创建不同类型的视图控制器
- **链式依赖注入**: 展示复杂的依赖注入链
- **动态路由**: 运行时动态注册路由
- **路由拦截器**: 在路由跳转前进行权限检查

## 使用方法

### 1. 基础路由注册

在 `AppDelegate.swift` 中注册基础路由：

```swift
private func setupRouter() {
    let router = Router.shared
    
    // 注册无参数的视图控制器
    router.register(HomeViewController.self, route: RouteKey.home) { resolver in
        return HomeViewController()
    }
    
    // 注册带单个参数的视图控制器
    router.register(DetailViewController.self, route: RouteKey.detail) { resolver, userId in
        return DetailViewController(userId: userId)
    }
    
    // 注册带两个参数的视图控制器
    router.register(ProfileViewController.self, route: RouteKey.profile) { resolver, userId, isEditable in
        return ProfileViewController(userId: userId, isEditable: isEditable)
    }
    
    // 注册带三个参数的视图控制器
    router.register(SettingsViewController.self, route: RouteKey.settings) { resolver, userId, section, isAdmin in
        return SettingsViewController(userId: userId, section: section, isAdmin: isAdmin)
    }
    
    // 注册需要依赖注入的视图控制器
    router.register(UserListViewController.self, route: RouteKey.userList) { resolver in
        let userService = resolver.resolve(UserService.self) ?? UserService()
        return UserListViewController(userService: userService)
    }
    
    // 注册服务
    router.container.register(UserService.self) { _ in
        return UserService()
    }
}
```

### 2. 高级路由示例

#### 条件路由
```swift
// 根据用户权限注册不同的视图控制器
let isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")

if isAdmin {
    router.register(AdminViewController.self, route: RouteKey.admin) { resolver in
        return AdminViewController()
    }
} else {
    router.register(UserViewController.self, route: RouteKey.user) { resolver in
        return UserViewController()
    }
}
```

#### 工厂模式路由
```swift
// 使用工厂模式创建视图控制器
router.register(ProductViewController.self, route: RouteKey.product) { resolver, productType in
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

#### 链式依赖注入
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
router.register(DataViewController.self, route: RouteKey.data) { resolver in
    let dataService = resolver.resolve(DataService.self)!
    return DataViewController(dataService: dataService)
}
```

#### 动态路由
```swift
// 动态注册路由
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

#### 路由拦截器
```swift
// 注册需要认证的路由
router.register(SecureViewController.self, route: RouteKey.secure) { resolver in
    // 检查用户是否已登录
    if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
        // 如果未登录，返回登录页面
        return LoginViewController()
    }
    return SecureViewController()
}
```

### 3. 定义路由键

创建路由键枚举：

```swift
enum RouteKey: RoutableKey {
    case home
    case detail
    case profile
    case settings
    case userList
    case admin
    case user
    case product
    case data
    case secure
    
    var routeKey: String {
        switch self {
        case .home: return "home"
        case .detail: return "detail"
        case .profile: return "profile"
        case .settings: return "settings"
        case .userList: return "userList"
        case .admin: return "admin"
        case .user: return "user"
        case .product: return "product"
        case .data: return "data"
        case .secure: return "secure"
        }
    }
}
```

### 4. 使用路由跳转

在视图控制器中使用路由跳转：

```swift
// 无参数跳转
pushRoute(.detail, animated: true)

// 单参数跳转
pushRoute(.detail, arg: "user123")

// 双参数跳转
pushRoute(.profile, arguments: "user123", true)

// 三参数跳转
pushRoute(.settings, arguments: "user123", "general", false)

// 模态展示
presentRoute(.userList, animated: true)

// 工厂模式路由
pushRoute(.product, arg: ProductType.electronics)

// 动态路由
let dynamicKey = DynamicRouteKey(key: "feature1")
if let vc = Router.shared.viewController(for: dynamicKey) {
    navigationController?.pushViewController(vc, animated: true)
}
```

## 项目结构

```
Example/SWRouter/
├── AppDelegate.swift              # 应用代理，包含路由注册
├── ViewController.swift           # 主视图控制器
├── RouteKey.swift                # 路由键定义
├── HomeViewController.swift       # 首页视图控制器
├── DetailViewController.swift     # 详情页视图控制器
├── ProfileViewController.swift    # 个人资料视图控制器
├── SettingsViewController.swift   # 设置页视图控制器
├── UserListViewController.swift   # 用户列表视图控制器
├── UserService.swift             # 用户服务（依赖注入示例）
├── AdvancedExample.swift         # 高级示例代码
└── README.md                     # 说明文档
```

## 运行示例

1. 打开 `SWRouter.xcworkspace`
2. 选择 `SWRouter-Example` target
3. 运行项目
4. 在首页点击不同的按钮来体验各种路由功能

### 基础功能演示
- 点击"跳转到详情页"体验无参数路由
- 点击"跳转到个人资料"体验双参数路由
- 点击"跳转到设置页"体验三参数路由
- 点击"跳转到用户列表"体验依赖注入

### 高级功能演示
- 点击"高级示例"体验工厂模式、链式依赖、动态路由
- 点击"条件示例"体验条件路由
- 点击"安全示例"体验路由拦截器

## 注意事项

- 确保在 `AppDelegate` 中正确注册所有路由
- 路由键必须实现 `RoutableKey` 协议
- 依赖注入需要先注册服务，再注册视图控制器
- 使用 `pushRoute` 进行导航跳转，使用 `presentRoute` 进行模态展示
- 高级功能展示了Router的扩展性，可以根据实际需求进行定制 