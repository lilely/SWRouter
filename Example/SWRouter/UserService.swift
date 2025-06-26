//
//  UserService.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    func getUsers() -> [User]
    func getUser(by id: String) -> User?
}

class UserService: UserServiceProtocol {
    
    private let mockUsers = [
        User(id: "1", name: "张三", email: "zhangsan@example.com"),
        User(id: "2", name: "李四", email: "lisi@example.com"),
        User(id: "3", name: "王五", email: "wangwu@example.com"),
        User(id: "4", name: "赵六", email: "zhaoliu@example.com"),
        User(id: "5", name: "钱七", email: "qianqi@example.com")
    ]
    
    func getUsers() -> [User] {
        return mockUsers
    }
    
    func getUser(by id: String) -> User? {
        return mockUsers.first { $0.id == id }
    }
}

struct User {
    let id: String
    let name: String
    let email: String
} 