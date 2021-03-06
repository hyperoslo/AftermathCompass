import XCTest
import Compass
@testable import AftermathCompass

class CompassCommandTests: XCTestCase {

  var command: CompassCommand!

  override func setUp() {
    super.setUp()
    Navigator.scheme = "tests"
  }

  override func tearDown() {
    super.tearDown()
    Navigator.routes.removeAll()
  }

  // MARK: - Tests

  func testInitWithURN() {
    let URN = "login"
    let payload = "Test"

    command = CompassCommand(URN: URN, payload: payload)

    XCTAssertEqual(command.URLString, "\(Navigator.scheme)\(URN)")
    XCTAssertEqual(command.payload as? String, payload)
  }

  func testInitWithURL() {
    let url = URL(string: "tests://callback?access_token=ya29")!
    let payload = "Test"

    command = CompassCommand(URL: url, payload: payload)

    XCTAssertEqual(command.URLString, url.absoluteString)
    XCTAssertEqual(command.payload as? String, payload)
  }
}
