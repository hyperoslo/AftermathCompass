import Foundation
import Compass
import Aftermath

public struct CompassCommandHandler: CommandHandler {

  public init() {}

  // MARK: - Command handling

  public func handle(command: CompassCommand) throws -> Event<CompassCommand> {
    guard let URL = NSURL(string: command.URLString) else {
      throw CompassError.InvalidURLString(command.URLString)
    }

    guard let location = Compass.parse(URL, payload: command.payload) else {
      throw CompassError.InvalidRoute(URL)
    }

    return Event.Success(location)
  }
}
