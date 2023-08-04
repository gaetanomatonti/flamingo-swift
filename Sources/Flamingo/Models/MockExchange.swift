import Foundation

/// An object represening a mocked networking exchange.
public struct MockExchange {
  
  // MARK: - Stored Properties
  
  /// The `URLRequest` associated to the mocked network exchange.
  public let request: URLRequest

  /// The response of the mocked network exhange.
  public let response: MockResponse

  // MARK: - Computed Properties
  
  /// The response in `HTTPURLResponse` format.
  var httpResponse: HTTPURLResponse? {
    guard let url = request.url else {
      return nil
    }

    return HTTPURLResponse(
      url: url,
      statusCode: response.statusCode,
      httpVersion: "HTTP/1.1",
      headerFields: request.allHTTPHeaderFields
    )
  }
  
  // MARK: - Init

  public init(request: URLRequest, response: MockResponse) {
    self.request = request
    self.response = response
  }
}

extension MockExchange: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(request)
    hasher.combine(response)
  }
}

extension MockExchange: Equatable {}
