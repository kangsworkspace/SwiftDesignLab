//
//  DIContainer.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/7/25.
//

import Foundation

/// 인스턴스의 생성을 관리하는 DIContainer
final class DIContainer {
    /// Singleton
    static let shared = DIContainer()
    
    /// 등록된 객체들을 저장하는 딕셔너리
    private var services: [String: Any] = [:]
    
    
    private init() {
        // 앱 시작 시 모든 서비스 등록
        registerServices()
    }
    
    
    /// 앱 시작 시 모든 서비스를 등록하는 메서드
    private func registerServices() {
        // MARK: - ViewModel
        // MARK: - Entity
    }
    
    
    /// 객체의 타입과 객체를 생성하는 함수 등록
    /// - Parameters:
    ///   - type: 등록할 타입 (예: SwiftUITabViewModel.self)
    ///   - factory: 해당 타입의 인스턴스를 생성하는 함수
    func register<T>(type: T.Type, factory: @escaping () -> T) {
        // 타입을 문자열로 변환, 키로 저장
        let key = String(describing: type)
        
        // 해당 키에 인스턴스를 생성하는 함수 저장
        services[key] = factory
    }
    
    
    /// 등록된 서비스의 인스턴스 반환
    /// - Parameter type: 반환할 타입 (예: SwiftUITabViewModel.self)
    /// - Returns: 해당 타입의 인스턴스
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        guard let factory = services[key] as? () -> T else {
            fatalError("Service not registered: \(type)")
        }
        
        return factory()
    }
}
