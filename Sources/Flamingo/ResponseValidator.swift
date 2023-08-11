import Foundation

/// An object that validates the response to a `HTTPRequest`.
struct ResponseValidator<Request> where Request: HTTPRequest {

  // MARK: - Stored Properties

  /// The request associated to the response.
  let request: Request
  
  /// The response to validate.
  let response: HTTPURLResponse
  
  /// The body of the response.
  let body: Data
  
  /// The status codes that allow an empty response body.
  private let emptyStatusCodes: Set<Int> = [204, 205]

  // MARK: - Computed Properties

  /// Whether an empty body should be allowed in the response.
  var allowsEmptyResponse: Bool {
    emptyStatusCodes.contains(response.statusCode)
  }
  
  /// Whether the response has an empty body.
  var hasEmptyResponse: Bool {
    body.isEmpty
  }

  // MARK: - Init

  init(request: Request, response: HTTPURLResponse, body: Data) {
    self.request = request
    self.response = response
    self.body = body
  }
  
  // MARK: - Functions
  
  /// Validates the response to the `HTTPRequest`.
  ///
  /// This method validates the response by looking at its status code.
  /// If the status code represents a success (`2xx`) the body is also validated.
  ///
  /// - Throws: A `NetworkingError.http(statusCode:)` error if the status code represents a network failure.
  func validate() throws {
    let statusCode = response.statusCode
    
    switch statusCode {
      case (200...299):
        try validate(body: body)

      default:
        throw NetworkingError.http(statusCode: statusCode)
    }
  }
  
  
  /// Validates the body of the response.
  /// - Parameter body: The body of the response.
  /// - Throws: An error of the `Error` type.
  func validate(body: Data) throws {
    guard hasEmptyResponse == false else {
      if allowsEmptyResponse == false {
        throw Error.unexpectedEmptyBody
      }
      
      return
    }
    
    let jsonObject = try JSONSerialization.jsonObject(with: body)
    let isValidJSON = JSONSerialization.isValidJSONObject(jsonObject)
    
    if isValidJSON == false {
      throw Error.invalidJSON
    }
  }
}

extension ResponseValidator {
  /// The errors that can be thrown during response validation.
  enum Error: Swift.Error, LocalizedError {
    /// The response unexpectedly has an empty body.
    case unexpectedEmptyBody
    
    /// The body of the response is not in a valid JSON format.
    case invalidJSON
    
    var errorDescription: String? {
      switch self {
      case .unexpectedEmptyBody:
        return "The response has an empty body but the request does not allow it."
        
      case .invalidJSON:
        return " The body of the response is not in a valid JSON format."
      }
    }
  }
}
