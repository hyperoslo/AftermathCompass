import Foundation
import Compass
import Aftermath

public struct NavigationCommandHandler: CommandHandler {

  public init() {}

  // MARK: - Command handling

  public func handle(command: NavigationCommand) throws -> Event<NavigationCommand> {
    guard let URL = NSURL(string: command.URLString) else {
      throw NavigationError.InvalidURLString(command.URLString)
    }

    guard let location = Compass.parse(URL, payload: command.payload) else {
      throw NavigationError.InvalidRoute(URL)
    }

    return Event.Success(location)
  }
}
