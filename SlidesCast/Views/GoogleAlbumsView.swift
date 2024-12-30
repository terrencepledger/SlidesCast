//
//  GoogleAlbumsView.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//


import SwiftUI

struct GoogleAlbumsView: View {
    @StateObject private var viewModel = GoogleAlbumViewModel()
    @State private var showError: Bool = false

    var body: some View {
        NavigationView {
            List(viewModel.albums, id: \.id) { album in
                VStack(alignment: .leading) {
                    Text(album.title)
                        .font(.headline)
                    Text(album.productUrl)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Google Albums")
            .task {
                await viewModel.loadAlbums()
            }
            .onChange(of: viewModel.error) {
                if let error = viewModel.error, error == .accessTokenError {
                    showError = true
                }
            }
            .alert(isPresented: $showError, error: viewModel.error,
                   actions: { error in Button("Dismiss") { } },
                   message: { error in Text(error.recoverySuggestion ?? "Please try again") }
            )
        }
    }
}