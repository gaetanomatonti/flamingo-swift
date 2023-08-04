import Foundation

/// A protocol that defines requirements for an HTTP request.
public protocol HTTPRequest {
  /// The `Decodable` type expected from the response body.
  associatedtype ResponseModel: Decodable

  /// The host of the API `URL`.
  var host: String { get }

  /// The path of the request.
  var path: [String] { get }

  /// The HTTP method of the request.
  var method: HTTPMethod { get }

  /// The query parameters to include in the request. Defaults to `nil`.
  var query: Parameters? { get }
  
  /// The default headers added to all requests. Provides a default value for requests that accept json content.
  var defaultHeaders: HTTPHeaders { get }

  /// The custom header added to specific requests. Defaults to `[:]`.
  var customHeaders: HTTPHeaders { get }
  
  /// The body of the request.
  var body: Encodable? { get }
  
  /// The `JSONDecoder` object used to decode the response model.
  var jsonDecoder: JSONDecoder { get }

  /// The `JSONEncoder` object used to encode the request model in the `body`.
  var jsonEncoder: JSONEncoder { get }

  /// The desired time interval before a timeout error is returned.
  var timeout: TimeInterval { get }
}

public extension HTTPRequest {
  var query: Parameters? {
    nil
  }

  var defaultHeaders: HTTPHeaders {
    [
      "Content-Type": "application/json",
      "Accept": "application/json"
    ]
  }

  var customHeaders: HTTPHeaders {
    [:]
  }
  
  var body: Encodable? {
    nil
  }
  
  var jsonDecoder: JSONDecoder {
    JSONDecoder()
  }

  var jsonEncoder: JSONEncoder {
    JSONEncoder()
  }

  var timeout: TimeInterval {
    30
  }
}
