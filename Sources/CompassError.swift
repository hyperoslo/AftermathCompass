import Foundation

public enum CompassError: Error {
  case invalidURLString(String)
  case invalidRoute(URL)
}
