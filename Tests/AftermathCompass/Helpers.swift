import Aftermath
import Compass
@testable import AftermathCompass

class TestRoute: Routable {

  var location: Location?

  func navigate(to location: Location, from currentController: Controller) throws {
    self.location = location
  }
}

class ErrorRoute: ErrorRoutable {

  var error: Error?

  func handle(routeError: Error, from currentController: Controller) {
    error = routeError
  }
}

struct TestCommand: Command {
  typealias Output = String
}

class TestCommandRoute: CommandRoute {

  var location: Location?

  func buildCommand(from location: Location) throws -> AnyCommand {
    self.location = location
    return TestCommand()
  }
}
