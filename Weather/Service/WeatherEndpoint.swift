import Foundation

enum WeatherEndpoint {
    case search(city: String)
}

extension WeatherEndpoint: ApiEndpointExposable {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/weather"
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .search(let city):
            return ["q": city, "appid": "c7cea5a67a75c97651eed69251569b02"]
        }
    }
}
