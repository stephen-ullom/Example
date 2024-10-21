//
//  ViewController.swift
//  Example
//
//  Created by Stephen Ullom on 8/16/23.
//

import UIKit

class ViewController: UIViewController {
  var sheetView: SheetViewController!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Button
    let button = UIButton(type: .system)
    button.configuration = .filled()
    button.setTitle("Open Sheet", for: .normal)
    button.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    
    // Label
    let label = UILabel()
    label.text = "Hello World"
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)

    // SheetView
    sheetView = SheetViewController()
    sheetView.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(sheetView.view)

    // View
    view.backgroundColor = .systemBackground

    NSLayoutConstraint.activate([
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      label.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100),
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      sheetView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      sheetView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      sheetView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      sheetView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  @objc func openSheet() {
    sheetView.presentSheet()
  }
}
