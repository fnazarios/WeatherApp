import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelType {
    var searchCity: AnyObserver<String> { get }

    var city: Driver<String> { get }
    var temperature: Driver<String> { get }
}


final class HomeViewModel: HomeViewModelType {
    //Inputs
    var searchCity: AnyObserver<String>
    
    //Outputs
    var city: Driver<String>
    var temperature: Driver<String>
    
    init(service: WeatherServicing) {
        let searchCityPublisher = PublishSubject<String>()
        
        let response = searchCityPublisher
            .flatMap(service.search)
            .share()
        
        city = response
            .map(\.name)
            .asDriver(onErrorJustReturn: "deu ruim")
            
        temperature = response
            .map(\.main.temp.description)
            .asDriver(onErrorJustReturn: "deu ruim")

        
        searchCity = AnyObserver(searchCityPublisher)
    }
}
