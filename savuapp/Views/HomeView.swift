// MARK: - Imports
import SwiftUI

// MARK: - Main Type Declaration
struct HomeView: View {
    // MARK: - Properties
    @State private var selectedMonth: String = "March"
    private let months = ["January", "February", "March", "April", "May", "June"]
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Header & Card Layering
                    ZStack(alignment: .top) {
                        // 1. Background Biru Tua (Layer Bawah)
                        headerBackground
                        
                        // 2. Konten Profil & Card (Layer Atas)
                        VStack(spacing: 0) {
                            profileHeader
                            balanceCard
                        }
                    }
                    
                    // MARK: - Main Content Area
                    VStack(spacing: 24) {
                        suggestionSection
                        overviewSection
                    }
                    .padding(20)
                }
            }
            .background(Color(uiColor: .systemBackground))
            
            floatingActionButton
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - Private Methods (Subviews)
extension HomeView {
    
    private var headerBackground: some View {
        Color(red: 0.02, green: 0.05, blue: 0.12)
            .frame(height: 220)
    }
    
    private var profileHeader: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Good Afternoon, Dema")
                    .font(.system(size: 16, weight: .bold))
                Text("You Are The Spender")
                    .font(.system(size: 12))
                    .opacity(0.6)
            }
            .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
        .padding(.bottom, 24)
    }
    
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Total Balance")
                .font(.system(size: 14))
                .opacity(0.9)
            
            Text("Rp 800.000")
                .font(.system(size: 32, weight: .bold))
            
            HStack {
                summaryItem(label: "Income", amount: "Rp 200.000")
                Spacer()
                summaryItem(label: "Expense", amount: "Rp 200.000")
                Spacer()
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(
                    colors: [Color(red: 0.05, green: 0.3, blue: 0.9), Color(red: 0.1, green: 0.2, blue: 0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        )
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 12)
    }
    
    private func summaryItem(label: String, amount: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).opacity(0.8)
            Text(amount).font(.system(size: 14, weight: .bold))
        }
    }
    
    // MARK: - Private Methods (Subviews)
    private var suggestionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Our Suggestion")
                .font(.headline)
            
            Button {
                // Action
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Daily Suggestion Is Being Prepared")
                            .font(.system(size: 15, weight: .bold))
                            .multilineTextAlignment(.leading)
                        
                        Text("Click to add new transaction")
                            .font(.caption)
                            .opacity(0.7)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "rays")
                        .font(.system(size: 24))
                        .opacity(0.5)
                }
                .padding(24)
                .foregroundStyle(.white)
                .background(
                    // Ganti fill Color(white: 0.2) dengan ini:
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: Color(red: 0.22, green: 0.18, blue: 0.1), location: 0),
                                    .init(color: Color(red: 0.1, green: 0.1, blue: 0.1), location: 1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                // Tambahkan overlay tipis agar persis seperti di gambar
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.05), lineWidth: 1)
                )
            }
        }
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview").font(.headline)
            
            VStack(spacing: 24) {
                // Month Dropdown
                Menu {
                    ForEach(months, id: \.self) { month in
                        Button(month) { selectedMonth = month }
                    }
                } label: {
                    HStack {
                        Text(selectedMonth)
                        Image(systemName: "chevron.down")
                    }
                    . font(.caption)
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .frame(width: 150)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                    .foregroundStyle(.black)
                }

                // MARK: - Donut Chart (Original Design)
                ZStack {
                    // Biru Tua
                    Circle()
                        .trim(from: 0, to: 0.45)
                        .stroke(Color(red: 0.02, green: 0.05, blue: 0.12), lineWidth: 30)
                        .rotationEffect(.degrees(-90))
                    
                    // Biru Muda (Transparan/Housing)
                    Circle()
                        .trim(from: 0.45, to: 0.85)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 30)
                        .rotationEffect(.degrees(-90))
                    
                    // Biru Terang (Travel)
                    Circle()
                        .trim(from: 0.85, to: 1.0)
                        .stroke(Color.blue, lineWidth: 30)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Text("Food and\nBeverages").font(.system(size: 10)).multilineTextAlignment(.center).foregroundStyle(.secondary)
                        Text("Rp 300.000").font(.system(size: 16, weight: .bold))
                    }
                }
                .frame(width: 180, height: 180)
                
                // Legend
                VStack(spacing: 12) {
                    legendItem(color: Color(red: 0.02, green: 0.05, blue: 0.12), label: "Food and Beverage", percent: "15%")
                    legendItem(color: .blue, label: "Travel", percent: "20%")
                    legendItem(color: .blue.opacity(0.3), label: "Housing", percent: "65%")
                }
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 24)
                .fill(.white).shadow(color: .black.opacity(0.05), radius: 10))
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        }
    }
    
    private func legendItem(color: Color, label: String, percent: String) -> some View {
        HStack {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(label).font(.caption).foregroundStyle(.secondary)
            Spacer()
            Text(percent).font(.caption).fontWeight(.bold)
        }
    }
    
    private var floatingActionButton: some View {
        Button {} label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(Circle().fill(Color.blue))
                .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
        }
        .padding(.trailing, 24) // Tetap di kanan
        .padding(.bottom, 80)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
