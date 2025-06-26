//
//  Router.swift
//  Haven
//
//  Created by User on 2025/2/18.
//

import UIKit
import Swinject

public protocol RoutableKey {
    var routeKey: String { get }
}

protocol Routable {
    func viewController(for route: RoutableKey) -> UIViewController?
}

public class Router: Routable {
    
    static public let shared = Router()
    
    public lazy var container: Container = {
        return Container()
    }()
    
    private init() {} // Make init private to enforce singleton pattern
    
    public func viewController(for route: RoutableKey) -> UIViewController? {
        return container.resolveRoute(key: route)
    }
    
    public func viewController<A>(for route: RoutableKey, arg: A) -> UIViewController? {
        return container.resolveRoute(key: route, argument: arg)
    }
    
    public func viewController<A, B>(for route: RoutableKey, arguments arg1: A, _ arg2: B) -> UIViewController? {
        return container.resolveRoute(key: route, arguments: arg1, arg2)
    }
    
    public func viewController<A, B, C>(for route: RoutableKey, arguments arg1: A, _ arg2: B,  _ arg3: C) -> UIViewController? {
        return container.resolveRoute(key: route, arguments: arg1, arg2, arg3)
    }
    
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

extension UIViewController {
    
    public func pushRoute(_ route: RoutableKey, animated: Bool = true) {
        guard let vc = Router.shared.viewController(for: route) else {
            assertionFailure("无法解析路由：\(route)")
            return
        }
        self.navigationController?.pushViewController(vc,
                                                      animated: animated)
    }
    
    public func pushRoute<A>(_ route: RoutableKey, animated: Bool = true, arg: A) {
        guard let vc = Router.shared.viewController(for: route, arg: arg) else {
            assertionFailure("无法解析路由：\(route)")
            return
        }
        self.navigationController?.pushViewController(vc,
                                                      animated: animated)
    }
    
    public func pushRoute<A, B>(_ route: RoutableKey, animated: Bool = true, arguments arg1: A, _ arg2: B) {
        guard let vc = Router.shared.viewController(for: route, arguments: arg1, arg2) else {
            assertionFailure("无法解析路由：\(route)")
            return
        }
        self.navigationController?.pushViewController(vc,
                                                      animated: animated)
    }
    
    public func pushRoute<A, B, C>(_ route: RoutableKey, animated: Bool = true, arguments arg1: A, _ arg2: B,  _ arg3: C) {
        guard let vc = Router.shared.viewController(for: route, arguments: arg1, arg2, arg3) else {
            assertionFailure("无法解析路由：\(route)")
            return
        }
        self.navigationController?.pushViewController(vc,
                                                      animated: animated)
    }
    
    public func presentRoute(_ route: RoutableKey, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let vc = Router.shared.viewController(for: route) else {
            assertionFailure("无法解析路由：\(route)")
            return
        }
        self.present(vc,
                     animated: animated,
                     completion: completion)
    }
    
    public func presentRoute<A>(_ route: RoutableKey, arg: A, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let vc = Router.shared.viewController(for: route, arg: arg) else {
            assertionFailure("无法解析路由：\(route)")
            return
        }
        self.present(vc,
                     animated: animated,
                     completion: completion)
    }
    
    public func presentRoute<A, B>(_ route: RoutableKey, arguments arg1: A, _ arg2: B, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let vc = Router.shared.viewController(for: route, arguments: arg1, arg2) else {
            assertionFailure("无法解析路由：\(route)")
            return
        }
        self.present(vc,
                     animated: animated,
                     completion: completion)
    }
    
    public func presentRoute<A, B, C>(_ route: RoutableKey, arguments arg1: A, _ arg2: B, _ arg3: C, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let vc = Router.shared.viewController(for: route, arguments: arg1, arg2, arg3) else {
            assertionFailure("无法解析路由：\(route)")
            return
        }
        self.present(vc,
                     animated: animated,
                     completion: completion)
    }
    
}

extension Container {
    // 无参数的情况
    public func resolveRoute(key: RoutableKey) -> UIViewController? {
        return self.resolve(UIViewController.self, name: key.routeKey)
    }
    
    // 单个参数的情况
    public func resolveRoute<A>(key: RoutableKey, argument: A) -> UIViewController? {
        return self.resolve(UIViewController.self, name: key.routeKey, argument: argument)
    }
    
    // 两个参数的情况
    public func resolveRoute<A, B>(key: RoutableKey, arguments arg1: A, _ arg2: B) -> UIViewController? {
        return self.resolve(UIViewController.self, name: key.routeKey, arguments: arg1, arg2)
    }
    
    // 三个参数的情况
    public func resolveRoute<A, B, C>(key: RoutableKey, arguments arg1: A, _ arg2: B,  _ arg3: C) -> UIViewController? {
        return self.resolve(UIViewController.self, name: key.routeKey, arguments: arg1, arg2, arg3)
    }
    
}

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
