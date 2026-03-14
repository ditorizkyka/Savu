import SwiftUI

// MARK: - MainTabView
struct MainTabView: View {
    @State private var selectedTab: Int = 0

    init() {
        // Glass / translucent tab bar — set in init so it persists
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
            }
            .tag(0)

            NavigationStack {
                TransactionView()
            }
            .tabItem {
                Label("Transaction", systemImage: selectedTab == 1 ? "wallet.bifold.fill" : "wallet.bifold")
            }
            .tag(1)

            ProfileView()
            .tabItem {
                Label("Profile", systemImage: selectedTab == 2 ? "person.fill" : "person")
            }
            .tag(2)
        }
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
}

