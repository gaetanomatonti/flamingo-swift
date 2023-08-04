import Foundation

/// An object that logs messages in the console.
struct Logger {

  /// Whether logging is enabled.
  static var isLoggingEnabled = true

  // MARK: - Functions

  static func log(request: URLRequest) {
    guard Self.isLoggingEnabled else {
      return
    }
    
    let httpMethod = request.httpMethod ?? ""
    let headers = request.allHTTPHeaderFields?.description ?? ""

    print("⤴️" + " \(httpMethod) " + request.description + "\n" + headers)
  }

  static func log(data: Data, response: URLResponse) {
    guard Self.isLoggingEnabled else {
      return
    }

    if let response = response as? HTTPURLResponse {
      print("ℹ️" + " " + response.description)
    }

    if let json = data.prettyPrintedJSON {
      print(json)
    }
  }

  static func log(_ error: Error) {
    guard Self.isLoggingEnabled else {
      return
    }

    print("❌" + " " + error.localizedDescription)
  }
}
