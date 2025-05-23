//
//  DataSourceProvider.swift
//  MainCollectionWithInnerCollections
//
//  Created by Mangust on 20.05.2025.
//

import UIKit

final class DataSourceProvider {
    static private let viewModel = WeatherViewModel()
    static func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, WeatherItem> {
        UICollectionViewDiffableDataSource<Section, WeatherItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch(item) {
            case .hourly(id: _, model: let model):
                let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath) as? HourlyWeatherCell

                do {
                    try hourCell?.configure(viewModel: model, row: indexPath.row)
                } catch {
                    return nil
                }
                return hourCell
            case .daily(id: _, model: let model):
                let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyWeatherCell", for: indexPath) as? DailyWeatherCell

                do {
                    try dayCell?.configure(viewModel: model, row: indexPath.row)
                } catch {
                    return nil
                }
                return dayCell
            }
        }
    }
}
