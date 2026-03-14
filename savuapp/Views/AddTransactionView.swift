// MARK: - Imports
import SwiftUI

// MARK: - Animation Helper
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

// MARK: - Supporting Types
enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expenses = "Expenses"
}

// MARK: - Main View
struct AddTransactionView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss // Untuk menutup halaman
    @State private var selectedType: TransactionType = .income
    @State private var date: Date = Date()
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    
    // Validation States
    @State private var shakeTrigger: CGFloat = 0
    @State private var invalidFields: Set<String> = []
    
    // Pop-up States
    @State private var showSuccessPopup: Bool = false
    @State private var showDiscardPopup: Bool = false
    
    // MARK: - Categories Logic
    private var availableCategories: [String] {
        selectedType == .income ?
        ["Salary", "Investment", "Gift", "Others"] :
        ["Food", "Transport", "Shopping", "Others"]
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
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
                                    .onChange(of: title) { invalidFields.remove("Title") }
                            }
                            
                            inputField(label: "Amount") {
                                HStack {
                                    Text("Rp").foregroundStyle(.secondary)
                                    TextField("", text: $amount)
                                        .keyboardType(.numberPad)
                                        .onChange(of: amount) { invalidFields.remove("Amount") }
                                }
                            }
                            
                            inputField(label: "Category") {
                                Menu {
                                    ForEach(availableCategories, id: \.self) { cat in
                                        Button(cat) {
                                            category = cat
                                            invalidFields.remove("Category")
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(category.isEmpty ? "Choose Category" : category)
                                            .foregroundStyle(category.isEmpty ? .black.opacity(0.5) : .black)
                                        Spacer()
                                        Image(systemName: "chevron.down").font(.caption).foregroundStyle(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .contentShape(Rectangle())
                                    .blur(radius: invalidFields.contains("Category") ? 1.5 : 0)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        submitButton
                    }
                    .padding(24)
                }
            }
            // Tambahkan blur pada konten saat pop-up muncul
            .blur(radius: (showSuccessPopup || showDiscardPopup) ? 3 : 0)
            .disabled(showSuccessPopup || showDiscardPopup)

            // MARK: - Popups Layer
            if showSuccessPopup || showDiscardPopup {
                popupOverlay
                
                if showSuccessPopup {
                    successPopup
                        .transition(.scale.combined(with: .opacity))
                } else if showDiscardPopup {
                    discardPopup
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
}

// MARK: - Private Methods (Subviews)
extension AddTransactionView {
    
    private var headerSection: some View {
        HStack {
            Button {
                // Logic: Munculkan discard popup jika form tidak kosong
                if !title.isEmpty || !amount.isEmpty || !category.isEmpty {
                    withAnimation(.spring()) { showDiscardPopup = true }
                } else {
                    dismiss()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 40, height: 40)
                    .background(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
            }
            Spacer()
            Text("Add Transaction")
                .font(.headline)
                .foregroundStyle(Color(red: 0.1, green: 0.2, blue: 0.4))
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 24).padding(.top, 20)
    }
    
    private var typePicker: some View {
        HStack(spacing: 0) {
            ForEach(TransactionType.allCases, id: \.self) { type in
                Text(type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        ZStack {
                            if selectedType == type {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 0.15, green: 0.4, blue: 0.95), Color(red: 0.1, green: 0.3, blue: 0.85)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                            }
                        }
                    )
                    .foregroundStyle(.white)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedType = type
                            category = ""
                        }
                    }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.1, green: 0.3, blue: 0.85), Color(red: 0.05, green: 0.2, blue: 0.75)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
    
    private func inputField<Content: View>(label: String, icon: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(Text(label).foregroundStyle(.black))\(Text("*").foregroundStyle(.red))")
                .font(.system(size: 16, weight: .bold))
            
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon).foregroundStyle(.secondary)
                }
                content()
            }
            .padding()
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(invalidFields.contains(label) ? Color.red : Color.gray.opacity(0.2), lineWidth: 1)
            )
            .modifier(invalidFields.contains(label) ? ShakeEffect(animatableData: shakeTrigger) : ShakeEffect(animatableData: 0))
        }
    }
    
    private var submitButton: some View {
        Button {
            validateAndSave()
        } label: {
            Text(selectedType == .income ? "Add Income" : "Add Expenses")
                .font(.headline).foregroundStyle(.white)
                .frame(maxWidth: .infinity).frame(height: 56)
                .background(Color(red: 1/255, green: 76/255, blue: 230/255))
                .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .padding(.top, 20)
    }
    
    // MARK: - Logic
    private func validateAndSave() {
        var newInvalidFields: Set<String> = []
        
        if title.isEmpty { newInvalidFields.insert("Title") }
        if amount.isEmpty { newInvalidFields.insert("Amount") }
        if category.isEmpty { newInvalidFields.insert("Category") }
        
        if !newInvalidFields.isEmpty {
            invalidFields = newInvalidFields
            withAnimation(.default) {
                shakeTrigger += 1
            }
        } else {
            // Tampilkan pop-up sukses
            withAnimation(.spring()) {
                showSuccessPopup = true
            }
            // Otomatis tutup setelah 2 detik
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        }
    }
}

// MARK: - Popups
extension AddTransactionView {
    
    private var popupOverlay: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                if showDiscardPopup { withAnimation { showDiscardPopup = false } }
            }
    }
    
    private var successPopup: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(.green)
            
            VStack(spacing: 8) {
                Text("\(selectedType.rawValue) Saved!")
                    .font(.title3.weight(.bold))
                Text("\(selectedType.rawValue) saved successfully. You will directed to Homepage")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .background(RoundedRectangle(cornerRadius: 28).fill(.white))
        .padding(.horizontal, 40)
    }
    
    private var discardPopup: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(20)
                .background(Circle().stroke(Color.yellow.opacity(0.5), lineWidth: 2))
                .foregroundStyle(.yellow)
            
            VStack(spacing: 8) {
                Text("Discard Changes?")
                    .font(.title3.weight(.bold))
                Text("Your recent transaction haven't been saved. Are you sure you want to exit?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 16) {
                Button("Yes") {
                    showDiscardPopup = false
                    dismiss()
                }
                .frame(maxWidth: .infinity).frame(height: 50)
                .background(Color.blue.opacity(0.1)).foregroundStyle(.blue).clipShape(Capsule())
                
                Button("No") {
                    withAnimation { showDiscardPopup = false }
                }
                .frame(maxWidth: .infinity).frame(height: 50)
                .background(Color.blue).foregroundStyle(.white).clipShape(Capsule())
            }
        }
        .padding(32)
        .background(RoundedRectangle(cornerRadius: 28).fill(.white))
        .padding(.horizontal, 30)
    }
}

// MARK: - Preview
#Preview {
    AddTransactionView()
}
