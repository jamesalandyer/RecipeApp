//
//  Network.swift
//  Recipes
//
//  Created by James Dyer on 10/10/24.
//

import Foundation

enum Network {
    static func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else { return response.data }
        switch httpResponse.statusCode {
        case 200..<300: return response.data
        case 400: throw NetworkError.badRequest
        case 401: throw NetworkError.unauthorized
        case 402: throw NetworkError.paymentRequired
        case 403: throw NetworkError.forbidden
        case 404: throw NetworkError.notFound
        case 413: throw NetworkError.requestEntityTooLarge
        case 422: throw NetworkError.unprocessableEntity
        default: throw NetworkError.http(httpResponse: httpResponse, data: response.data)
        }
    }
}

enum NetworkError: Error, CustomStringConvertible {
    case missingRequiredFields(String)
    case invalidParameters(operation: String, parameters: [Any])
    case badRequest
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case requestEntityTooLarge
    case unprocessableEntity
    case http(httpResponse: HTTPURLResponse, data: Data)
    case invalidResponse(Data)
    case deleteOperationFailed(String)
    case network(URLError)
    case unknown(Error?)

    var description: String {
        switch self {
        case .missingRequiredFields(let message): message
        case .invalidParameters(let operation, let parameters): String(localized: "Invalid Parameters")
        case .badRequest: String(localized: "Bad Request")
        case .unauthorized: String(localized: "Unauthorized")
        case .paymentRequired: String(localized: "Payment Required")
        case .forbidden: String(localized: "Forbidden")
        case .notFound: String(localized: "Not Found")
        case .requestEntityTooLarge: String(localized: "Size Issue")
        case .unprocessableEntity: String(localized: "Unprocessable")
        case .http(let httpResponse, let data): String(localized: "Invalid Request")
        case .invalidResponse(let data): String(localized: "Invalid Response")
        case .deleteOperationFailed: String(localized: "Operation Failed")
        case .network: String(localized: "Network Issue")
        case .unknown: String(localized: "Unknown Issue")
        }
    }
}
