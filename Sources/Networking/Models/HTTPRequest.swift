import Foundation

/// A protocol that defines requirements for an HTTP request.
public protocol HTTPRequest: URLRequestConvertible {
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

  var timeout: TimeInterval {
    30
  }

  var urlRequest: URLRequest? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = "/" + path.joined(separator: "/")
    urlComponents.queryItems = query?.map { key, value in
      URLQueryItem(name: key.description, value: value.description)
    }

    guard let url = urlComponents.url else {
      return nil
    }

    var urlRequest = URLRequest(url: url, timeoutInterval: timeout)
    urlRequest.httpMethod = method.rawValue
    defaultHeaders.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
    customHeaders.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

    return urlRequest
  }
}
