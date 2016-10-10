import Foundation
import Compass
import Aftermath

struct CompassCommandHandler: CommandHandler {

  // MARK: - Command handling

  func handle(command: CompassCommand) throws -> Event<CompassCommand> {
    guard let URL = URL(string: command.URLString) else {
      throw CompassError.invalidURLString(command.URLString)
    }

    guard let location = Compass.parse(url: URL, payload: command.payload) else {
      throw CompassError.invalidRoute(URL)
    }

    return Event.data(location)
  }
}
