// NewCategoryView.swift
// savuapp > Profile > View

import SwiftUI

struct NewCategoryView: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @StateObject private var viewModel = NewCategoryViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Text("New Category")
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 24)
                .padding(.bottom, 20)

            ScrollView {
                VStack(spacing: 24) {
                    // Selected icon preview
                    ZStack {
                        Circle()
                            .fill(Color(hex: "EEF1FF"))
                            .frame(width: 72, height: 72)
                        Image(systemName: viewModel.selectedIconName)
                            .font(.system(size: 30))
                            .foregroundColor(Color(hex: "4A6CF7"))
                    }

                    // Name field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category Name")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)

                        TextField("e.g. Food & Dining", text: $viewModel.categoryName)
                            .font(.system(size: 15))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)

                    // Icon picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Icons")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .padding(.leading, 24)

                        TabView(selection: $viewModel.currentIconPage) {
                            ForEach(0..<viewModel.availableIcons.count, id: \.self) { pageIdx in
                                iconGrid(icons: viewModel.availableIcons[pageIdx])
                                    .tag(pageIdx)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .frame(height: 230)
                    }

                    // Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.save(to: categoryVM)
                            dismiss()
                        }) {
                            Text("Save Changes")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    viewModel.categoryName.trimmingCharacters(in: .whitespaces).isEmpty
                                    ? Color(red: 0.08, green: 0.36, blue: 0.99).opacity(0.4)
                                    : Color(red: 0.08, green: 0.36, blue: 0.99)
                                )
                                .cornerRadius(14)
                        }
                        .disabled(viewModel.categoryName.trimmingCharacters(in: .whitespaces).isEmpty)

                        Button(action: { dismiss() }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(.systemGray6))
                                .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(Color.white)
    }

    // MARK: Icon Grid
    private func iconGrid(icons: [String]) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 10),
            spacing: 8
        ) {
            ForEach(icons, id: \.self) { icon in
                Button(action: { viewModel.selectedIconName = icon }) {
                    let selected = viewModel.selectedIconName == icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selected ? Color(hex: "4A6CF7").opacity(0.12) : Color(.systemGray6))
                            .frame(width: 30, height: 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selected ? Color(hex: "4A6CF7") : Color.clear, lineWidth: 1.5)
                            )
                        Image(systemName: icon)
                            .font(.system(size: 13))
                            .foregroundColor(selected ? Color(hex: "4A6CF7") : .secondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    NewCategoryView(categoryVM: CategoryViewModel())
}
