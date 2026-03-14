import SwiftUI

struct Question1View: View {
    @ObservedObject var data: PersonalizationViewModel
    @Binding var currentStep: Int
    var onDirectionChange: ((Bool) -> Void)? = nil
    
    // Enum untuk memudahkan management focus
    enum Field {
        case name, email
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Question Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Question 1")
                    .font(AppTheme.Typography.title2)
                
                Text("Let's get to know you")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text("*We need your identity to personalize your experience")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxl)
            
            // Input Fields Container
            VStack(alignment: .leading, spacing: 20) {
                
                // Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    
                    TextField("Enter your name", text: $data.username)
                        .modifier(CustomTextFieldStyle(isFocused: focusedField == .name))
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .textInputAutocapitalization(.words)
                }
                
                // Email Field
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email Address")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    
                    TextField(
                        text: $data.email,
                        prompt: Text("example@mail.com")
                            .foregroundColor(.gray.opacity(0.6)) // Mengubah warna hint/placeholder
                    ) {
                        Text("Email Address")
                    }
                    .modifier(CustomTextFieldStyle(isFocused: focusedField == .email))
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .submitLabel(.done)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Bottom Buttons
            BottomNavButtons(
                currentStep: $currentStep,
                canGoNext: validateInputs(),
                totalSteps: 4,
                onDirectionChange: onDirectionChange
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil // Tutup keyboard saat tap luar
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // Fungsi validasi sederhana
    private func validateInputs() -> Bool {
        let isNameValid = !data.username.trimmingCharacters(in: .whitespaces).isEmpty
        let isEmailValid = data.email.contains("@") && data.email.contains(".")
        return isNameValid && isEmailValid
    }
}

// MARK: - Reusable View Modifier agar kode lebih rapi
struct CustomTextFieldStyle: ViewModifier {
    var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.bodyMedium)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                            .stroke(
                                isFocused ? AppTheme.Colors.primary : AppTheme.Colors.divider,
                                lineWidth: 1.2
                            )
                    )
            )
    }
}

// MARK: - Preview
#Preview("Question Identity") {
    let data = PersonalizationViewModel()
    return Question1View(data: data, currentStep: .constant(0))
}
