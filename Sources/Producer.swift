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

