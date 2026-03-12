// Profile.swift
// savuapp > Profile > View

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    @State private var goSettings      = false
    @State private var goChangeProfile = false
    @State private var goCategory      = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("Profile")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)

                ScrollView {
                    VStack(spacing: 12) {
                        profileCard
                        menuCard
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 16)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goSettings) {
                SettingsView(profileVM: viewModel)
            }
            .navigationDestination(isPresented: $goChangeProfile) {
                ChangeProfileView(profileVM: viewModel)
            }
            .navigationDestination(isPresented: $goCategory) {
                CategoryView()
            }
        }
    }

    // MARK: - Profile Card
    private var profileCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 56, height: 56)
                if let img = viewModel.profileImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 52)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                        .foregroundColor(.white.opacity(0.85))
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(viewModel.fullName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    // Pencil — tap langsung ke Change Profile
                    Button(action: { goChangeProfile = true }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                }
                Text(viewModel.tagline)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.75))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0, green: 0.22, blue: 0.68), location: 0.00),
                    Gradient.Stop(color: Color(red: 0, green: 0.3,  blue: 0.9),  location: 0.82),
                    Gradient.Stop(color: Color(red: 0, green: 0.3,  blue: 0.9),  location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.95, y: 0.61),
                endPoint:   UnitPoint(x: 0.22, y: 0.5)
            )
        )
        .cornerRadius(16)
    }

    // MARK: - Menu Card
    private var menuCard: some View {
        VStack(spacing: 0) {
            menuRow(icon: "gearshape",            label: "Settings")               { goSettings = true }
            Divider().padding(.leading, 52)
            menuRow(icon: "person",               label: "Change Personalization") {}   // kosong
            Divider().padding(.leading, 52)
            menuRow(icon: "slider.horizontal.3",  label: "Category Settings")      { goCategory = true }
            Divider().padding(.leading, 52)
            menuRow(icon: "questionmark.circle",  label: "Tutorial")               {}
        }
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    private func menuRow(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 1000)
                        .fill(Color(hex: "EEF1FF"))
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "4A6CF7"))
                }
                Text(label)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundColor(Color(.systemGray3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView()
}
