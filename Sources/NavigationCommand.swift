import Foundation
import Compass
import Aftermath

extension Location: Projection {}

public struct NavigationCommand: Command {

  public typealias ProjectionType = Location

  public let URLString: String
  public let payload: Any?

  // MARK: - Initialization

  public init(URN: String, payload: Any? = nil) {
    self.URLString = "\(Compass.scheme)\(URN)"
    self.payload = payload
  }

  public init(URL: NSURL, payload: Any? = nil) {
    self.URLString = URL.absoluteString
    self.payload = payload
  }
}
