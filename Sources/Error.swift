import Foundation

public enum NavigationError: ErrorType {
  case InvalidURLString(String)
  case URLCouldNotBeParsed(NSURL)
}
