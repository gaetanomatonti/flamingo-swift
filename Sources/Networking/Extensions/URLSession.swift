import Foundation

extension URLSession {
  public static var ephemeral: URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration)
  }
  
  public static var mock: URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
  }
}
