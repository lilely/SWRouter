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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

