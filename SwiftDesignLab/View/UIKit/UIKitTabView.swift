//
//  SwiftUITabView.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/7/25.
//

import SwiftUI

struct UIKitTabView: View {
    @StateObject private var coordinator = UIKitTabCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            VStack {
                Text("UIKit 탭 뷰!")
            }
        }
        .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .fitVolume:
                FitVolumeView()
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    UIKitTabView()
}
