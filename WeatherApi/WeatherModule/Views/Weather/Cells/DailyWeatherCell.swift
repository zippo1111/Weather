//
//  DailyWeatherCell.swift
//  WeatherApi
//
//  Created by Mangust on 19.05.2025.
//

import UIKit

final class DailyWeatherCell: UICollectionViewCell {
    var id: Int?

    private var viewModel: DailyWeatherViewModel?
    private var row: Int = 0

    private let icon: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    private var day: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    private let minTemperature: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        return label
    }()
    private let delimiter: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.text = " - "
        return label
    }()
    private let maxTemperature: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        return label
    }()
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: DailyWeatherViewModel?, row: Int) throws {
        guard let viewModel = viewModel else {
            return
        }

        self.viewModel = viewModel
        self.row = row

        do {
            try setupData(viewModel)
        } catch {
            throw error
        }

        configureConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        icon.image = nil
    }

    private func setupView() {
        contentView.addSubview(horizontalStackView)

        horizontalStackView.addArrangedSubview(day)
        horizontalStackView.addArrangedSubview(icon)
        horizontalStackView.addArrangedSubview(minTemperature)
        horizontalStackView.addArrangedSubview(delimiter)
        horizontalStackView.addArrangedSubview(maxTemperature)
    }

    private func configureConstraints() {
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }

    private func setupData(_ viewModelData: DailyWeatherViewModel) throws {
        viewModel = viewModelData

        day.text = viewModelData.day
        minTemperature.text = "\(viewModelData.temperatureMin ?? "")\(Constants.celcium)"
        maxTemperature.text = "\(viewModelData.temperatureMax ?? "")\(Constants.celcium)"
        icon.image = viewModelData.conditionIcon
    }
}
