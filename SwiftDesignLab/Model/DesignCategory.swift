//
//  DesignCategory.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/7/25.
//

import Foundation

/// 디자인 종류
enum DesignCategory: String, CaseIterable {
    case animation = "애니메이션"
    case interaction = "인터렉션"
    case background = "배경화면"
    
    var icon: String {
        switch self {
        case .animation: return "play.rectangle"
        case .interaction: return "hand.point.up.left"
        case .background: return "person.and.background.dotted"
        }
    }
}
