import XCTest
import Compass
@testable import AftermathCompass

class CompassCommandHandlerTests: XCTestCase {

  var command: CompassCommand!
  var commandHandler: CompassCommandHandler!

  override func setUp() {
    super.setUp()

    Compass.scheme = "tests"
    Compass.routes = [
      "profile:{user}",
    ]

    commandHandler = CompassCommandHandler()
  }

  override func tearDown() {
    super.tearDown()
    Compass.routes.removeAll()
  }

  // MARK: - Tests

  func testHandleWithValidURL() {
    let URL = NSURL(string: "tests://profile:1")!
    let payload = "Test"

    command = CompassCommand(URL: URL, payload: payload)

    do {
      let event = try commandHandler.handle(command)

      switch event {
      case .Success(let location):
        XCTAssertEqual(location.path, "profile:{user}")
        XCTAssertEqual(location.arguments["user"], "1")
        XCTAssertEqual(location.payload as? String, payload)
      default:
        XCTFail("Command handler returned invalid event: \(event)")
        break
      }
    } catch {
      XCTFail("Command handler failed with error: \(error)")
    }
  }

  func testHandleWithInvalidURL() {
    let URN = "|"
    command = CompassCommand(URN: URN)

    do {
      let event = try commandHandler.handle(command)
      XCTFail("Command handler returned  invalid event: \(event)")
    } catch {
      guard let navigationError = error as? CompassError else {
        XCTFail("Command handler returned invalid error: \(error)")
        return
      }

      switch navigationError {
      case .InvalidURLString(let URLString):
        XCTAssertEqual(URLString, command.URLString)
      default:
        XCTFail("Command handler returned invalid error: \(error)")
        break
      }
    }
  }

  func testHandleWithInvalidRoute() {
    let URN = "login"
    command = CompassCommand(URN: URN)

    do {
      let event = try commandHandler.handle(command)
      XCTFail("Command handler returned  invalid event: \(event)")
    } catch {
      guard let navigationError = error as? CompassError else {
        XCTFail("Command handler returned invalid error: \(error)")
        return
      }

      switch navigationError {
      case .InvalidRoute(let URL):
        XCTAssertEqual(URL.absoluteString, command.URLString)
      default:
        XCTFail("Command handler returned invalid error: \(error)")
        break
      }
    }
  }
}
