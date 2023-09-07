//
//  ListView.swift
//  Example
//
//  Created by Stephen Ullom on 8/27/23.
//

import UIKit

class ListView: UIViewController {
  let scrollView = UIScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // View
    view.backgroundColor = .systemMint
    
    // ScrollView
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .systemCyan
    
    // StackView
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.backgroundColor = .systemPink
    stackView.spacing = 24
    stackView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
      stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
      stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
    ])
    
    // Labels
    for i in 0 ..< 24 {
      let label = UILabel()
      label.text = "Label \(i + 1)"
      label.textColor = .white
      stackView.addArrangedSubview(label)
    }
  }
}
