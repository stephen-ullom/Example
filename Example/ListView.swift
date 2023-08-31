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
    
    // View
    view.backgroundColor = .systemRed
    
    // ScrollView
    let scrollView = UIScrollView()
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    // StackView
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 24
    stackView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
      stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
      stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
    ])
    
    for i in 0 ..< 24 {
      let label = UILabel()
      label.text = "Label \(i + 1)"
      label.textColor = .white
      stackView.addArrangedSubview(label)
    }
  }
}
