//
//  ContentView.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 11/03/26.
//

import SwiftUI

struct ContentView: View {

    let diContainer: AppDIContainer

    @State private var notesViewModel: NotesViewModel?

    var body: some View {
        NavigationStack {
            HomeView(diContainer: diContainer)
        }
        .task {
            if notesViewModel == nil {
                notesViewModel = diContainer.makeNotesViewModel()
            }
        }
    }
}

#Preview {
    ContentView(diContainer: .preview)
}
