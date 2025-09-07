//
//  TabCoordinator.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/6/25.
//

import SwiftUI

/// 전체 탭 구조를 관리하는 탭 코디네이터
class TabCoordinator: BaseCoordinator {
    /// 선택된 탭
    @Published var selectedTab: Int = 0
    
    /// SwiftUI 탭을 담당하는 자식 코디네이터
    var swiftUITabCoordinator: SwiftUITabCoordinator?
    
    /// UIKit 탭을 담당하는 자식 코디네이터
    var uiKitTabCoordinator: UIKitTabCoordinator?
    
    override func start() {
        setupTabCoordinator()
    }
}


// MARK: - UI Setup

extension TabCoordinator {
    private func setupTabCoordinator() {
        
        // MARK: - SwiftUI 탭
        
        swiftUITabCoordinator = SwiftUITabCoordinator()
        
        if let swiftUITabCoordinator {
            addChildCoordinator(coordinator: swiftUITabCoordinator)
            swiftUITabCoordinator.start()
        }
        
        
        // MARK: - UIKit 탭
        
        uiKitTabCoordinator = UIKitTabCoordinator()
        
        if let uiKitTabCoordinator {
            addChildCoordinator(coordinator: uiKitTabCoordinator)
            uiKitTabCoordinator.start()
        }
    }
}
