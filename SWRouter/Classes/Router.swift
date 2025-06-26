//
//  Router.swift
//  Haven
//
//  Created by User on 2025/2/18.
//

import UIKit
import Swinject

// MARK: - Router Errors
public enum RouterError: Error, LocalizedError, Equatable {
    case routeNotFound(String)
    case invalidParameters(String)
    case dependencyInjectionFailed(String)
    case middlewareBlocked(String)
    case invalidRouteKey(String)
    
    public var errorDescription: String? {
        switch self {
        case .routeNotFound(let route):
            return "路由未找到: \(route)"
        case .invalidParameters(let message):
            return "参数无效: \(message)"
        case .dependencyInjectionFailed(let message):
            return "依赖注入失败: \(message)"
        case .middlewareBlocked(let message):
            return "中间件拦截: \(message)"
        case .invalidRouteKey(let key):
            return "无效的路由键: \(key)"
        }
    }
    
    public static func == (lhs: RouterError, rhs: RouterError) -> Bool {
        switch (lhs, rhs) {
        case (.routeNotFound(let lhsRoute), .routeNotFound(let rhsRoute)):
            return lhsRoute == rhsRoute
        case (.invalidParameters(let lhsMessage), .invalidParameters(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.dependencyInjectionFailed(let lhsMessage), .dependencyInjectionFailed(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.middlewareBlocked(let lhsMessage), .middlewareBlocked(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.invalidRouteKey(let lhsKey), .invalidRouteKey(let rhsKey)):
            return lhsKey == rhsKey
        default:
            return false
        }
    }
}

public protocol RoutableKey {
    var routeKey: String { get }
}

protocol Routable {
    func viewController(for route: RoutableKey) -> Result<UIViewController, RouterError>
}

public class Router: Routable {
    
    static public let shared = Router()
    
    // 使用线程安全的单例模式
    private static let container: Container = {
        return Container()
    }()
    
    public var container: Container {
        return Self.container
    }
    
    private init() {} // Make init private to enforce singleton pattern
    
    // MARK: - 改进的视图控制器获取方法
    public func viewController(for route: RoutableKey) -> Result<UIViewController, RouterError> {
        return container.resolveRoute(key: route)
    }
    
    public func viewController<A>(for route: RoutableKey, arg: A) -> Result<UIViewController, RouterError> {
        return container.resolveRoute(key: route, argument: arg)
    }
    
    public func viewController<A, B>(for route: RoutableKey, arguments arg1: A, _ arg2: B) -> Result<UIViewController, RouterError> {
        return container.resolveRoute(key: route, arguments: arg1, arg2)
    }
    
    public func viewController<A, B, C>(for route: RoutableKey, arguments arg1: A, _ arg2: B,  _ arg3: C) -> Result<UIViewController, RouterError> {
        return container.resolveRoute(key: route, arguments: arg1, arg2, arg3)
    }
    
    // MARK: - 注册方法保持不变
    public func register<Service>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver) -> Service) {
        self.container.register(serviceType, route:route, factory: factory)
    }
    
    public func register<Service, A>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A) -> Service) {
        self.container.register(serviceType, route: route, factory: factory)
    }
    
    public func register<Service, A, B>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A, B) -> Service) {
        self.container.register(serviceType, route: route, factory: factory)
    }
    
    public func register<Service, A, B, C>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A, B, C) -> Service) {
        self.container.register(serviceType, route: route, factory: factory)
    }
}

// MARK: - 改进的UIViewController扩展
extension UIViewController {
    
    // MARK: - Push方法
    public func pushRoute(_ route: RoutableKey, animated: Bool = true) {
        switch Router.shared.viewController(for: route) {
        case .success(let vc):
            self.navigationController?.pushViewController(vc, animated: animated)
        case .failure(let error):
            handleRouterError(error)
        }
    }
    
    public func pushRoute<A>(_ route: RoutableKey, animated: Bool = true, arg: A) {
        switch Router.shared.viewController(for: route, arg: arg) {
        case .success(let vc):
            self.navigationController?.pushViewController(vc, animated: animated)
        case .failure(let error):
            handleRouterError(error)
        }
    }
    
    public func pushRoute<A, B>(_ route: RoutableKey, animated: Bool = true, arguments arg1: A, _ arg2: B) {
        switch Router.shared.viewController(for: route, arguments: arg1, arg2) {
        case .success(let vc):
            self.navigationController?.pushViewController(vc, animated: animated)
        case .failure(let error):
            handleRouterError(error)
        }
    }
    
