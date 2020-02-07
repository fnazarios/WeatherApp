import Foundation
import RxSwift

protocol WeatherServicing {
    func search(_ params: SearchParams) -> Observable<WeatherData>
}

final class WeatherService: WeatherServicing {
    func search(_ params: SearchParams) -> Observable<WeatherData> {
        let api = Api(endpoint: WeatherEndpoint.search(city: params))
        return api.fireInTheHole()
            .map { data -> WeatherData in
                try JSONDecoder().decode(WeatherData.self, from: data)
            }
    }
}
