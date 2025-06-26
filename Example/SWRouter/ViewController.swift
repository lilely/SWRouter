//
//  ViewController.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import UIKit
import SWRouter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航控制器
        let homeVC = HomeViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        
        // 替换当前视图控制器
        addChildViewController(navController)
        view.addSubview(navController.view)
        navController.view.frame = view.bounds
        navController.didMove(toParentViewController: self)
        
        // 演示错误处理
        demonstrateErrorHandling()
    }

    private func demonstrateErrorHandling() {
        // 演示路由未找到的错误
        let nonExistentRoute = NonExistentRouteKey()
        
        switch Router.shared.viewController(for: nonExistentRoute) {
        case .success(let vc):
            print("成功获取视图控制器")
        case .failure(let error):
            print("路由错误: \(error.localizedDescription)")
            // 在开发环境中会显示错误弹窗
            handleRouterError(error)
        }
    }
    
    private func handleRouterError(_ error: RouterError) {
        #if DEBUG
        let alert = UIAlertController(title: "路由错误", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
        #else
        print("Router Error: \(error.localizedDescription)")
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 用于演示错误的路由键
struct NonExistentRouteKey: RoutableKey {
    var routeKey: String {
        return "non_existent_route"
    }
}

