//
//  ListView.swift
//  Example
//
//  Created by Stephen Ullom on 8/27/23.
//

import UIKit

class ListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemTeal

        // StackView
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        // Labels
        for i in 0..<24 {
            let label = UILabel()
            label.text = "Label \(i + 1)"
            label.textColor = .white
            stackView.addArrangedSubview(label)
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -20),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
