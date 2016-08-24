import Compass
import Aftermath

extension Location: Projection {}

public struct NavigationCommand: Command {

  public typealias ProjectionType = Location

  public let URN: String
  public let payload: Any?

  // MARK: - Initialization

  public init(URN: String, payload: Any?) {
    self.URN = URN
    self.payload = payload
  }
}
