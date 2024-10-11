//
//  RecipesView.swift
//  Recipes
//
//  Created by James Dyer on 10/10/24.
//

import SwiftUI

struct RecipesView: View {
    @StateObject private var viewModel: RecipesViewModel

    @State private var selectedCuisine: String?

    private var recipes: [Recipe] {
        guard let selectedCuisine else { return viewModel.recipes }
        return viewModel.recipes.filter { $0.cuisine == selectedCuisine }
    }

    init(viewModel: RecipesViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if case .loading = viewModel.lifecycle {
                ProgressView()
                    .font(.title2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .transition(.scale.combined(with: .opacity))
            } else if case .error(let message) = viewModel.lifecycle {
                Text(message)
                    .font(.title3)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .transition(.scale.combined(with: .opacity))
            } else if !recipes.isEmpty {
                RecipesListView(
                    for: recipes,
                    cuisines: viewModel.cuisines,
                    selectedCuisine: $selectedCuisine
                )
                .transition(.scale.combined(with: .opacity))
            } else {
                Text("No recipes available")
                    .font(.title3)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: recipes)
        .animation(.easeInOut, value: viewModel.cuisines)
        .animation(.easeInOut, value: viewModel.lifecycle)
        .background(Color(red: 255 / 255, green: 214 / 255, blue: 209 / 255))
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
    }
}

#Preview("List") {
    RecipesView(viewModel: .init())
}

#Preview("Empty") {
    RecipesView(viewModel: .init(api: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"))
}

#Preview("Error") {
    RecipesView(viewModel: .init(api: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"))
}
