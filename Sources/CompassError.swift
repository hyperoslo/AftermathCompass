import Foundation

public enum CompassError: ErrorType {
  case InvalidURLString(String)
  case InvalidRoute(NSURL)
}
