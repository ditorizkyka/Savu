import SwiftUI

// HAPUS class PersonalizationData di sini — sudah dipindah ke PersonalizationData.swift

struct PersonalizationContainerView: View {
    @StateObject var data = PersonalizationData()
    @State private var currentStep: Int = 1
    @Environment(\.dismiss) var dismiss
    let totalSteps = 3

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    if currentStep == 1 { dismiss() }
                    else { withAnimation { currentStep -= 1 } }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Personalization")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.left").opacity(0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 12)

            HStack(spacing: 6) {
                ForEach(1...totalSteps, id: \.self) { step in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(step <= currentStep ? Color.blue : Color(.systemGray4))
                        .frame(height: 5)
                        .animation(.easeInOut, value: currentStep)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 28)

            Group {
                if currentStep == 1 {
                    Question1View(data: data, currentStep: $currentStep)
                } else if currentStep == 2 {
                    Question2View(data: data, currentStep: $currentStep)
                } else {
                    Question3View(data: data, currentStep: $currentStep)
                }
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                )
            )
            .animation(.easeInOut(duration: 0.3), value: currentStep)
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
}

