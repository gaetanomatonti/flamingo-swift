import Foundation

/// A protocol that defines requirements for an object that can be converted into a `URLRequest`.
public protocol URLRequestConvertible {
  /// The `URLRequest` representation of the object.
  var urlRequest: URLRequest? { get }
}
