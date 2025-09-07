//
//  Item.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/7/25.
//

import Foundation

/// 디자인 아이템
struct DesignItem: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: DesignCategory
    let tags: [String]
    let navigationDestination: NavigationDestination
}
