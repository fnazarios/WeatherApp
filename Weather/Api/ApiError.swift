import Foundation

public enum ApiError: Error {
    case notFound
    case unauthorized
    case badRequest
    case connectionFailure
    case decodeError(Error?)
    case malformedRequest
    case serverError
    case timeout
    case unknown(_: Error?)
}
