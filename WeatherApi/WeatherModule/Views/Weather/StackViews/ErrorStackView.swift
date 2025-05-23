//
//  ErrorStackView.swift
//  WeatherApi
//
//  Created by Mangust on 22.05.2025.
//

import UIKit

final class ErrorStackView: UIStackView {
    var reloadDidTapCallback: (() -> Void)?
    private var warning: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.text = "Something went wrong"
        return label
    }()
    private lazy var reloadButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        btn.addTarget(self, action: #selector(reload), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupSubviews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        axis = .vertical
        spacing = 4
        alignment = .fill
        distribution = .fill
    }

    func setupSubviews() {
        addArrangedSubview(warning)
        addArrangedSubview(reloadButton)
    }

    @objc
    func reload() {
        reloadDidTapCallback?()
    }
}
