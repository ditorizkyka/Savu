import SwiftUI

// MARK: - Models
struct WrapCard: Identifiable, Codable {
    var id = UUID()
    let title: String
    let amount: String
    let description: String
    
    // Gradients can't be implicitly Codable, so we store string names
    private let gradientColorNames: [String]
    
    var gradientColors: [Color] {
        gradientColorNames.map { name in
            switch name.lowercased() {
            case "orange": return .orange
            case "red": return .red
            case "teal": return .teal
            case "green": return .green
            case "purple": return .purple
            case "blue": return .blue
            case "black": return .black
            default: return .blue
            }
        }
    }
    
    init(id: UUID = UUID(), title: String, amount: String, description: String, rawColors: [String]) {
        self.id = id
        self.title = title
        self.amount = amount
        self.description = description
        self.gradientColorNames = rawColors
    }
}

// MARK: - TodaysWrapView
struct TodaysWrapView: View {
    @Environment(\.dismiss) private var dismiss
    
    // UI State
    @StateObject private var viewModel = SuggestionViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if viewModel.isGenerating {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.blue)
                        Text("✨ Gemini is analyzing your spending... ✨")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else if viewModel.activeCards.isEmpty {
                    // 4th Screen: Summary View
                    summaryView
                } else {
                    // Card Stack
                    ZStack {
                        ForEach(Array(viewModel.activeCards.enumerated()), id: \.element.id) { index, card in
                            WrapCardView(card: card, index: index, totalCards: viewModel.activeCards.count) {
                                // On swipe dismiss
                                viewModel.dismissCard(id: card.id)
                            }
                        }
                    }
                    .frame(height: 500)
                    
                    Spacer()
                    
                    Button("Skip") {
                        viewModel.skipAll()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Today's Wrap")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                }
            }
            .task {
                await viewModel.generateAIInsights()
            }
        }
    }
    
    // MARK: - Summary View
    private var summaryView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Top Balances
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text(viewModel.todaysExpenseAmount)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.orange)
                        Text("Expenses")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider().frame(height: 30)
                    
                    VStack(spacing: 4) {
                        Text(viewModel.todaysIncomeAmount)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.green)
                        Text("Income")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider().frame(height: 30)
                    
                    VStack(spacing: 4) {
                        Text(viewModel.todaysBalanceAmount)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.blue)
                        Text("Balance")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 16)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.3), lineWidth: 1))
                .padding(.horizontal)
                
                // Insights List
                VStack(spacing: 16) {
                    if viewModel.fullCards.isEmpty {
                        Text("No insights for today.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    } else {
                        ForEach(viewModel.fullCards) { card in
                            insightBanner(
                                title: card.title,
                                description: card.description,
                                colors: card.gradientColors
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
        }
    }
    
    private func insightBanner(title: String, description: String, colors: [Color]) -> some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(2)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
        .shadow(color: colors.last!.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Swipeable Card View
struct WrapCardView: View {
    let card: WrapCard
    let index: Int
    let totalCards: Int
    let onDismiss: () -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        // Only the top card is fully opaque and interactive
        let isTopCard = index == totalCards - 1
        
        // Stack effect (cards behind are smaller and lower)
        let stackOffset = CGFloat(totalCards - 1 - index) * 20
        let stackScale = 1.0 - CGFloat(totalCards - 1 - index) * 0.05
        
        VStack(spacing: 16) {
            Text(card.title)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
            
            Text(card.amount)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text(card.description)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 32)
        }
        .frame(width: 300, height: 420)
        .background(
            LinearGradient(colors: card.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        
        // Positioning and Transformations
        .offset(y: stackOffset) // Visual stack offset
        .scaleEffect(stackScale) // Visual stack scaling
        
        // Gesture Transformations (only apply to top card)
        .offset(x: isTopCard ? offset.width : 0, y: isTopCard ? offset.height : 0)
        .rotationEffect(.degrees(Double(isTopCard ? offset.width / 15 : 0)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if isTopCard {
                        offset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if isTopCard {
                        // Dismiss if dragged far enough
                        if abs(offset.width) > 100 {
                            withAnimation(.easeOut(duration: 0.3)) {
                                offset.width = offset.width > 0 ? 500 : -500
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onDismiss()
                            }
                        } else {
                            // Snap back
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                    }
                }
        )
        .disabled(!isTopCard)
    }
}

#Preview {
    TodaysWrapView()
}
