import XCTest
import Compass
import Aftermath
@testable import AftermathCompass

class CompassProducerTests: XCTestCase, CommandProducer {

  var producer: CompassProducer!
  var commandHandler: CompassCommandHandler!
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

    producer = CompassProducer(router: { self.router }, currentController: { self.controller })
    commandHandler = CompassCommandHandler()

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
    let command = CompassCommand(URN: URN, payload: payload)

    execute(command)

    XCTAssertNil(errorRoute.error)
    XCTAssertEqual(route.location?.path, URN)
    XCTAssertTrue(route.location?.arguments.isEmpty == true)
    XCTAssertEqual(route.location?.payload as? String, payload)
  }

  func testNavigationErrorReaction() {
    let URN = "error"
    let command = CompassCommand(URN: URN)

    execute(command)

    XCTAssertNil(route.location)
    XCTAssertTrue(errorRoute.error is CompassError)
  }

  func testRouteErrorReaction() {
    let URN = "profile"
    let command = CompassCommand(URN: URN)

    execute(command)

    XCTAssertNil(route.location)
    XCTAssertTrue(errorRoute.error is RouteError)
  }
}
