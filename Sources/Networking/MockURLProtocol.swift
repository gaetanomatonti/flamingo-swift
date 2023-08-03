import Foundation

/// An object that handles mocked network exchanges.
public final class MockURLProtocol: URLProtocol {
  /// An enumeration of the errors that can be thrown by the `URLProtocol`.
  enum Error: Swift.Error, LocalizedError {
    /// The `MockExchange` is missing.
    case missingExchange

    /// The response of the exchange is missing.
    case missingResponse

    var errorDescription: String? {
      switch self {
        case .missingExchange:
          return "The MockExchange object corresponding to the request is missing."

        case .missingResponse:
          return "The MockExchange object is missing a response."
      }
    }
  }

  // MARK: - Stored Properties

  /// The set of requests to be mocked.
  private static var mockExchanges: Set<MockExchange> = []

  // MARK: - Functions

  /// Adds a network exchange to the set of network exchanges to be mocked.
  /// - Parameter request: The network exchange to mock.
  public static func add(_ exchange: MockExchange) {
    mockExchanges.insert(exchange)
  }

  /// Adds a set of network exchange to the set of mocked network exchanges.
  /// - Parameter request: The set of network exchanges to mock.
  public static func add(_ exchange: [MockExchange]) {
    mockExchanges.formUnion(exchange)
  }

  public override class func canInit(with request: URLRequest) -> Bool {
    true
  }

  public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }

  public override func startLoading() {
    defer {
      client?.urlProtocolDidFinishLoading(self)
    }

    let mockExchange = Self.mockExchanges.first { mockRequest in
      guard
        let requestURL = request.url,
        let mockRequestURL = mockRequest.request.url
      else {
        return false
      }

      let requestComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)
      let mockRequestComponents = URLComponents(url: mockRequestURL, resolvingAgainstBaseURL: true)

      return request.httpMethod == mockRequest.request.httpMethod &&
      requestComponents?.host == mockRequestComponents?.host &&
      requestComponents?.path == mockRequestComponents?.path &&
      requestComponents?.queryItems?.sorted() == mockRequestComponents?.queryItems?.sorted()
    }

    guard let mockExchange = mockExchange else {
      client?.urlProtocol(self, didFailWithError: Error.missingExchange)
      return
    }

    guard let urlResponse = mockExchange.urlResponse else {
      client?.urlProtocol(self, didFailWithError: Error.missingResponse)
      return
    }

    client?.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .notAllowed)
    client?.urlProtocol(self, didLoad: mockExchange.response.body)
  }

  public override func stopLoading() {}
}
