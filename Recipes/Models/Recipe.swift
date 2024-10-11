//
//  Recipe.swift
//  Recipes
//
//  Created by James Dyer on 10/10/24.
//

import Foundation

public struct Recipe: Identifiable, Hashable, Codable {
    public var id: String

    let name: String
    let cuisine: String?
    let smallImage: URL?
    let largeImage: URL?
    let article: URL?
    let youtube: URL?

    init(
        id: String,
        name: String,
        cuisine: String? = nil,
        smallImage: URL? = nil,
        largeImage: URL? = nil,
        article: URL? = nil,
        youtube: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.smallImage = smallImage
        self.largeImage = largeImage
        self.article = article
        self.youtube = youtube
    }

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case smallImage = "photo_url_small"
        case largeImage = "photo_url_large"
        case article = "source_url"
        case youtube = "youtube_url"
    }
}
