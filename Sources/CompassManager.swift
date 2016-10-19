import Foundation
import Compass
import Aftermath

public final class CompassManager: ReactionProducer {
  public let router: () -> Router
  public var commandRouter: (() -> CommandRouter)?
  public let currentController: () -> CurrentController

  // MARK: - Initialization

  public init(router: @escaping () -> Router, commandRouter: (() -> CommandRouter)? = nil, currentController: @escaping () -> CurrentController) {
    self.router = router
    self.commandRouter = commandRouter
    self.currentController = currentController
    configure()
  }

  // MARK: - Navigation

  func configure() {
    Engine.shared.use(handler: CompassCommandHandler())

    react(to: CompassCommand.self, with: Reaction(
      consume: { [weak self] (location: Location) in
        guard let weakSelf = self else {
          return
        }

        if weakSelf.commandRouter?().execute(location) == true {
          return
        }

        weakSelf.router().navigate(to: location, from: weakSelf.currentController())
      },
      rescue: { [weak self] error in
        guard let weakSelf = self else {
          return
        }

        weakSelf.router().errorRoute?.handle(routeError: error, from: weakSelf.currentController())
      })
    )
  }
}
