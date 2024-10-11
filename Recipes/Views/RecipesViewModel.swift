//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by James Dyer on 10/10/24.
//

import Foundation
import Combine

public final class RecipesViewModel: ObservableObject {
    @Published public var lifecycle: Lifecycle = .loading
    @Published public var cuisines: [String] = []
    @Published public var recipes: [Recipe] = []

    private var disposables: Set<AnyCancellable> = []

    private let api: String

    public init(api: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") {
        self.api = api
    }

    @MainActor
    public func load() async {
        lifecycle = .loading
        guard let url = URL(string: api) else {
            lifecycle = .error(String(localized: "Unable to find url"))
            return
        }
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            recipes = try JSONDecoder().decode(RecipesResponse.self, from: try Network.mapResponse(response: (data, response))).recipes
            cuisines = Array(Set(recipes.compactMap { $0.cuisine }))
            lifecycle = .content
        } catch {
            recipes = []
            cuisines = []
            let networkError = error as? NetworkError
            lifecycle = .error(networkError?.description ?? String(localized: "Unable to load recipes"))
        }
    }
}

private struct RecipesResponse: Codable {
    let recipes: [Recipe]
}
