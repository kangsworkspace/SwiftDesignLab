//
//  DesignItemList.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/7/25.
//

import Foundation

/// 디자인 아이템 리스트
struct DesignItemList {
    
    // MARK: - SwiftUI
    
    static let swiftUI: [DesignItem] = [
        DesignItem(
            title: "볼륨 일치시키기",
            description: "나이틀리라는 앱에서 볼륨을 일치시킬 때 나오는 애니메이션입니다. 하나로 합쳐지는 애니메이션이 깔끔해서 구현해봤어요",
            category: .animation,
            tags: ["볼륨", "나이틀리"],
            navigationDestination: .fitVolume
        ),
        DesignItem(
            title: "밀어서 결제하기",
            description: "스타벅스에서 간편결제 할 때 하단에 나오는 밀어서 결제하기를 구현해봤습니다. 추가 progress가 일정 수준에서 자동으로 채워주는데 사용자한테 어느 시점부터 결제가 되는 pregress인지 피드백이 필요할 거 같아 햅틱 피드백을 넣어봤어요",
            category: .interaction,
            tags: ["제스쳐", "스타벅스", "햅틱"],
            navigationDestination: .slidePay
        ),
    ]
    
    static let uiKit: [DesignItem] = [
        
    ]
}


extension DesignItemList {
    static func filteredSwiftUI(query: String, category: DesignCategory? = nil) -> [DesignItem] {
        return swiftUI.filter { item in
            let matchesCategory = category == nil || item.category == category
            
            if query.isEmpty {
                return matchesCategory
            }
            
            let lowercasedQuery = query.lowercased()
            let matchesQuery = item.title.lowercased().contains(lowercasedQuery) ||
                              item.description.lowercased().contains(lowercasedQuery) ||
                              item.tags.contains { $0.lowercased().contains(lowercasedQuery) }
            
            return matchesCategory && matchesQuery
        }
    }

    static func filteredUIKit(query: String, category: DesignCategory? = nil) -> [DesignItem] {
        return uiKit.filter { item in
            let matchesCategory = category == nil || item.category == category
            
            if query.isEmpty {
                return matchesCategory
            }
            
            let lowercasedQuery = query.lowercased()
            let matchesQuery = item.title.lowercased().contains(lowercasedQuery) ||
                              item.description.lowercased().contains(lowercasedQuery) ||
                              item.tags.contains { $0.lowercased().contains(lowercasedQuery) }
            
            return matchesCategory && matchesQuery
        }
    }
}
