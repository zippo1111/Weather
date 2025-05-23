//
//  WeatherViewController.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import CoreLocation
import UIKit

final class WeatherViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, WeatherItem>!
    private var viewModelData: MainWeatherViewModel? {
        didSet {
            refreshCollection()
        }
    }
    private lazy var collectionView = WeatherCollectionView(frame: view.bounds, collectionViewLayout: LayoutProvider.createLayout())
    private let spinner = UIActivityIndicatorView()
    private let viewModel = WeatherViewModel()
    private let locationService = LocationService()
    private let userDefaultsService = UserDefaultsService.shared
    private let errorStackView = ErrorStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    private let titleLabel = NavigationLabel(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocation()
        setupViews()
        setupDataSource()

        Task {
            await loadData()
        }
    }

    private func setupLocation() {
        locationService.showAlertForSettingsCallback = { [weak self] in
            let alert = UIAlertController(
                title: Constants.LocationAlert.title,
                message: Constants.LocationAlert.message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: Constants.LocationAlert.toSettingsTitle, style: .default, handler: { _ in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }))
            alert.addAction(UIAlertAction(title: Constants.LocationAlert.cancelTitle, style: .cancel, handler: { [weak self] _ in
                self?.userDefaultsService.set(
                    LocationData(location: Constants.locationMoscow),
                    forKey: Constants.UserDefaults.defaultLocationKey
                )
            }))
            self?.present(alert, animated: true)
        }
        locationService.detectedLocationCallback = { [weak self] location in
            self?.userDefaultsService.set(
                LocationData(location: location),
                forKey: Constants.UserDefaults.defaultLocationKey
            )
        }
        locationService.requestLocationPermission()
    }

    private func setupNavigation(with title: String?) {
        titleLabel.text = title
        navigationItem.titleView = titleLabel
    }

    private func setupViews() {
        view.backgroundColor = .white

        spinner.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        spinner.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]

        errorStackView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        errorStackView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        errorStackView.isHidden = true
        errorStackView.reloadDidTapCallback = { [weak self] in
            self?.errorStackView.isHidden = true
            Task {
                await self?.loadData()
            }
        }

        view.addSubview(collectionView)
        view.addSubview(errorStackView)
        view.addSubview(spinner)
    }

    private func setupDataSource() {
        dataSource = DataSourceProvider.createDataSource(for: collectionView)
    }

    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherItem>()

        guard let horizontalItems = viewModelData?.hourlyViewmodel,
              let verticalItems = viewModelData?.dailyViewmodel
        else {
            return
        }

        let hourlyItems = horizontalItems.map {
            WeatherItem(hourlyModel: $0)
        }
        let dailyItems = verticalItems.map {
            WeatherItem(dailyModel: $0)
        }

        snapshot.appendSections([.horizontalItems])
        snapshot.appendItems(hourlyItems, toSection: .horizontalItems)

        snapshot.appendSections([.verticalItems])
        snapshot.appendItems(dailyItems, toSection: .verticalItems)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func loadData() async {
        spinner.startAnimating()

        guard let data = await viewModel.getViewModel(),
              let _ = data.titleViewmodel,
              let _ = data.hourlyViewmodel,
              let _ = data.dailyViewmodel
        else {
            await MainActor.run {
                if spinner.isAnimating {
                    spinner.stopAnimating()
                }
                errorStackView.isHidden = false
            }
            return
        }

        viewModelData = data
    }

    @objc
    private func refreshCollection() {
        setupNavigation(with: viewModelData?.titleViewmodel)
        applyInitialSnapshot()

        if spinner.isAnimating {
            spinner.stopAnimating()
        }
    }
}
