//
//  DetailViewController.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import UIKit
import SWRouter

class DetailViewController: UIViewController {
    
    private let userId: String
    private let infoLabel = UILabel()
    private let backButton = UIButton(type: .system)
    
    init(userId: String) {
        self.userId = userId
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
        title = "详情页"
        
        // 设置信息标签
        infoLabel.text = "用户ID: \(userId)\n这是一个带参数的视图控制器示例"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        
        // 设置返回按钮
        backButton.setTitle("返回首页", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(infoLabel)
        view.addSubview(backButton)
    }
    
    private func setupConstraints() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
} 