    public func pushRoute<A, B, C>(_ route: RoutableKey, animated: Bool = true, arguments arg1: A, _ arg2: B,  _ arg3: C) {
        switch Router.shared.viewController(for: route, arguments: arg1, arg2, arg3) {
        case .success(let vc):
            self.navigationController?.pushViewController(vc, animated: animated)
        case .failure(let error):
            handleRouterError(error)
        }
    }
    
    // MARK: - Present方法
    public func presentRoute(_ route: RoutableKey, animated: Bool = true, completion: (() -> Void)? = nil) {
        switch Router.shared.viewController(for: route) {
        case .success(let vc):
            self.present(vc, animated: animated, completion: completion)
        case .failure(let error):
            handleRouterError(error)
        }
    }
    
    public func presentRoute<A>(_ route: RoutableKey, arg: A, animated: Bool = true, completion: (() -> Void)? = nil) {
        switch Router.shared.viewController(for: route, arg: arg) {
        case .success(let vc):
            self.present(vc, animated: animated, completion: completion)
        case .failure(let error):
            handleRouterError(error)
        }
    }
    
    public func presentRoute<A, B>(_ route: RoutableKey, arguments arg1: A, _ arg2: B, animated: Bool = true, completion: (() -> Void)? = nil) {
        switch Router.shared.viewController(for: route, arguments: arg1, arg2) {
        case .success(let vc):
            self.present(vc, animated: animated, completion: completion)
        case .failure(let error):
            handleRouterError(error)
        }
    }
    
    public func presentRoute<A, B, C>(_ route: RoutableKey, arguments arg1: A, _ arg2: B, _ arg3: C, animated: Bool = true, completion: (() -> Void)? = nil) {
        switch Router.shared.viewController(for: route, arguments: arg1, arg2, arg3) {
        case .success(let vc):
            self.present(vc, animated: animated, completion: completion)
        case .failure(let error):
            handleRouterError(error)
        }
    }
    
    // MARK: - 错误处理方法
    private func handleRouterError(_ error: RouterError) {
        #if DEBUG
        // 开发环境：显示详细错误信息
        let alert = UIAlertController(title: "路由错误", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
        #else
        // 生产环境：记录日志，显示用户友好的错误信息
        print("Router Error: \(error.localizedDescription)")
        // 可以集成崩溃上报服务
        // Crashlytics.crashlytics().record(error: error)
        #endif
    }
}

// MARK: - 改进的Container扩展
extension Container {
    // 无参数的情况
    public func resolveRoute(key: RoutableKey) -> Result<UIViewController, RouterError> {
        guard let vc = self.resolve(UIViewController.self, name: key.routeKey) else {
            return .failure(.routeNotFound(key.routeKey))
        }
        return .success(vc)
    }
    
    // 单个参数的情况
    public func resolveRoute<A>(key: RoutableKey, argument: A) -> Result<UIViewController, RouterError> {
        guard let vc = self.resolve(UIViewController.self, name: key.routeKey, argument: argument) else {
            return .failure(.routeNotFound(key.routeKey))
        }
        return .success(vc)
    }
    
    // 两个参数的情况
    public func resolveRoute<A, B>(key: RoutableKey, arguments arg1: A, _ arg2: B) -> Result<UIViewController, RouterError> {
        guard let vc = self.resolve(UIViewController.self, name: key.routeKey, arguments: arg1, arg2) else {
            return .failure(.routeNotFound(key.routeKey))
        }
        return .success(vc)
    }
    
    // 三个参数的情况
    public func resolveRoute<A, B, C>(key: RoutableKey, arguments arg1: A, _ arg2: B,  _ arg3: C) -> Result<UIViewController, RouterError> {
        guard let vc = self.resolve(UIViewController.self, name: key.routeKey, arguments: arg1, arg2, arg3) else {
            return .failure(.routeNotFound(key.routeKey))
        }
        return .success(vc)
    }
}

// MARK: - Container注册扩展保持不变
extension Container {
    
    public func register<Service>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver) -> Service) {
        self.register(serviceType, name: route.routeKey, factory: factory)
    }
    
    public func register<Service, A>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A) -> Service) {
        self.register(serviceType, name: route.routeKey, factory: factory)
    }
    
    public func register<Service, A, B>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A, B) -> Service) {
        self.register(serviceType, name: route.routeKey, factory: factory)
    }
    
    public func register<Service, A, B, C>(_ serviceType: Service.Type, route: RoutableKey, factory: @escaping (Swinject.Resolver, A, B, C) -> Service) {
        self.register(serviceType, name: route.routeKey, factory: factory)
    }
}
