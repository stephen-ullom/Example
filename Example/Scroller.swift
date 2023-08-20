//
//  Scroller.swift
//  Example
//
//  Created by Stephen Ullom on 8/17/23.
//

import UIKit

class Scroller: UIViewController {
  
  let scrollView = UIScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBlue

    scrollView.frame = view.bounds
    scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    scrollView.isScrollEnabled = false
    view.addSubview(scrollView)
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    scrollView.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
    stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
    stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
    
    for i in 0..<20 {
      let label = UILabel()
      label.text = "Label \(i + 1)"
      label.textColor = .white
      label.textAlignment = .center
      stackView.addArrangedSubview(label)
      
      label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
  }
  
  func changeToLargeDetent() {
    print("Hello")
  }
}
