import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelType {
    var searchCity: AnyObserver<String> { get }

    var cities: Driver<[City]> { get }
}

final class HomeViewModel: HomeViewModelType {
    //Inputs
    var searchCity: AnyObserver<String>
    
    //Outputs
    var cities: Driver<[City]>
    
    init(service: WeatherServicing) {
        let searchCityPublisher = PublishSubject<String>()
        
        let response = searchCityPublisher
            .flatMap(service.search)
            .share()
        
        cities = Observable.just([])
//            .map(\.name)
            .asDriver(onErrorJustReturn: [])

        searchCity = AnyObserver(searchCityPublisher)
    }
}
