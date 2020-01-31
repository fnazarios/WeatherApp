import Foundation

public protocol ApiEndpointExposable {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var body: Data? { get }
    var isTokenNeeded: Bool { get }
    var customHeaders: [String: String] { get }
    var absoluteStringUrl: String { get }
    var shouldAppendBody: Bool { get }
}

public extension ApiEndpointExposable {
    var baseURL: URL {
        guard let url = URL(string: "https://runin-a2e1d.firebaseio.com") else {
            fatalError("You need to define the api url")
        }
        return url
    }
    
    var absoluteStringUrl: String {
        return "\(baseURL)/\(path)"
    }
    
    var shouldAppendBody: Bool {
        return (method == .post || method == .put || method == .patch) && body != nil
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    var body: Data? {
        return nil
    }
    
    var isTokenNeeded: Bool {
        return true
    }
    
    var customHeaders: [String: String] {
        return [:]
    }
}
