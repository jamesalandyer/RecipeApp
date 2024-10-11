//
//  RecipesListView.swift
//  Recipes
//
//  Created by James Dyer on 10/10/24.
//

import SwiftUI

struct RecipesListView: View {
    @Environment(\.openURL) private var openURL: OpenURLAction

    @Binding private var selectedCuisine: String?

    private let cuisines: [String]
    private let recipes: [Recipe]

    init(for recipes: [Recipe], cuisines: [String], selectedCuisine: Binding<String?>) {
        self.recipes = recipes
        self.cuisines = cuisines
        self._selectedCuisine = selectedCuisine
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 12, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(recipes) { recipe in
                        HStack(spacing: 16) {
                            if let image = recipe.smallImage {
                                CachedAsyncImage(url: image) { image in
                                    image.resizable().aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Color(red: 255 / 255, green: 214 / 255, blue: 209 / 255)
                                        .frame(width: 120, height: 120)
                                        .overlay {
                                            Image(systemName: "photo")
                                                .foregroundStyle(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                                        }
                                }
                                .frame(width: 120, height: 120)
                                .clipShape(.rect(cornerRadius: 15))
                            }

                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(recipe.name)
                                        .font(.headline)

                                    if let cuisine = recipe.cuisine {
                                        Text("\(cuisine) Cuisine")
                                            .font(.subheadline)
                                    }
                                }

                                Spacer(minLength: 8)

                                HStack(spacing: 8) {
                                    if let youtube = recipe.youtube {
                                        Button {
                                            openURL(youtube)
                                        } label: {
                                            Text("YouTube")
                                                .font(.subheadline)
                                                .tint(.white)
                                                .frame(maxWidth: .infinity)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(.red)
                                                .clipShape(.rect(cornerRadius: 10))
                                        }
                                    }
                                    if let article = recipe.article {
                                        Button {
                                            openURL(article)
                                        } label: {
                                            Text("Article")
                                                .font(.subheadline)
                                                .tint(.white)
                                                .frame(maxWidth: .infinity)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(.orange)
                                                .clipShape(.rect(cornerRadius: 10))
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                        .clipShape(.rect(cornerRadius: 15))
                        .padding(.horizontal, 20)
                        .transition(.scale.combined(with: .opacity))
                    }
                } header: {
                    HStack(spacing: .zero) {
                        Text("Recipes")
                            .font(.headline)
                            .tint(.white)

                        Spacer(minLength: 8)

                        Menu {
                            Button("All") { withAnimation { selectedCuisine = nil } }

                            ForEach(cuisines, id: \.self) { cuisine in
                                Button(cuisine) { withAnimation { selectedCuisine = cuisine } }
                            }
                        } label: {
                            Text(selectedCuisine ?? String(localized: "All"))
                                .font(.headline)
                        }
                        .tint(Color(red: 247 / 255, green: 90 / 255, blue: 69 / 255))
                    }
                    .padding(20)
                    .background(.regularMaterial)
                }
            }
        }
        .padding(.top, 1) // ScrollView bug where it doesn't respect safe area
        .scrollIndicators(.never)
    }
}
