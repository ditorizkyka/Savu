//
//  ContentView.swift
//  savuapp
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 64))
                .foregroundStyle(.tint)

            Text("Hello, World!")
                .fontWeight(.bold)
                .font(.largeTitle)

            Text("Welcome to Savu")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
