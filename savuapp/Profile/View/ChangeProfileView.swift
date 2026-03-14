// ChangeProfileView.swift
// savuapp > Profile > View

import SwiftUI

struct ChangeProfileView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @StateObject private var viewModel = ChangeProfileViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            ScrollView {
                VStack(spacing: 32) {
                    // Avatar picker
                    avatarPicker

                    // Full Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)

                        HStack(spacing: 12) {
                            Image(systemName: "person")
                                .foregroundColor(.secondary)
                                .frame(width: 20)
                            TextField("Full Name", text: $viewModel.fullName)
                                .font(.system(size: 15))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)

                    // Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.saveChanges(to: profileVM)
                            dismiss()
                        }) {
                            Text("Save Changes")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.08, green: 0.36, blue: 0.99))
                                .cornerRadius(14)
                        }

                        Button(action: { dismiss() }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(.systemGray6))
                                .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(AppTheme.Colors.background)
        .navigationBarHidden(true)
        .onAppear { viewModel.load(from: profileVM) }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
    }

    // MARK: - Avatar Picker
    private var avatarPicker: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(hex: "EEF1FF"))
                    .frame(width: 110, height: 110)

                if let img = viewModel.selectedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .foregroundColor(Color(hex: "4A6CF7").opacity(0.5))
                }

                ZStack {
                    Circle()
                        .fill(Color(red: 0.08, green: 0.36, blue: 0.99))
                        .frame(width: 32, height: 32)
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .offset(x: 4, y: 4)
            }
            .onTapGesture { viewModel.showImagePicker = true }

            Text("Tap to change profile photo")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .padding(.top, 10)
    }
}

#Preview {
    NavigationStack {
        ChangeProfileView(profileVM: ProfileViewModel())
    }
}
