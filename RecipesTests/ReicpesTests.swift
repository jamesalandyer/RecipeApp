//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by James Dyer on 10/10/24.
//

import Testing
import Recipes

struct ReicpesTests {
    @Test func viewModelContentTest() async throws {
        let viewModel = RecipesViewModel()
        await viewModel.load()
        #expect(!viewModel.recipes.isEmpty && viewModel.lifecycle == .content)
    }

    @Test func viewModelEmptyTest() async throws {
        let viewModel = RecipesViewModel(api: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
        await viewModel.load()
        #expect(viewModel.recipes.isEmpty && viewModel.lifecycle == .content)
    }

    @Test func viewModelErrorTest() async throws {
        let viewModel = RecipesViewModel(api: "")
        await viewModel.load()
        #expect(viewModel.recipes.isEmpty && viewModel.lifecycle.isError)
    }

    @Test func viewModelBadDataTest() async throws {
        let viewModel = RecipesViewModel(api: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        await viewModel.load()
        #expect(viewModel.recipes.isEmpty && viewModel.lifecycle.isError)
    }
}
