// SplashScreenView.swift
// savuapp

import SwiftUI

struct SplashScreenView: View {

    // MARK: - Animation State
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 16
    @State private var taglineOpacity: Double = 0
    @State private var screenOpacity: Double = 1

    // Called when the splash finishes so the parent can switch views
    var onFinished: () -> Void

    var body: some View {
        ZStack {
            // Background — matches the header colour in HomeView
            Color(red: 0.02, green: 0.05, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // App icon / logo
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                // App name
                Text("Savu")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .opacity(titleOpacity)
                    .offset(y: titleOffset)

                // Tagline
                Text("Your smart finance companion")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.55))
                    .opacity(taglineOpacity)
            }
        }
        .opacity(screenOpacity)
        .onAppear { animate() }
    }

    // MARK: - Animation Sequence
    private func animate() {
        // 1. Logo pops in
        withAnimation(.spring(response: 0.6, dampingFraction: 0.65)) {
            logoScale = 1.0
            logoOpacity = 1
        }

        // 2. Title slides up
        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
            titleOpacity = 1
            titleOffset = 0
        }

        // 3. Tagline fades in
        withAnimation(.easeOut(duration: 0.4).delay(0.55)) {
            taglineOpacity = 1
        }

        // 4. Hold, then fade entire screen out and call onFinished
        withAnimation(.easeIn(duration: 0.4).delay(1.6)) {
            screenOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            onFinished()
        }
    }
}

#Preview {
    SplashScreenView(onFinished: {})
}
