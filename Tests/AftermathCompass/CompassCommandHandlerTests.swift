import XCTest
import Compass
@testable import AftermathCompass

class CompassCommandHandlerTests: XCTestCase {

  var command: CompassCommand!
  var commandHandler: CompassCommandHandler!

  override func setUp() {
    super.setUp()

    Navigator.scheme = "tests"
    Navigator.routes = [
      "profile:{user}",
    ]

    commandHandler = CompassCommandHandler()
  }

  override func tearDown() {
    super.tearDown()
    Navigator.routes.removeAll()
  }

  // MARK: - Tests

  func testHandleWithValidURL() {
    let url = URL(string: "tests://profile:1")!
    let payload = "Test"

    command = CompassCommand(URL: url, payload: payload)

    do {
      let event = try commandHandler.handle(command: command)

      switch event {
      case .data(let location):
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
      let event = try commandHandler.handle(command: command)
      XCTFail("Command handler returned  invalid event: \(event)")
    } catch {
      guard let navigationError = error as? CompassError else {
        XCTFail("Command handler returned invalid error: \(error)")
        return
      }

      switch navigationError {
      case .invalidURLString(let URLString):
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
      let event = try commandHandler.handle(command: command)
      XCTFail("Command handler returned  invalid event: \(event)")
    } catch {
      guard let navigationError = error as? CompassError else {
        XCTFail("Command handler returned invalid error: \(error)")
        return
      }

      switch navigationError {
      case .invalidRoute(let URL):
        XCTAssertEqual(URL.absoluteString, command.URLString)
      default:
        XCTFail("Command handler returned invalid error: \(error)")
        break
      }
    }
  }
}
