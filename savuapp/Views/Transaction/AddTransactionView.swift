// AddTransactionView.swift
// savuapp > Views > Transaction

import SwiftUI

struct AddTransactionView: View {
    @StateObject private var viewModel = AddTransactionViewModel()
    @Environment(\.dismiss) private var dismiss
    let store: TransactionStore

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            ScrollView {
                VStack(spacing: 24) {
                    typePicker

                    VStack(spacing: 20) {
                        // Date
                        inputField(label: "Date", icon: "calendar") {
                            DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Title
                        inputField(label: "Title") {
                            TextField(
                                viewModel.selectedType == .income ? "e.g. Salary" : "e.g. Lunch",
                                text: $viewModel.title
                            )
                        }

                        // Amount
                        inputField(label: "Amount") {
                            HStack {
                                Text("Rp")
                                    .foregroundStyle(.secondary)
                                TextField("0", text: $viewModel.amount)
                                    .keyboardType(.numberPad)
                            }
                        }

                        // Category
                        categoryField
                    }
                    .padding(.top, 8)

                    submitButton
                }
                .padding(24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(uiColor: .label))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color(.systemGray6))
                    )
            }

            Spacer()

            Text("Add Transaction")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Spacer()

            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }

    // MARK: - Type Picker
    private var typePicker: some View {
        HStack(spacing: 0) {
            ForEach(TransactionType.allCases, id: \.self) { type in
                Text(type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(viewModel.selectedType == type ? AppTheme.Colors.primary : Color.clear)
                    .foregroundStyle(viewModel.selectedType == type ? .white : .white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .contentShape(RoundedRectangle(cornerRadius: 24))
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.selectedType = type
                            viewModel.selectedCategory = ""
                        }
                    }
            }
        }
        .padding(4)
        .background(AppTheme.Colors.primary.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Category Field
    private var categoryField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category*")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    viewModel.showCategoryPicker.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    if !viewModel.selectedCategory.isEmpty {
                        Image(systemName: viewModel.selectedIconName)
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                    Text(viewModel.selectedCategory.isEmpty ? "Choose Category" : viewModel.selectedCategory)
                        .foregroundStyle(viewModel.selectedCategory.isEmpty ? .secondary : .primary)
                    Spacer()
                    Image(systemName: viewModel.showCategoryPicker ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            viewModel.showCategoryPicker ? AppTheme.Colors.primary : Color.gray.opacity(0.2),
                            lineWidth: viewModel.showCategoryPicker ? 1.5 : 1
                        )
                )
            }
            .buttonStyle(.plain)

            // Category dropdown
            if viewModel.showCategoryPicker {
                VStack(spacing: 0) {
                    ForEach(viewModel.currentCategories, id: \.name) { cat in
                        Button(action: {
                            viewModel.selectedCategory = cat.name
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                viewModel.showCategoryPicker = false
                            }
                        }) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "EEF1FF"))
                                        .frame(width: 34, height: 34)
                                    Image(systemName: cat.icon)
                                        .font(.system(size: 14))
                                        .foregroundColor(AppTheme.Colors.primary)
                                }

                                Text(cat.name)
                                    .font(.system(size: 15))
                                    .foregroundColor(.primary)

                                Spacer()

                                if viewModel.selectedCategory == cat.name {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppTheme.Colors.primary)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 11)
                        }
                        .buttonStyle(.plain)

                        if cat.name != viewModel.currentCategories.last?.name {
                            Divider().padding(.leading, 56)
                        }
                    }
                }
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: - Input Field
    private func inputField<Content: View>(label: String, icon: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(label)*")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(.secondary)
                }
                content()
            }
            .padding()
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }

    // MARK: - Submit Button
    private var submitButton: some View {
        Button {
            viewModel.save(to: store)
            dismiss()
        } label: {
            Text(viewModel.selectedType == .income ? "Add Income" : "Add Expense")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    viewModel.canSave
                        ? AppTheme.Colors.primary
                        : AppTheme.Colors.primary.opacity(0.4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .disabled(!viewModel.canSave)
        .padding(.top, 20)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AddTransactionView(store: TransactionStore.shared)
    }
}
