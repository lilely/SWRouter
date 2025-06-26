//
//  ProfileViewController.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import UIKit
import SWRouter

class ProfileViewController: UIViewController {
    
    private let userId: String
    private let isEditable: Bool
    private let infoLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    init(userId: String, isEditable: Bool) {
        self.userId = userId
        self.isEditable = isEditable
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
        title = "个人资料"
        
        // 设置信息标签
        infoLabel.text = "用户ID: \(userId)\n可编辑: \(isEditable ? "是" : "否")\n这是一个带两个参数的视图控制器示例"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        
        // 设置编辑按钮
        editButton.setTitle("编辑资料", for: .normal)
        editButton.isEnabled = isEditable
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        // 设置返回按钮
        backButton.setTitle("返回首页", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(infoLabel)
        view.addSubview(editButton)
        view.addSubview(backButton)
    }
    
    private func setupConstraints() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func editButtonTapped() {
        let alert = UIAlertController(title: "编辑", message: "编辑功能已触发", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
} 