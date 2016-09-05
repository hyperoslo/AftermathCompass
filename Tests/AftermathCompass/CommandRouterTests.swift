import XCTest
import Compass
import Aftermath
@testable import AftermathCompass

class CommandRouterTests: XCTestCase {

  var commandRouter: CommandRouter!
  var commandRoute: TestCommandRoute!

  override func setUp() {
    super.setUp()

    commandRouter = CommandRouter()
    commandRoute = TestCommandRoute()
    commandRouter.routes["command"] = commandRoute

    Compass.scheme = "tests"
    Compass.routes = [
      "command"
    ]
  }

  override func tearDown() {
    super.tearDown()
    Compass.routes.removeAll()
  }

  // MARK: - Tests

  func testExecuteSuccess() {
    let URN = "command"
    let location = Location(path: URN)
    let result = commandRouter.execute(location)

    XCTAssertTrue(result)
    XCTAssertEqual(commandRoute.location?.path, URN)
    XCTAssertTrue(commandRoute.location?.arguments.isEmpty == true)
  }

  func testExecuteError() {
    let URN = "error"
    let location = Location(path: URN)
    let result = commandRouter.execute(location)

    XCTAssertFalse(result)
    XCTAssertNil(commandRoute.location)
  }
}
