import Foundation

/// An object that manages network requests.
final public class NetworkManager {

  // MARK: - Stored Properties

  /// The instance of the `URLSession` used to execute network requests.
  let session: URLSession

  // MARK: - Init

  public init(configuration: ConfigurationProvider) {
    session = configuration.session
    Logger.isLoggingEnabled = configuration.isLoggingEnabled
  }

  public convenience init() {
    self.init(configuration: DefaultConfiguration())
  }
}

// MARK: - Functions

extension NetworkManager {
  /// Executes an `HTTPCodableRequest`.
  /// - Parameter request: The `HTTPCodableRequest` to execute.
  /// - Returns: The decoded response model.
  public func execute<R: HTTPCodableRequest>(_ request: R) async throws -> R.ResponseType {
    guard let urlRequest = request.urlRequest else {
      throw NetworkingError.invalidURLRequest
    }

    Logger.log(request: urlRequest)

    let (data, response) = try await session.data(for: urlRequest)

    Logger.log(data: data, response: response)
    try validate(response)

    do {
      return try request.jsonDecoder.decode(R.ResponseType.self, from: data)
    } catch {
      Logger.log(error)
      throw error
    }
  }

  /// Validates whether the request has succeeded, otherwise it throws an error.
  /// - Parameter response: The response to validate.
  func validate(_ response: URLResponse) throws {
    guard let response = response as? HTTPURLResponse else {
      throw NetworkingError.invalidURLResponse
    }

    let statusCode = response.statusCode

    switch statusCode {
      case (200...299):
        break

      default:
        throw NetworkingError.http(statusCode: statusCode)
    }
  }
}
