import Foundation

extension URLQueryItem: Comparable {
  public static func < (lhs: URLQueryItem, rhs: URLQueryItem) -> Bool {
    lhs.name < rhs.name
  }
}
