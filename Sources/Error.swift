import Foundation

public enum NavigationError: ErrorType {
  case InvalidURN(scheme: String, URN: String)
  case URLCouldNotBeParsed(scheme: String, URL: NSURL)
}
