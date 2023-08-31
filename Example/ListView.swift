//
//  PagerScrollView.swift
//  Example
//
//  Created by Stephen Ullom on 8/27/23.
//

import UIKit

class ListView: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let stackView = UIStackView()
    
    view.backgroundColor = .systemRed
    view.addSubview(stackView)
    
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
    ])
    
    for i in 0 ..< 20 {
      let label = UILabel()
      label.text = "Label \(i + 1)"
      label.textColor = .white
      label.textAlignment = .center
      stackView.addArrangedSubview(label)
      
      label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
  }
}
