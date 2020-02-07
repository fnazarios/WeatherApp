import Foundation

struct SearchParams {
    let lat: Double
    let lon: Double
    let cnt: Int
}

enum WeatherEndpoint {
    case search(city: SearchParams)
}

extension WeatherEndpoint: ApiEndpointExposable {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/find"
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .search(let params):
            return ["lat": params.lat, "lon": params.lon, "cnt": params.cnt, "appid": "c7cea5a67a75c97651eed69251569b02"]
        }
    }
}
