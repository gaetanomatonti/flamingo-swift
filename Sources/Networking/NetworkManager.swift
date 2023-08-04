import Foundation

/// An object that manages network requests.
public struct NetworkManager {
  
  // MARK: - Stored Properties

  /// The `URLSession` object used to execute the `URLRequest`s.
  let session: URLSession
  
  /// The object that intercepts and processes the network requests.
  let interceptor: Interceptor
  
  // MARK: - Init
  
  /// Creates an instance of `NetworkManager`.
  /// - Parameters:
  ///   - interceptor: The object that intercepts and processes the network requests. Defaults to an instance that returns the requests as they are.
  ///   - session: The `URLSession` object used to execute the `URLRequest`s. Defaults to an ephemeral session.
  ///   - isLoggingEnabled: Whether logging is enabled. Defaults to `true`.
  public init(interceptor: Interceptor = .default, session: URLSession = .ephemeral, isLoggingEnabled: Bool = true) {
    self.interceptor = interceptor
    self.session = session
    Logger.isLoggingEnabled = isLoggingEnabled
  }
  
  // MARK: - Functions
  
  /// Executes an `HTTPRequest`.
  /// - Parameter request: The `HTTPRequest` to execute.
  /// - Returns: The decoded response model.
  public func execute<Request>(_ request: Request) async throws -> Response<Request.ResponseModel> where Request: HTTPRequest {
    let requestMapper = RequestMapper(request: request)
    
    let urlRequest: URLRequest = try {
      let request = try requestMapper.mapURLRequest()
      return interceptor.adapt(request)
    }()

    Logger.log(request: urlRequest)

    let (responseData, response) = try await session.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkingError.invalidURLResponse
    }
    
    guard !interceptor.shouldRetry(urlRequest, httpResponse) else {
      return try await execute(request)
    }

    do {
      let validator = ResponseValidator(request: request, response: httpResponse, body: responseData)
      try validator.validate()

      Logger.log(data: responseData, response: response)
      
      if validator.hasEmptyResponse {
        if let responseType = Request.ResponseModel.self as? EmptyResponse.Type, let responseModel = responseType.init() as? Request.ResponseModel {
          return Response(request: urlRequest, statusCode: httpResponse.statusCode, model: responseModel)
        } else {
          throw NetworkingError.invalidEmptyResponse
        }
      }

      let responseModel = try request.jsonDecoder.decode(Request.ResponseModel.self, from: responseData)
      return Response(request: urlRequest, statusCode: httpResponse.statusCode, model: responseModel)
    } catch {
      Logger.log(error)
      throw error
    }
  }
}

