// SettingsView.swift
// savuapp > Profile > View

import SwiftUI

struct SettingsView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            navBar

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    sectionCard(title: "ACCOUNT") {
                        navRow(icon: "person.crop.circle", label: "Profile Information")
                        Divider().padding(.leading, 52)
                        navRow(icon: "lock.shield", label: "Security & Privacy")
                    }

                    sectionCard(title: "PREFERENCES") {
                        toggleRow(icon: "bell",  label: "Notifications", binding: $profileVM.notificationsEnabled)
                        Divider().padding(.leading, 52)
                        toggleRow(icon: "moon",  label: "Dark Mode",     binding: $profileVM.darkModeEnabled)
                        Divider().padding(.leading, 52)
                        detailRow(icon: "globe", label: "Language",      detail: profileVM.selectedLanguage)
                    }

                    sectionCard(title: "SUPPORT") {
                        detailRow(icon: "info.circle", label: "About", detail: "Version 1.0.0")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
    }

    // MARK: Nav Bar
    private var navBar: some View {
        ZStack {
            Text("Settings")
                .font(.system(size: 17, weight: .semibold))
            HStack {
                Button(action: { dismiss() }) {
                    Text("Back")
                        .font(.system(size: 15))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 14)
    }

    // MARK: Section Builder
    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.horizontal, 4)
                .padding(.bottom, 6)

            VStack(spacing: 0) { content() }
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: Row Types
    private func iconBox(_ name: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color(hex: "EEF1FF"))
                .frame(width: 34, height: 34)
            Image(systemName: name)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "4A6CF7"))
        }
    }

    private func navRow(icon: String, label: String) -> some View {
        HStack(spacing: 14) {
            iconBox(icon)
            Text(label).font(.system(size: 15))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(Color(.systemGray3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    private func toggleRow(icon: String, label: String, binding: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            iconBox(icon)
            Text(label).font(.system(size: 15))
            Spacer()
            Toggle("", isOn: binding).labelsHidden().tint(Color(hex: "4A6CF7"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    private func detailRow(icon: String, label: String, detail: String) -> some View {
        HStack(spacing: 14) {
            iconBox(icon)
            Text(label).font(.system(size: 15))
            Spacer()
            Text(detail)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(Color(.systemGray3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }
}

#Preview {
    NavigationStack {
        SettingsView(profileVM: ProfileViewModel())
    }
}
