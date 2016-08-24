import Compass

class TestRoute: Routable {

  var location: Location?

  func navigate(to location: Location, from currentController: Controller) throws {
    self.location = location
  }
}

class ErrorRoute: ErrorRoutable {

  var error: ErrorType?

  func handle(routeError: ErrorType, from currentController: Controller) {
    error = routeError
  }
}
