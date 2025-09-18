//
//  SwiftUITabView.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/7/25.
//

import SwiftUI

struct SwiftUITabView: View {
    @StateObject private var coordinator = SwiftUITabCoordinator()
    
    // 검색
    @State var searchText: String = ""
        
    // 카테고리
    @State var selectedCategory: DesignCategory?

    // 디자인 아이템 (필터링 적용)
    private var filteredDesignItems: [DesignItem] {
        DesignItemList.filteredSwiftUI(
            query: searchText,
            category: selectedCategory
        )
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            VStack(spacing: 0) {
                CategoryFilterView(selectedCategory: $selectedCategory)
                
                List(filteredDesignItems) { item in
                    DesignItemCardView(
                        item: item,
                        coordinator: coordinator
                    )
                }
                .listStyle(PlainListStyle())
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "디자인 검색"
            )
            .navigationTitle("SwiftUI 디자인 모음")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .fitVolume:
                    FitVolumeView()
                case .slidePay:
                    SlidePayView()
                case .blinkStar:
                    BlinkStarView()
                }
            }
        }
        .onAppear {
            coordinator.start()
        }
    }
}

#Preview {
    SwiftUITabView()
}


// MARK: - Function

extension SwiftUITabView {}


// MARK: - UI Component

/// 카테고리 필터를 표시하는 뷰
private struct CategoryFilterView: View {
    @Binding var selectedCategory: DesignCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryFilterButton(
                    title: "전체",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(DesignCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
        
    /// 카테고리 필터 버튼
    private struct CategoryFilterButton: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isSelected ? Color.blue : Color(.systemGray5))
                    )
                    .foregroundColor(isSelected ? .white : .primary)
            }
        }
    }
}

/// 디자인 아이템을 표시하는 카드 뷰
struct DesignItemCardView: View {
    let item: DesignItem
    let coordinator: SwiftUITabCoordinator
    
    var body: some View {
        Button {
            coordinator.navigate(to: item.navigationDestination)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        // 카테고리
                        Text(item.category.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                        
                        // 태그
                        ForEach(item.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .foregroundColor(.secondary)
                                .clipShape(Capsule())
                                .fixedSize()
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 2, x: 0, y: 1
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
