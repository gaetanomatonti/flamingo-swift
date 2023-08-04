import Foundation

/// An object that maps a `HTTPRequest` to `URLRequest`.
struct RequestMapper<Request> where Request: HTTPRequest {
    
  // MARK: - Stored Properties
  
  /// The request to map.
  let request: Request
  
  // MARK: - Init
  
  /// Create an instance of `RequestMapper`.
  /// - Parameter request: The request to map.
  init(request: Request) {
    self.request = request
  }
  
  // MARK: - Functions
  
  /// Maps the `HTTPRequest` into `URLRequest`.
  /// - Returns: The mapped `URLRequest`.
  func mapURLRequest() throws -> URLRequest {
    let url = try mapURL()
    
    var urlRequest = URLRequest(url: url, timeoutInterval: request.timeout)
    urlRequest.httpMethod = request.method.rawValue
    request.defaultHeaders.forEach { urlRequest.setValue($0.value.description, forHTTPHeaderField: $0.key) }
    request.customHeaders.forEach { urlRequest.setValue($0.value.description, forHTTPHeaderField: $0.key) }
    
    if let body = request.body {
      let encodedBody = try request.jsonEncoder.encode(body)
      urlRequest.httpBody = encodedBody
    }

    return urlRequest
  }
  
  /// Creates the `URL` of the request.
  /// - Returns: The `URL` of the request.
  func mapURL() throws -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = request.host
    urlComponents.path = "/" + request.path.joined(separator: "/")
    urlComponents.queryItems = request.query?.map { key, value in
      URLQueryItem(name: key.description, value: value.description)
    }

    guard let url = urlComponents.url else {
      throw Error.invalidURL
    }

    return url
  }
}

extension RequestMapper {
  /// The errors that can be throws by the `RequestMapper`.
  enum Error: Swift.Error {
    /// The `URL` is invalid.
    case invalidURL
  }
}
