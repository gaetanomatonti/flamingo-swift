import Foundation

/// The possible networking errors that can occur during the execution of a network request.
enum NetworkingError: Error {
  /// The `URLRequest` is invalid.
  case invalidURLRequest

  /// The `URLResponse` is invalid.
  case invalidURLResponse
  
  case invalidEmptyResponse

  /// The request failed with a specific status code.
  case http(statusCode: Int)
}

extension NetworkingError: LocalizedError {
  var errorDescription: String? {
    switch self {
      case .invalidURLRequest:
        return "The URL request is invalid."

      case .invalidURLResponse:
        return "The URL response is invalid."
      
      case .invalidEmptyResponse:
        return "Invalid empty response type."

      case let .http(statusCode):
        return "Request failed with status code \(statusCode)"
    }
  }
}
