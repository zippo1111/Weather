//
//  NavigationLabel.swift
//  WeatherApi
//
//  Created by Mangust on 22.05.2025.
//

import UIKit

final class NavigationLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        numberOfLines = 2
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 17, weight: .bold)
        textColor = .black
        sizeToFit()
    }
}
