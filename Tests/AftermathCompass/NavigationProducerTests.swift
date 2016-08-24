import XCTest
import Compass
import Aftermath
@testable import AftermathCompass

class NavigationProducerTests: XCTestCase, CommandProducer {

  var producer: NavigationProducer!
  var commandHandler: NavigationCommandHandler!
  var router: Router!
  var route: TestRoute!
  var errorRoute: ErrorRoute!
  var controller: Controller!

  override func setUp() {
    super.setUp()

    Compass.scheme = "tests"
    Compass.routes = [
      "login",
      "profile"
    ]

    router = Router()
    route = TestRoute()
    errorRoute = ErrorRoute()
    controller = Controller()

    router.routes["login"] = route
    router.errorRoute = errorRoute

    producer = NavigationProducer(router: { self.router }, currentController: { self.controller })
    commandHandler = NavigationCommandHandler()

    Engine.sharedInstance.use(commandHandler)
  }

  override func tearDown() {
    super.tearDown()
    Compass.routes.removeAll()
  }

  // MARK: - Tests

  func testSuccessReaction() {
    let URN = "login"
    let payload = "Test"
    let command = NavigationCommand(URN: URN, payload: payload)

    execute(command)

    XCTAssertNil(errorRoute.error)
    XCTAssertEqual(route.location?.path, URN)
    XCTAssertTrue(route.location?.arguments.isEmpty == true)
    XCTAssertEqual(route.location?.payload as? String, payload)
  }

  func testNavigationErrorReaction() {
    let URN = "error"
    let command = NavigationCommand(URN: URN)

    execute(command)

    XCTAssertNil(route.location)
    XCTAssertTrue(errorRoute.error is NavigationError)
  }

  func testRouteErrorReaction() {
    let URN = "profile"
    let command = NavigationCommand(URN: URN)

    execute(command)

    XCTAssertNil(route.location)
    XCTAssertTrue(errorRoute.error is RouteError)
  }
}
