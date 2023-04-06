import Foundation

/// A protocol that defines requirements for an HTTP request that expects a `Decodable` model from the response.
public protocol HTTPCodableRequest: HTTPRequest {
  /// The `Decodable` type expected from the response body.
  associatedtype ResponseType: Decodable

  var body: Encodable? { get }
  
  /// The `JSONDecoder` object used to decode the response model.
  var jsonDecoder: JSONDecoder { get }

  /// The `JSONEncoder` object used to encode the request model in the body.
  var jsonEncoder: JSONEncoder { get }
}

public extension HTTPCodableRequest {
  var body: Encodable? {
    nil
  }
  
  var jsonDecoder: JSONDecoder {
    JSONDecoder()
  }

  var jsonEncoder: JSONEncoder {
    JSONEncoder()
  }
}
