import Foundation

/// An object representing the response of a mocked request.
public struct MockResponse {

  // MARK: - Stored Properties

  /// The status code of the response.
  public let statusCode: Int

  /// The expected body of the response. Defaults to an empty `Data` object.
  public let body: Data

  /// The error expected from the request.
  public let error: Error?


  // MARK: - Init

  public init(statusCode: Int = 200, body: Data = Data(), error: Error? = nil) {
    self.statusCode = statusCode
    self.body = body
    self.error = error
  }
}

// MARK: - Hashable

extension MockResponse: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(statusCode)
    hasher.combine(body)
  }
}

// MARK: - Equatable

extension MockResponse: Equatable {
  public static func == (lhs: MockResponse, rhs: MockResponse) -> Bool {
    lhs.statusCode == rhs.statusCode &&
    lhs.body == rhs.body
  }
}
