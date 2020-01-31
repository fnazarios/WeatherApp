import Foundation
import RxSwift

public struct NoContent: Codable { }

public final class Api {
    private let endpoint: ApiEndpointExposable
    
    public init(endpoint: ApiEndpointExposable) {
        self.endpoint = endpoint
    }
  
    public func fireInTheHole() -> Observable<Data> {
        return makeRequest()
            .flatMap { request in
                self.execute(request: request)
            }
    }
    
    private func makeRequest() -> Observable<URLRequest> {
        return Observable.deferred {
            var urlComponent = URLComponents(string: self.endpoint.absoluteStringUrl)
            
            if self.endpoint.method == .get && !self.endpoint.parameters.isEmpty {
                urlComponent?.queryItems = self.endpoint.parameters
                    .map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
            
            guard let url = urlComponent?.url else {
                throw ApiError.malformedRequest
            }
            
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = self.endpoint.method.rawValue
            if self.endpoint.shouldAppendBody, let body = self.endpoint.body {
                request.httpBody = body
            }

            return Observable.just(request)
        }
    }
    
    private func execute(request: URLRequest) -> Observable<Data> {
        Observable.create { observer in
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { data, response, error in
                let httpResponse = response as? HTTPURLResponse

                guard let urlResponse = httpResponse else {
                    observer.onError(ApiError.connectionFailure)
                    return
                }
                
                let status = HTTPStatusCode(rawValue: urlResponse.statusCode) ?? .processing
                
                switch status {
                case .ok:
                    observer.onNext(data ?? Data())
                case .unauthorized:
                    observer.onError(ApiError.unauthorized)
                case .badRequest:
                    observer.onError(ApiError.badRequest)
                default:
                    observer.onError(ApiError.unknown(nil))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

extension Api {
    private func prettyPrint(_ jsonData: Data?) -> String {
        guard let data = jsonData else {
            return ""
        }
        
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
            
            let data = try JSONSerialization.data(withJSONObject: jsonObj ?? [:], options: .prettyPrinted)
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? ""
            
            return string as String
        } catch {
            return ""
        }
    }
}

extension URLRequest {
    func cURLDescription() -> String {
        guard
            let url = self.url,
            let method = self.httpMethod
            else {
                return "$ curl command could not be created"
        }
        
        var components = ["$ curl -v"]
        
        components.append("-X \(method)")
        
        for header in self.allHTTPHeaderFields ?? [:] {
            let escapedValue = header.value.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-H \"\(header.key): \(escapedValue)\"")
        }
        
        //        if let httpBodyData = self.httpBody {
        //            let httpBody = String(decoding: httpBodyData, as: UTF8.self)
        //            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
        //            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
        //
        //            components.append("-d \"\(escapedBody)\"")
        //        }
        
        components.append("\"\(url.absoluteString)\"")
        
        return components.joined(separator: " \\\n\t")
    }
}

public func prepareBody<T: Encodable>(with payload: T) -> Data? {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    
    do {
        return try jsonEncoder.encode(payload)
    } catch {
        print("Failure to prepare payload. \(error)")
        return nil
    }
}
