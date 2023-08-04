import XCTest
@testable import Flamingo

final class InterceptorTests: XCTestCase {
  
  var networkManager: NetworkManager!
  
  override func setUpWithError() throws {
    super.setUp()
    
    let request = Request()
    let requestMapper = RequestMapper(request: request)
    
    let mockRequest = try requestMapper.mapURLRequest()
    
    MockURLProtocol.add(
      MockExchange(request: mockRequest, response: MockResponse(statusCode: 204))
    )
    
    networkManager = NetworkManager(
      interceptor: .default,
      session: .mock
    )
  }
  
  func testAdapter() async throws {
    let interceptor = Interceptor { request in
      var request = request
      request.setValue("test", forHTTPHeaderField: "test")
      return request
    } shouldRetry: { _, _ in
      return false
    }
    
    networkManager = NetworkManager(interceptor: interceptor, session: .mock)

    let request = Request()
    let response = try await networkManager.execute(request)
    
    XCTAssertEqual(response.request.value(forHTTPHeaderField: "test"), "test")
  }
}

extension InterceptorTests {
  struct Request: HTTPRequest {
    typealias ResponseModel = EmptyResponse
    
    let host = "google.com"
    
    let path: [String] = []
    
    let method: HTTPMethod = .get
  }
}
