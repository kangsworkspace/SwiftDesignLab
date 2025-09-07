//
//  Coordinator.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/6/25.
//

import SwiftUI

/// 코디네이터 프로토콜
protocol Coordinator: AnyObject, ObservableObject {
    /// 자식 코디네이터 관리 배열
    var childCoordinators: [any Coordinator] { get set }
    /// 네비게이션 경로
    var navigationPath: NavigationPath { get set }
    
    /// 특정 뷰로 이동하는 메서드
    /// - PARAMETER destination: 이동할 뷰 (NavigationDestination) 타입
    func navigate(to destination: NavigationDestination)
    
    /// 코디네이터 시작 메서드
    func start()
    
    /// 코디네이터 종료 메서드
    func finish()
    
    /// 이전 화면으로 돌아가는 메서드
    func goBack()
    
    /// 처음 화면으로 돌아가는 메서드
    func goFirst()
}

/// Coordinaotor 기본 구현 메서드 제공 Extension
extension Coordinator {
    
    /// 특정 뷰로 이동하는 메서드 기본 구현
    /// - Parameter destination: 이동할 뷰 (NavigationDestination) 타입
    func navigate(to destination: NavigationDestination) {
        navigationPath.append(destination)
    }
    
    /// 이전 화면으로 돌아가는 메서드 기본 구현
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    /// 처음 화면으로 돌아가는 메서드 기본 구현
    func goFirst() {
        navigationPath = NavigationPath()
    }
    
    // 코디네이터 종료 메서드 기본 구현
    func finish() {
        childCoordinators.removeAll()
    }
    
    /// 자식 코디네이터를 추가하는 메서드 기본 구현
    /// - Parameter coordinator: 추가할 자식 코디네이터
    func addChildCoordinator(coordinator: any Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    /// 자식 코디네이터를 제거하는 메서드 기본 구현
    /// - Parameter coordinator: 제거할 자식 코디네이터
    func removieChildCoorinator(coordinator: any Coordinator) {
        // ObjectIdentifier를 이용해 메타 타입을 비교, 같은 인스턴스만 제거
        childCoordinators.removeAll {
            ObjectIdentifier($0) == ObjectIdentifier(coordinator)
        }
    }
}

/// 코디네이터 기본 클래스
/// 공통적인 프로퍼티와 초기화 로직 제공
class BaseCoordinator: Coordinator {
    
    /// 자식 코디네이터들을 저장하는 배열
    var childCoordinators: [any Coordinator] = []
    
    /// 네비게이션 경로
    @Published var navigationPath = NavigationPath()
        
    /// start() 메서드의 기본 구현
    /// - WARNING: 모든 코디네이터는 해당 함수를 반드시 구현해야 합니다. 구현하지 않으면 FATAL ERROR가 발생합니다.
    func start() {
        fatalError("start() method must be implemented")
    }
}
