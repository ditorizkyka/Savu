// MARK: - Imports
import SwiftUI

// MARK: - Main Type Declaration
struct AddTransactionView: View {
    // MARK: - Properties
    @State private var selectedType: TransactionType = .income
    @State private var date: Date = Date()
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            ScrollView {
                VStack(spacing: 24) {
                    typePicker
                    
                    VStack(spacing: 20) {
                        inputField(label: "Date", icon: "calendar") {
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        inputField(label: "Title") {
                            TextField(selectedType == .income ? "Income name here" : "Expense name here", text: $title)
                        }
                        
                        inputField(label: "Amount") {
                            HStack {
                                Text("Rp")
                                    .foregroundStyle(.secondary)
                                TextField("", text: $amount)
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        inputField(label: "Category") {
                            HStack {
                                Text(category.isEmpty ? "Choose Category" : category)
                                    .foregroundStyle(category.isEmpty ? .secondary : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.top, 8)
                    
                    submitButton
                }
                .padding(24)
            }
        }
    }
    
    // MARK: - Private Methods (Subviews)
    private var headerSection: some View {
        HStack {
            Button {
                // Action back
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(uiColor: .darkGray))
                    .frame(width: 40, height: 40)
                    .background(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
            }
            
            Spacer()
            
            Text("Add Transaction")
                .font(.headline)
                .foregroundStyle(Color(red: 0.1, green: 0.2, blue: 0.4))
            
            Spacer()
            
            // Empty view for balancing HStack
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
    
    private var typePicker: some View {
        HStack(spacing: 0) {
            ForEach(TransactionType.allCases, id: \.self) { type in
                Text(type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(selectedType == type ? Color.blue : Color.clear)
                    .foregroundStyle(selectedType == type ? .white : .white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedType = type
                        }
                    }
            }
        }
        .padding(4)
        .background(Color.blue.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
    
    private func inputField<Content: View>(label: String, icon: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(label)*")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(uiColor: .darkGray))
            
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
    
    private var submitButton: some View {
        Button {
            // Submit Action
        } label: {
            Text(selectedType == .income ? "Add Income" : "Add Expenses")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .padding(.top, 20)
        .accessibilityLabel(selectedType == .income ? "Tambah Pendapatan" : "Tambah Pengeluaran")
    }
}

// MARK: - Preview
#Preview {
    AddTransactionView()
}
