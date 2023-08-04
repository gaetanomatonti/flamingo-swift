import Foundation

public extension Data {
  /// A `String` representing a pretty printed `JSON`.
  var prettyPrintedJSON: String? {
    guard
      let jsonObject = try? JSONSerialization.jsonObject(with: self),
      let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
      let prettyPrintedString = String(data: jsonData, encoding: .utf8)
    else {
      return nil
    }
    
    return prettyPrintedString
  }
}
