import Foundation
import Compass
import Aftermath

public final class NavigationProducer: ReactionProducer {
  public let router: () -> Router
  public var commandRouter: (() -> CommandRouter)?
  public let currentController: () -> Controller

  // MARK: - Initialization

  public init(router: () -> Router, commandRouter: (() -> CommandRouter)? = nil, currentController: () -> Controller) {
    self.router = router
    self.commandRouter = commandRouter
    self.currentController = currentController
    configure()
  }

  // MARK: - Navigation

  func configure() {
    react(to: NavigationCommand.self, with: Reaction(
      done: { [weak self] (location: Location) in
        guard let weakSelf = self else {
          return
        }

        if weakSelf.commandRouter?().execute(location) == true {
          return
        }

        weakSelf.router().navigate(to: location, from: weakSelf.currentController())
      },
      fail: { [weak self] error in
        guard let weakSelf = self else {
          return
        }

        weakSelf.router().errorRoute?.handle(error, from: weakSelf.currentController())
      })
    )
  }
}
