import Foundation
import RxSwift

protocol WeatherServicing {
    func search(_ city: String) -> Observable<WeatherData>
}

final class WeatherService: WeatherServicing {
    
    func search(_ city: String) -> Observable<WeatherData> {
        let api = Api(endpoint: WeatherEndpoint.search(city: "guarulhos"))
        return api.fireInTheHole()
            .map { data -> WeatherData in
                try JSONDecoder().decode(WeatherData.self, from: data)
            }
    }
}
