import Foundation

// An object that represents the response of a network request.
public struct Response<Model> {
  /// The parent request of the response.
  public let request: URLRequest

  /// The status code of the HTTP response.
  public let statusCode: Int
  
  /// The model decoded from the response.
  public let model: Model
}
