import Foundation

struct WeatherData: Decodable {
    
}

protocol WeatherServicing {
    func search(city: String) -> Observable<WeatherData>
}

final class WeatherService: WeatherServicing {
    
    func search(city: String) -> Observable<WeatherData> {
        let api = Api(endpoint: WeatherEndpoint.search(city: "guarulhos"))
        return api.fireInTheHole()
    }
}
