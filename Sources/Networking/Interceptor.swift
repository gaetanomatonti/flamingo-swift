import Foundation

/// An object that intercepts and processes network requests.
public struct Interceptor {
  /// Adapts a `URLRequest`.
  let adapt: (URLRequest) -> URLRequest
  
  /// Whether a `URLRequest` should be retried.
  let shouldRetry: (URLRequest, HTTPURLResponse) -> Bool
  
  /// Creates an instance for an `Adapter`.
  /// - Parameters:
  ///   - adapt: Adapts a `URLRequest`.
  ///   - shouldAdapt: Whether a `URLRequest` should be adapted.
  public init(
    adapt: @escaping (URLRequest) -> URLRequest,
    shouldRetry: @escaping (URLRequest, HTTPURLResponse) -> Bool
  ) {
    self.adapt = adapt
    self.shouldRetry = shouldRetry
  }
}

extension Interceptor {
  /// A default `Interceptor` instance.
  ///
  /// This instance returns the `URLRequest` as-is and never adapts it.
  public static var `default`: Interceptor {
    Interceptor { request in
      return request
    } shouldRetry: { _, _ in
      return false
    }
  }
}
