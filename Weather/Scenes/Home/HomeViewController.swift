import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    private lazy var viewModel: HomeViewModelType = {
        return HomeViewModel(service: WeatherService())
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        bindViewModel()
        
        viewModel.searchCity.onNext("Guarulhos")
    }
    
    private func bindViewModel() {
        viewModel.city
            .drive(onNext: { city in
                print("city: \(city)")
            })
            .disposed(by: disposeBag)
        
        viewModel.temperature
            .drive(onNext: { temperature in
                print("temperature: \(temperature)")
            })
            .disposed(by: disposeBag)
    }
}

