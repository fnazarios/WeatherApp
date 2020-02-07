import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol HomeViewModelType {
    var searchCity: AnyObserver<String?> { get }

    var cities: Driver<[City]> { get }
}

final class HomeViewModel: HomeViewModelType {
    //Inputs
    var searchCity: AnyObserver<String?>
    
    //Outputs
    var cities: Driver<[City]>
    
    init(service: WeatherServicing) {
        let searchCityPublisher = PublishSubject<String?>()
        
        cities = searchCityPublisher
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .flatMapLatest(HomeViewModel.reverseGeocoder)
            .debug()
            .map { SearchParams(lat: $0.latitude, lon: $0.longitude, cnt: 10) }
            .flatMapLatest(service.search)
            .map { $0.list }
            .asDriver(onErrorJustReturn: [])

        searchCity = AnyObserver(searchCityPublisher)
    }
    
    private static func reverseGeocoder(with city: String) -> Observable<CLLocationCoordinate2D> {
        let geocoder = CLGeocoder()
        return Observable.create { observer in
            geocoder.geocodeAddressString(city) { placemarks, error in
                guard let coordinate = placemarks?.first?.location?.coordinate else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                observer.onNext(coordinate)
            }
            
            return Disposables.create()
        }
    }
}

enum ReverseGeocoderError: Error {
    case notFound
}
