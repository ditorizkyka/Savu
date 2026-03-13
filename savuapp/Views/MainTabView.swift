import SwiftUI

// MARK: - Tab Item Model
private struct TabItem {
    let icon: String
    let activeIcon: String
    let label: String
}

// MARK: - Glass Tab Bar
private struct GlassTabBar: View {
    @Binding var selectedTab: Int

    private let tabs: [TabItem] = [
        TabItem(icon: "house",        activeIcon: "house.fill",        label: "Home"),
        TabItem(icon: "wallet.bifold",  activeIcon: "wallet.bifold.fill",  label: "Transaction"),
        TabItem(icon: "person",       activeIcon: "person.fill",       label: "Profile"),
    ]

    private let activeColor  = Color(red: 0.12, green: 0.20, blue: 0.58)
    private let inactiveColor = Color(red: 0.44, green: 0.49, blue: 0.65)
    private let bubbleColor  = Color(red: 0.87, green: 0.90, blue: 0.97)

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                } label: {
                    VStack() {
                        ZStack {
                            // Active bubble
                            if selectedTab == index {
                                Circle()
                                    .fill(bubbleColor)
                                    .frame(width: 40, height: 40)
                                    .transition(.scale.combined(with: .opacity))
                            }

                            Image(systemName: selectedTab == index ? tab.activeIcon : tab.icon)
                                .font(.system(size: 22, weight: selectedTab == index ? .semibold : .regular))
                                .foregroundStyle(selectedTab == index ? activeColor : inactiveColor)
                                .frame(width: 40, height: 40)
                        }

                        Text(tab.label)
                            .font(.system(size: 11, weight: selectedTab == index ? .bold : .regular))
                            .foregroundStyle(selectedTab == index ? activeColor : inactiveColor)
                    }
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 6)
        .padding(.bottom, 8)
        // Glass background
        .background {
            ZStack {
                // Frosted glass layer
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.ultraThinMaterial)

                // Subtle white overlay for brightness
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.white.opacity(0.55))

                // Hair-line border
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.6), lineWidth: 0.5)
            }
            .shadow(color: Color(red: 0.12, green: 0.20, blue: 0.58).opacity(0.10), radius: 24, x: 0, y: 8)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal, 60)
    }
}

// MARK: - MainTabView
struct MainTabView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // ── Tab content ──────────────────────────────────────────────────
            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomeView()
                }
                .tag(0)

                NavigationStack {
                    TransactionView()
                }
                .tag(1)

                ProfileView()
                    .tag(2)
            }
            // Hide the native tab bar
            .toolbar(.hidden, for: .tabBar)

            // ── Floating glass bar ────────────────────────────────────────────
            GlassTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 22)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
}
