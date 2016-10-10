import Foundation
import Compass
import Aftermath

public struct CompassCommand: Command {
  public typealias Output = Location

  public let URLString: String
  public let payload: Any?

  // MARK: - Initialization

  public init(URN: String, payload: Any? = nil) {
    self.URLString = "\(Compass.scheme)\(URN)"
    self.payload = payload
  }

  public init(URL: Foundation.URL, payload: Any? = nil) {
    self.URLString = URL.absoluteString
    self.payload = payload
  }
}
