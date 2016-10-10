import XCTest
import Compass
import Aftermath
@testable import AftermathCompass

class CompassProducerTests: XCTestCase, CommandProducer {

  var manager: CompassManager!
  var commandHandler: CompassCommandHandler!
  var router: Router!
  var route: TestRoute!
  var errorRoute: ErrorRoute!
  var commandRouter: CommandRouter!
  var commandRoute: TestCommandRoute!
  var controller: Controller!

  override func setUp() {
    super.setUp()

    // Navigation router
    router = Router()
    route = TestRoute()
    errorRoute = ErrorRoute()
    router.routes["login"] = route
    router.errorRoute = errorRoute

    // Command router
    commandRouter = CommandRouter()
    commandRoute = TestCommandRoute()
    commandRouter.routes["command"] = commandRoute

    Compass.scheme = "tests"
    Compass.routes = [
      "login",
      "profile",
      "command"
    ]

    manager = CompassManager(
      router: { self.router },
      commandRouter: { self.commandRouter },
      currentController: { self.controller }
    )

    controller = Controller()
    commandHandler = CompassCommandHandler()

    Engine.sharedInstance.use(handler: commandHandler)
  }

  override func tearDown() {
    super.tearDown()
    Compass.routes.removeAll()
    Engine.sharedInstance.invalidate()
  }

  // MARK: - Tests

  func testNavigationDataReaction() {
    let URN = "login"
    let payload = "Test"
    let command = CompassCommand(URN: URN, payload: payload)

    execute(command: command)

    XCTAssertNil(errorRoute.error)
    XCTAssertNil(commandRoute.location)
    XCTAssertEqual(route.location?.path, URN)
    XCTAssertTrue(route.location?.arguments.isEmpty == true)
    XCTAssertEqual(route.location?.payload as? String, payload)
  }

  func testNavigationErrorReaction() {
    let URN = "error"
    let command = CompassCommand(URN: URN)

    execute(command: command)

    XCTAssertNil(route.location)
    XCTAssertNil(commandRoute.location)
    XCTAssertTrue(errorRoute.error is CompassError)
  }

  func testCommandDataReaction() {
    let URN = "command"
    let command = CompassCommand(URN: URN)

    execute(command: command)

    XCTAssertNil(route.location)
    XCTAssertNil(errorRoute.error)
    XCTAssertEqual(commandRoute.location?.path, URN)
    XCTAssertTrue(commandRoute.location?.arguments.isEmpty == true)
  }

  func testRouteErrorReaction() {
    let URN = "profile"
    let command = CompassCommand(URN: URN)

    execute(command: command)

    XCTAssertNil(route.location)
    XCTAssertNil(commandRoute.location)
    XCTAssertTrue(errorRoute.error is RouteError)
  }
}
