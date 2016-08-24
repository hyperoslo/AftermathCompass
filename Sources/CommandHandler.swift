import Foundation
import Compass
import Aftermath

public struct NavigationCommandHandler: CommandHandler {

  public func handle(command: NavigationCommand) throws -> Event<Location> {
    let URN = command.URN
    let stringURL = "\(Compass.scheme)\(URN)"

    guard let URL = NSURL(string: stringURL) else {
      throw NavigationError.InvalidURN(scheme: Compass.scheme, URN: URN)
    }

    guard let location = Compass.parse(URL) else {
      throw NavigationError.URLCouldNotBeParsed(scheme: Compass.scheme, URL: URL)
    }

    return Event.Success(location)
  }
}
