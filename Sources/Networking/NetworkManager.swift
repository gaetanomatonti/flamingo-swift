import Foundation

/// An object that manages network requests.
public struct NetworkManager {
  /// The `URLSession` object used to execute the `URLRequest`s.
  let session: URLSession
  
  /// The object that intercepts and processes the network requests.
  let interceptor: Interceptor
  
  /// Creates an instance of `NetworkManager`.
  /// - Parameters:
  ///   - interceptor: The object that intercepts and processes the network requests. Defaults to an instance that returns the requests as they are.
  ///   - session: The `URLSession` object used to execute the `URLRequest`s. Defaults to an ephemeral session.
  ///   - isLoggingEnabled: Whether logging is enabled. Defaults to `true`.
  public init(interceptor: Interceptor = .default, session: URLSession = .ephemeral, isLoggingEnabled: Bool = true) {
    self.interceptor = interceptor
    self.session = session
    Logger.isLoggingEnabled = isLoggingEnabled
  }
}

// MARK: - Functions

extension NetworkManager {
  /// Executes an `HTTPRequest`.
  /// - Parameter request: The `HTTPRequest` to execute.
  /// - Returns: The decoded response model.
  public func execute<Request>(_ request: Request) async throws -> Request.ResponseType where Request: HTTPRequest {
    let requestMapper = RequestMapper(request: request)
    
    var urlRequest: URLRequest = try {
      let request = try requestMapper.mapToURLRequest()
      return interceptor.adapt(request)
    }()
    
    if let body = request.body {
      let encodedBody = try request.jsonEncoder.encode(body)
      urlRequest.httpBody = encodedBody
    }

    Logger.log(request: urlRequest)

    let (data, response) = try await session.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkingError.invalidURLResponse
    }
    
    guard !interceptor.shouldRetry(urlRequest, httpResponse) else {
      return try await execute(request)
    }

    Logger.log(data: data, response: response)
    
    do {
      try validate(httpResponse)

      return try request.jsonDecoder.decode(Request.ResponseType.self, from: data)
    } catch {
      Logger.log(error)
      throw error
    }
  }

  /// Validates whether the request has succeeded, otherwise it throws an error.
  /// - Parameter response: The response to validate.
  func validate(_ response: HTTPURLResponse) throws {
    let statusCode = response.statusCode

    switch statusCode {
      case (200...299):
        break

      default:
        throw NetworkingError.http(statusCode: statusCode)
    }
  }
}
