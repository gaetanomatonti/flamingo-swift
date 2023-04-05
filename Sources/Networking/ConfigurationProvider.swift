import Foundation

/// A protocol that defines requirements to configure the networking layer.
public protocol ConfigurationProvider {
  /// Whether logging should be enabled.
  var isLoggingEnabled: Bool { get }

  /// The instance of the `URLSession` used to execute network requests.
  var session: URLSession { get }
}

extension ConfigurationProvider {
  var session: URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration)
  }
}

/// A default configuration for the networking layer.
struct DefaultConfiguration: ConfigurationProvider {
  let isLoggingEnabled = true
}
