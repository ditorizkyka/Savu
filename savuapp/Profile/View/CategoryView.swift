// CategoryView.swift
// savuapp > Profile > View

import SwiftUI

struct CategoryView: View {
    @StateObject private var viewModel = CategoryViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            navBar

            // Segment
            HStack(spacing: 4) {
                ForEach(CategoryType.allCases, id: \.self) { tab in
                    segmentButton(tab)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 14)

            // Info banner
            if viewModel.showInfoBanner && viewModel.selectedTab == .income {
                infoBanner
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Section header
            HStack {
                Text("\(viewModel.selectedTab.rawValue) Categories")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: { viewModel.showNewCategorySheet = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus").font(.system(size: 12))
                        Text("Add").font(.system(size: 13))
                    }
                    .foregroundColor(Color(hex: "4A6CF7"))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)

            // List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.activeCategories) { category in
                        categoryRow(category)
                        if category.id != viewModel.activeCategories.last?.id {
                            Divider().padding(.leading, 56)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedTab)
        .sheet(isPresented: $viewModel.showNewCategorySheet) {
            NewCategoryView(categoryVM: viewModel)
        }
    }

    // MARK: Nav Bar
    private var navBar: some View {
        ZStack {
            Text("Manage Categories")
                .font(.system(size: 17, weight: .bold))
            HStack {
                Button(action: { dismiss() }) {
                    Text("Back")
                        .font(.system(size: 15))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 14)
    }

    // MARK: Segment Button
    private func segmentButton(_ tab: CategoryType) -> some View {
        let selected = viewModel.selectedTab == tab
        return Button(action: { viewModel.selectedTab = tab }) {
            Text(tab.rawValue)
                .font(.system(size: 14, weight: selected ? .semibold : .regular))
                .foregroundColor(selected ? .black : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selected ? Color(.white) : Color(.systemGray5))
                .cornerRadius(10)
        }
    }

    // MARK: Info Banner
    private var infoBanner: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("About Categories")
                    .font(.system(size: 14, weight: .semibold))
                Text("Organise your finances by grouping transactions. Clear categories help you track where your money goes and identify your primary income sources at a glance.")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineSpacing(3)
            }
            Spacer()
            Button(action: {
                withAnimation { viewModel.showInfoBanner = false }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color(hex: "F0F4FF"))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(Color(hex: "4A6CF7").opacity(0.2), lineWidth: 1))
    }

    // MARK: Category Row
    private func categoryRow(_ category: Category) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "EEF1FF"))
                    .frame(width: 38, height: 38)
                Image(systemName: category.iconName)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "4A6CF7"))
            }
            Text(category.name).font(.system(size: 15))
            Spacer()
            Button(action: {}) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(.trailing, 8)
            Button(action: { withAnimation { viewModel.delete(category) } }) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }
}

#Preview {
    NavigationStack { CategoryView() }
}
