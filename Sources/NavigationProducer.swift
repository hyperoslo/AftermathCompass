import Foundation
import Compass
import Aftermath

public final class NavigationProducer: ReactionProducer {
  public let router: () -> Router
  public let currentController: () -> Controller

  // MARK: - Initialization

  public init(router: () -> Router, currentController: () -> Controller) {
    self.router = router
    self.currentController = currentController
    configure()
  }

  // MARK: - Navigation

  func configure() {
    react(
      done: { [weak self] (location: Location) in
        guard let weakSelf = self else {
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
  }
}
