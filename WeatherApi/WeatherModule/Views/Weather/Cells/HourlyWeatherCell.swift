//
//  HourlyWeatherCell.swift
//  WeatherApi
//
//  Created by Mangust on 19.05.2025.
//

import SnapKit
import UIKit

final class HourlyWeatherCell: UICollectionViewCell {
    var id: Int?

    private var viewModel: HourlyWeatherViewModel?
    private var row: Int = 0

    private let icon: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    private var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    private let boldLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    private let spinner = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: HourlyWeatherViewModel?, row: Int) throws {
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
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(icon)
        stackView.addArrangedSubview(boldLabel)

        icon.addSubview(spinner)
    }

    private func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupData(_ viewModelData: HourlyWeatherViewModel) throws {
        viewModel = viewModelData

        label.text = viewModelData.hour
        boldLabel.text = "\(viewModelData.temperature ?? "")\(Constants.celcium)"

        showSpinnerInImage()

        guard let url = URL(string: "https://\(String(viewModelData.conditionIcon.dropFirst(2)))") else {
            throw NetworkError.invalidURL
        }

        Task {
            do {
                try await icon.loadImage(from: url)
                await MainActor.run {
                    hideSpinnerInImage()
                }
            } catch {
                throw error
            }
        }
    }

    private func showSpinnerInImage() {
        spinner.startAnimating()
    }

    private func hideSpinnerInImage() {
        if spinner.isAnimating {
            spinner.stopAnimating()
        }
    }
}
