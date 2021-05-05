

import Foundation

enum CommonSetting {
    static let perPage = 100
    static let startPageNumber = 1
}

enum HTTPUrl {
    static let githubBaseUrl = "https://api.github.com/search/users?"
}


enum CustomError: Error {
    case httpResponseError
    case jsonDecoingError
    case dataError
    case httpServerError
    case noResultFoundError
}
