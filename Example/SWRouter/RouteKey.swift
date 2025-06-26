//
//  RouteKey.swift
//  SWRouter
//
//  Created by Xing.Jin on 06/26/2025.
//  Copyright (c) 2025 Xing.Jin. All rights reserved.
//

import Foundation
import SWRouter

// MARK: - Route Keys
enum RouteKey: RoutableKey {
    case home
    case detail
    case profile
    case settings
    case userList
    case admin
    case user
    case product
    case data
    case secure
    
    var routeKey: String {
        switch self {
        case .home:
            return "home"
        case .detail:
            return "detail"
        case .profile:
            return "profile"
        case .settings:
            return "settings"
        case .userList:
            return "userList"
        case .admin:
            return "admin"
        case .user:
            return "user"
        case .product:
            return "product"
        case .data:
            return "data"
        case .secure:
            return "secure"
        }
    }
}