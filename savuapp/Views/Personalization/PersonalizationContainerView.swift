import SwiftUI

struct PersonalizationContainerView: View {
    @StateObject var viewModel = PersonalizationViewModel()
    @State private var currentStep: Int = 1
    @State private var isMovingForward: Bool = true
    @State private var navigateToLoading: Bool = false
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userStore: UserStore
    @Environment(\.dismiss) var dismiss
    let totalSteps = 4

    /// When true, pre-fills from UserStore (re-personalization mode)
    var isRepersonalizing: Bool = false

    /// Closure to dismiss the entire fullScreenCover (re-personalization only)
    var dismissAll: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    if currentStep == 1 {
                        if isRepersonalizing {
                            dismissAll?()
                        } else {
                            dismiss()
                        }
                    } else {
                        isMovingForward = false
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep -= 1
                        }
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
                Spacer()
                Text("Personalization")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.left").opacity(0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 12)

            HStack(spacing: 6) {
                ForEach(1...totalSteps, id: \.self) { step in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(step <= currentStep ? AppTheme.Colors.primary : Color(.systemGray4))
                        .frame(height: 5)
                        .animation(.easeInOut, value: currentStep)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 28)

            Group {
                if currentStep == 1 {
                    Question1View(data: viewModel, currentStep: $currentStep, onDirectionChange: { dir in
                        isMovingForward = dir
                    })
                } else if currentStep == 2 {
                    Question2View(data: viewModel, currentStep: $currentStep, onDirectionChange: { dir in
                        isMovingForward = dir
                    })
                } else if currentStep == 3 {
                    Question3View(data: viewModel, currentStep: $currentStep, onDirectionChange: { dir in
                        isMovingForward = dir
                    })
                } else {
                    Question4View(data: viewModel, currentStep: $currentStep, onFinish: {
                        userStore.savePersonalization(from: viewModel)
                        navigateToLoading = true
                    }, onDirectionChange: { dir in
                        isMovingForward = dir
                    })
                }
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: isMovingForward ? .trailing : .leading),
                    removal: .move(edge: isMovingForward ? .leading : .trailing)
                )
            )
            .animation(.easeInOut(duration: 0.3), value: currentStep)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(AppTheme.Colors.background)
        .onAppear {
            if isRepersonalizing {
                userStore.loadInto(vm: viewModel)
            }
        }
        .navigationDestination(isPresented: $navigateToLoading) {
            PersonalizeLoadingView(
                isRepersonalizing: isRepersonalizing,
                dismissAll: dismissAll
            )
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
