//
//  ContentView.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tabCoodinator = TabCoordinator()
    
    var body: some View {
        TabView(selection: $tabCoodinator.selectedTab) {
            
            // MARK: - SwiftUI Tab
            
            SwiftUITabView()
                .tabItem {
                    Image(systemName: "swift")
                    Text("SwiftUI")
                }
                .tag(0)
            
            
            // MARK: - UIKit Tab
            
            UIKitTabView()
                .tabItem {
                    Image(systemName: "app")
                    Text("UIKit")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
