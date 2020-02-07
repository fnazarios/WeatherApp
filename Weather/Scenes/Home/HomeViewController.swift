import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var viewModel: HomeViewModelType = {
        return HomeViewModel(service: WeatherService())
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        bindViewModel()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configureViews() {
        title = "Weather"
        navigationItem.titleView = searchBar
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

