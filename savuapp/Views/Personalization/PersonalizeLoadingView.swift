// PersonalizeLoadingView.swift
// savuapp > Views > Personalization

import SwiftUI

struct PersonalizeLoadingView: View {
    @State private var progress: Double = 0
    @State private var navigateToResult = false
    @State private var currentMessageIndex = 0

    var isRepersonalizing: Bool = false
    var dismissAll: (() -> Void)? = nil

    let messages = [
        "Analyzing your profile...",
        "Setting up personalization...",
        "Building your insights...",
        "Almost there..."
    ]

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Animated icon
            ZStack {
                Circle()
                    .stroke(AppTheme.Colors.light, lineWidth: 6)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [AppTheme.Colors.primary, AppTheme.Colors.primary.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progress)

                Image(systemName: "sparkles")
                    .font(.system(size: 36))
                    .foregroundColor(AppTheme.Colors.primary)
                    .scaleEffect(progress > 0.5 ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: progress)
            }

            VStack(spacing: 12) {
                Text(isRepersonalizing ? "Updating Savu" : "Personalizing Savu")
                    .font(AppTheme.Typography.title2)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Text(messages[currentMessageIndex])
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .animation(.easeInOut, value: currentMessageIndex)
            }

            // Progress bar
            VStack(spacing: 8) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.Colors.light)
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.Colors.primary)
                            .frame(width: geo.size.width * progress, height: 6)
                            .animation(.easeInOut(duration: 0.5), value: progress)
                    }
                }
                .frame(height: 6)

                Text("\(Int(progress * 100))%")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(.horizontal, 60)

            Spacer()
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.white)
        .onAppear { startLoading() }
        .navigationDestination(isPresented: $navigateToResult) {
            PersonalizeResultView(
                isRepersonalizing: isRepersonalizing,
                dismissAll: dismissAll
            )
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func startLoading() {
        let totalDuration = 5.0
        let steps = 20
        let interval = totalDuration / Double(steps)

        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                withAnimation {
                    progress = Double(i) / Double(steps)
                    currentMessageIndex = min(i / (steps / messages.count), messages.count - 1)
                }

                if i == steps {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigateToResult = true
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PersonalizeLoadingView()
    }
}
