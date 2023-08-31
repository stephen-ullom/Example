//
//  ViewController.swift
//  Example
//
//  Created by Stephen Ullom on 8/16/23.
//

import UIKit

class ViewController: UIViewController {
  let sheetView = SheetViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let button = UIButton(type: .system)
    
    view.backgroundColor = .systemBackground
    view.addSubview(button)
    view.addSubview(sheetView.view)
    
    button.configuration = .filled()
    button.setTitle("Open Sheet", for: .normal)
    button.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
  
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
  
  @objc func openSheet() {
    sheetView.presentSheet()
  }
}
