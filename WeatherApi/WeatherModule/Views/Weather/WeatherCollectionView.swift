//
//  WeatherCollectionView.swift
//  WeatherApi
//
//  Created by Mangust on 19.05.2025.
//

import UIKit

final class WeatherCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        register(HourlyWeatherCell.self, forCellWithReuseIdentifier: "HourlyWeatherCell")
        register(DailyWeatherCell.self, forCellWithReuseIdentifier: "DailyWeatherCell")
        register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
    }
}
