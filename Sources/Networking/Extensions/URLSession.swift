import Foundation

extension URLSession {
  public static var ephemeral: URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration)
  }
}
