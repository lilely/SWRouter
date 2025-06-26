//
//  AppDelegate.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import UIKit
import SWRouter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 设置Router
        setupRouter()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Router Setup
    private func setupRouter() {
        let router = Router.shared
        
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
        
        
        // 注册服务
        router.container.register(UserService.self) { _ in
            return UserService()
        }
        
        // 设置高级示例
        setupAdvancedExamples()
    }
    
    // MARK: - Advanced Examples
    private func setupAdvancedExamples() {
        // 设置条件路由
        AdvancedExample.setupConditionalRoutes()
        
        // 设置工厂模式路由
        AdvancedExample.setupFactoryRoutes()
        
        // 设置链式依赖注入
        AdvancedExample.setupChainedDependencies()
        
        // 设置动态路由
        AdvancedExample.setupDynamicRoutes()
        
        // 设置路由拦截器
        AdvancedExample.setupRouteInterceptor()
    }

}

