import Foundation
import Compass
import Aftermath

public struct NavigationCommandHandler: CommandHandler {

  public func handle(command: NavigationCommand) throws -> Event<Location> {
    guard let URL = NSURL(string: command.URLString) else {
      throw NavigationError.InvalidURLString(command.URLString)
    }

    guard let location = Compass.parse(URL) else {
      throw NavigationError.URLCouldNotBeParsed(URL)
    }

    return Event.Success(location)
  }
}
