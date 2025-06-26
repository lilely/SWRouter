//
//  SettingsViewController.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import UIKit
import SWRouter

class SettingsViewController: UIViewController {
    
    private let userId: String
    private let section: String
    private let isAdmin: Bool
    private let infoLabel = UILabel()
    private let adminButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    init(userId: String, section: String, isAdmin: Bool) {
        self.userId = userId
        self.section = section
        self.isAdmin = isAdmin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "设置"
        
        // 设置信息标签
        infoLabel.text = "用户ID: \(userId)\n设置章节: \(section)\n管理员权限: \(isAdmin ? "是" : "否")\n这是一个带三个参数的视图控制器示例"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        
        // 设置管理员按钮
        adminButton.setTitle("管理员功能", for: .normal)
        adminButton.isEnabled = isAdmin
        adminButton.addTarget(self, action: #selector(adminButtonTapped), for: .touchUpInside)
        
        // 设置返回按钮
        backButton.setTitle("返回首页", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(infoLabel)
        view.addSubview(adminButton)
        view.addSubview(backButton)
    }
    
    private func setupConstraints() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        adminButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            adminButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adminButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: adminButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func adminButtonTapped() {
        let alert = UIAlertController(title: "管理员功能", message: "管理员功能已触发", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
} 