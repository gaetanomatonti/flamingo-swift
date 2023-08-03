import Foundation

public struct RequestMapper<Request> where Request: HTTPRequest {
  enum Error: Swift.Error {
    case invalidURL
  }
  
  let request: Request
  
  public init(request: Request) {
    self.request = request
  }
  
  public func mapToURLRequest() throws -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = request.host
    urlComponents.path = "/" + request.path.joined(separator: "/")
    urlComponents.queryItems = request.query?.map { key, value in
      URLQueryItem(name: key.description, value: value.description)
    }

    guard let url = urlComponents.url else {
      throw Error.invalidURL
    }

    var urlRequest = URLRequest(url: url, timeoutInterval: request.timeout)
    urlRequest.httpMethod = request.method.rawValue
    request.defaultHeaders.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
    request.customHeaders.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

    return urlRequest
  }
}
