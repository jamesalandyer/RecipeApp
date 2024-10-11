//
//  Lifecycle.swift
//  Recipes
//
//  Created by James Dyer on 10/10/24.
//

public enum Lifecycle: Equatable {
    case loading, content, error(String)

    public var isError: Bool {
        switch self {
        case .error: true
        default: false
        }
    }
}
