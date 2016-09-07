import Foundation
import Compass
import Aftermath

struct CompassCommandHandler: CommandHandler {

  // MARK: - Command handling

  func handle(command: CompassCommand) throws -> Event<CompassCommand> {
    guard let URL = NSURL(string: command.URLString) else {
      throw CompassError.InvalidURLString(command.URLString)
    }

    guard let location = Compass.parse(URL, payload: command.payload) else {
      throw CompassError.InvalidRoute(URL)
    }

    return Event.Data(location)
  }
}
