//
//  HomeViewController.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import UIKit
import SWRouter

class HomeViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let detailButton = UIButton(type: .system)
    private let profileButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let userListButton = UIButton(type: .system)
    private let advancedButton = UIButton(type: .system)
    private let conditionalButton = UIButton(type: .system)
    private let secureButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "首页"
        
        // 设置标题
        titleLabel.text = "SWRouter 示例"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        // 设置按钮
        detailButton.setTitle("跳转到详情页 (无参数)", for: .normal)
        detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        
        profileButton.setTitle("跳转到个人资料 (两个参数)", for: .normal)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        settingsButton.setTitle("跳转到设置页 (三个参数)", for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        userListButton.setTitle("跳转到用户列表 (依赖注入)", for: .normal)
        userListButton.addTarget(self, action: #selector(userListButtonTapped), for: .touchUpInside)
        
        advancedButton.setTitle("高级示例 (高级功能)", for: .normal)
        advancedButton.addTarget(self, action: #selector(advancedButtonTapped), for: .touchUpInside)
        
        conditionalButton.setTitle("条件示例 (条件路由)", for: .normal)
        conditionalButton.addTarget(self, action: #selector(conditionalButtonTapped), for: .touchUpInside)
        
        secureButton.setTitle("安全示例 (安全路由)", for: .normal)
        secureButton.addTarget(self, action: #selector(secureButtonTapped), for: .touchUpInside)
        
        // 设置StackView
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailButton)
        stackView.addArrangedSubview(profileButton)
        stackView.addArrangedSubview(settingsButton)
        stackView.addArrangedSubview(userListButton)
        stackView.addArrangedSubview(advancedButton)
        stackView.addArrangedSubview(conditionalButton)
        stackView.addArrangedSubview(secureButton)
        
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Actions
    @objc private func detailButtonTapped() {
        // 使用无参数的路由跳转
        pushRoute(RouteKey.home, animated: true)
    }
    
    @objc private func profileButtonTapped() {
        // 使用两个参数的路由跳转
        pushRoute(RouteKey.profile, arguments: "user123", true)
    }
    
    @objc private func settingsButtonTapped() {
        // 使用三个参数的路由跳转
        pushRoute(RouteKey.settings, arguments: "user123", "general", false)
    }
    
    @objc private func userListButtonTapped() {
        // 使用依赖注入的路由跳转
        pushRoute(RouteKey.userList, animated: true)
    }
    
    @objc private func advancedButtonTapped() {
        // 展示高级示例的选项
        let alert = UIAlertController(title: "高级示例", message: "选择要演示的功能", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "工厂模式路由", style: .default) { _ in
            self.pushRoute(RouteKey.product, arg: ProductType.electronics)
        })
        
        alert.addAction(UIAlertAction(title: "链式依赖注入", style: .default) { _ in
            self.pushRoute(RouteKey.data, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "动态路由", style: .default) { _ in
            let dynamicKey = DynamicRouteKey(key: "feature1")
            if let vc = Router.shared.viewController(for: dynamicKey) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func conditionalButtonTapped() {
        // 切换管理员状态并演示条件路由
        let isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
        UserDefaults.standard.set(!isAdmin, forKey: "isAdmin")
        
        let alert = UIAlertController(title: "条件路由", message: "管理员状态已切换为: \(!isAdmin ? "是" : "否")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func secureButtonTapped() {
        // 演示安全路由
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            let alert = UIAlertController(title: "安全路由", message: "已登出，再次点击将跳转到登录页面", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            present(alert, animated: true)
        } else {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            pushRoute(RouteKey.secure, animated: true)
        }
    }
} 
