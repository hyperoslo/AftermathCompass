import Foundation

public enum NavigationError: ErrorType {
  case InvalidURLString(String)
  case InvalidRoute(NSURL)
}
