import Foundation

extension URLSession {
  /// A session configuration that uses no persistent storage for caches, cookies, or credentials.
  public static var ephemeral: URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration)
  }
  
  /// A session configuration that uses the `MockURLProtocol` to mock requests.
  public static var mock: URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
  }
}
