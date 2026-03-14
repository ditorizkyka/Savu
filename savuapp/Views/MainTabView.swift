import SwiftUI

// MARK: - MainTabView
struct MainTabView: View {
    @State private var selectedTab: Int = 0

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
        .onAppear {
            // Apply standard liquid glass background via UITabBarAppearance
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
}
