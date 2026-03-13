import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    VStack(spacing: 0) {
                        // Blue top section dengan image
                        ZStack {
                            AppTheme.Colors.primary
                            
                            // ✅ Ganti dengan image milikmu
                            Image("onboarding_hero") // nama image di Assets.xcassets
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 300)
                                .offset(y: 30)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: proxy.size.height * 0.52)
                        .clipShape(WaveShape())
                        
                        Spacer()
                    }
                    
                    // Bottom content
                    VStack(spacing: AppTheme.Spacing.md) {
                        Spacer()
                        
                        Text("Welcome to Savu!")
                            .font(AppTheme.Typography.title1)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        Text("Track your cash flow and get smart financial\nsuggestions designed just for you!")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer().frame(height: AppTheme.Spacing.md)
                        
                        NavigationLink(destination: PersonalizeIntroView()) {
                            Text("Get Started")
                                .font(AppTheme.Typography.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: AppTheme.ButtonHeight.primary)
                                .background(AppTheme.Colors.primary)
                                .cornerRadius(AppTheme.Radius.button)
                        }
                        .padding(.horizontal, AppTheme.Spacing.xxxl)
                        .padding(.bottom, 48)
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    OnboardingView()
}
