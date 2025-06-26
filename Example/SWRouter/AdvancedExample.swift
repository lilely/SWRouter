//
//  AdvancedExample.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import UIKit
import SWRouter

// MARK: - 高级路由示例
class AdvancedExample {
    
    // MARK: - 1. 条件路由示例
    static func setupConditionalRoutes() {
        let router = Router.shared
        
        // 根据用户权限注册不同的视图控制器
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
    }
    
    // MARK: - 2. 工厂模式路由示例
    static func setupFactoryRoutes() {
        let router = Router.shared
        
        // 使用工厂模式创建视图控制器
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
    }
    
    // MARK: - 3. 链式依赖注入示例
    static func setupChainedDependencies() {
        let router = Router.shared 
        
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
    }
    
    // MARK: - 4. 动态路由示例
    static func setupDynamicRoutes() {
        let router = Router.shared
        
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
    }
    
    // MARK: - 5. 路由拦截器示例
    static func setupRouteInterceptor() {
        let router = Router.shared
        
        // 注册需要认证的路由
        router.register(UIViewController.self, route: RouteKey.secure) { resolver in
            // 检查用户是否已登录
            if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
                // 如果未登录，返回登录页面
                return LoginViewController()
            }
            return SecureViewController()
        }
    }
}

// MARK: - 动态路由键
struct DynamicRouteKey: RoutableKey {
    let key: String
    
    var routeKey: String {
        return key
    }
}

// MARK: - 示例视图控制器
class AdminViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "管理员页面"
        
        let label = UILabel()
        label.text = "这是管理员专用页面"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

class UserViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        title = "用户页面"
        
        let label = UILabel()
        label.text = "这是普通用户页面"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

enum ProductType {
    case electronics
    case clothing
    case books
}

class ProductViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        title = "产品页面"
    }
}

class ElectronicsViewController: ProductViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "电子产品"
        
        let label = UILabel()
        label.text = "电子产品页面"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

class ClothingViewController: ProductViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "服装"
        
        let label = UILabel()
        label.text = "服装页面"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

class BooksViewController: ProductViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图书"
        
        let label = UILabel()
        label.text = "图书页面"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

// MARK: - 服务类
class NetworkService {
    func fetchData() -> String {
        return "网络数据"
    }
}

class DataService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getData() -> String {
        return networkService.fetchData()
    }
}

class DataViewController: UIViewController {
    private let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        title = "数据页面"
        
        let label = UILabel()
        label.text = dataService.getData()
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

class Feature1ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        title = "功能1"
        
        let label = UILabel()
        label.text = "动态路由 - 功能1"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

class Feature2ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        title = "功能2"
        
        let label = UILabel()
        label.text = "动态路由 - 功能2"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

class Feature3ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        title = "功能3"
        
        let label = UILabel()
        label.text = "动态路由 - 功能3"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

class SecureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "安全页面"
        
        let label = UILabel()
        label.text = "这是安全页面，需要登录才能访问"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        title = "登录页面"
        
        let label = UILabel()
        label.text = "请先登录"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}
