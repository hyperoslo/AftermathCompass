import Foundation
import Compass
import Aftermath

// MARK: - Command

extension Location: Projection {}

public struct NavigationCommand: Command {

  public typealias ProjectionType = Location

  public let URN: String
  public let payload: Any?
}

public enum NavigationError: ErrorType {
  case InvalidURN(scheme: String, URN: String)
  case URLCouldNotBeParsed(scheme: String, URL: NSURL)
}

// MARK: - Command handler

public struct NavigationCommandHandler: CommandHandler {

  public func handle(command: NavigationCommand) throws -> Event<Location> {
    let URN = command.URN
    let stringURL = "\(Compass.scheme)\(URN)"

    guard let URL = NSURL(string: stringURL) else {
      throw NavigationError.InvalidURN(scheme: Compass.scheme, URN: URN)
    }

    guard let location = Compass.parse(URL) else {
      throw NavigationError.URLCouldNotBeParsed(scheme: Compass.scheme, URL: URL)
    }

    return Event.Success(location)
  }
}

public final class NavigationProducer: ReactionProducer {
  public let router: () -> Router
  public let currentController: () -> Controller

  // MARK: - Initialization

  public init(router: () -> Router, currentController: () -> Controller) {
    self.router = router
    self.currentController = currentController
  }

  // MARK: - Navigation

  func navigate() {
    let controller = self.currentController()

    react(
      done: { location in
        self.router().navigate(to: location, from: controller)
      },
      fail: { error in
        self.router().errorRoute?.handle(error, from: controller)
    })
  }
}

