# AftermathCompass

[![CI Status](http://img.shields.io/travis/hyperoslo/AftermathCompass.svg?style=flat)](https://travis-ci.org/hyperoslo/AftermathCompass)
[![Version](https://img.shields.io/cocoapods/v/AftermathCompass.svg?style=flat)](http://cocoadocs.org/docsets/AftermathCompass)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/AftermathCompass.svg?style=flat)](http://cocoadocs.org/docsets/AftermathCompass)
[![Platform](https://img.shields.io/cocoapods/p/AftermathCompass.svg?style=flat)](http://cocoadocs.org/docsets/AftermathCompass)

## Description

**AftermathCompass** is a message-driven navigation system built on top of
[Aftermath](https://github.com/hyperoslo/Aftermath) and
[Compass](https://github.com/hyperoslo/Compass).

## Usage

Create your first route and error handler:

```swift
import Compass

struct ProfileRoute: Routable {

  func navigate(to location: Location, from currentController: Controller) throws {
    guard let id = location.arguments["id"] else {
      throw RouteError.InvalidArguments(location)
    }

    let controller = ProfileController(id: id)
    currentController.navigationController?.pushViewController(controller, animated: true)
  }
}

struct ErrorRoute: ErrorRoutable {

  func handle(routeError: ErrorType, from currentController: Controller) {
    let controller = ErrorController(error: routeError)
    currentController.navigationController?.pushViewController(controller, animated: true)
  }
}
```

Configure `Compass` scheme, router and `Aftermath` in your `AppDelegate`:

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  let router = Router()
  var navigationProducer: NavigationProducer!
  lazy var navigationController = UINavigationController(rootViewController: ViewController())

  lazy var window: UIWindow? = {
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    return window
  }()

  func currentController() -> UIViewController {
    return navigationController.topViewController!
  }

  // ...

  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      window?.rootViewController = navigationController
      window?.makeKeyAndVisible()

      // ...
      configureCompass()
      configureAftermath()
      return true
  }

  func configureCompass() {
    Compass.scheme = "aftermath"
    Compass.routes = ["login"]

    router.errorRoute = ErrorRoute()
    router.routes = [
      "login": LoginRoute()
    ]
  }

  func configureAftermath() {
    Engine.sharedInstance.use(NavigationCommandHandler())

    navigationProducer = NavigationProducer(
      router: { self.router },
      currentController: currentController
    )
  }

  // ...
}
```

Start your journey:

```swift
import Aftermath
import AftermathCompass

class ViewController: UIViewController, CommandProducer  {

  // ...

  func logout() {
    execute(NavigationCommand(URN: "login"))
  }

  // ...
}
```

## Installation

**AftermathCompass** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AftermathCompass'
```

**AftermathCompass** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "hyperoslo/AftermathCompass"
```

**AftermathCompass** can also be installed manually. Just download and drop `Sources` folders in your project.

## Author

Hyper Interaktiv AS, ios@hyper.no

## Contributing

We would love you to contribute to **AftermathCompass**, check the [CONTRIBUTING](https://github.com/hyperoslo/AftermathCompass/blob/master/CONTRIBUTING.md) file for more info.

## License

**AftermathCompass** is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/AftermathCompass/blob/master/LICENSE.md) file for more info.
