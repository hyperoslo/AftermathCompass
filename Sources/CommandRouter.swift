import Aftermath
import Compass

// MARK: - Command route

public protocol CommandRoute {
  func buildCommand(from location: Location) throws -> AnyCommand
}

// MARK: - Command router

public struct CommandRouter: CommandProducer {
  public var routes = [String : CommandRoute]()
  public init() {}

  public func execute(location: Location) -> Bool {
    guard let route = routes[location.path] else {
      return false
    }

    execute(builder: RouteCommandBuilder(route: route, location: location))
    return true
  }
}

// MARK: - Route command builder

struct RouteCommandBuilder: CommandBuilder {
  let route: CommandRoute
  let location: Location

  func buildCommand() throws -> AnyCommand {
    return try route.buildCommand(from: location)
  }
}
