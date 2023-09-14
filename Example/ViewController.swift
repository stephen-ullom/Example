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

    // Button
    let button = UIButton(type: .system)
    button.configuration = .filled()
    button.setTitle("Open Sheet", for: .normal)
    button.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false

    // SheetView
    sheetView.view.translatesAutoresizingMaskIntoConstraints = false

    // View
    view.addSubview(button)
    view.addSubview(sheetView.view)
    view.backgroundColor = .systemBackground

    NSLayoutConstraint.activate([
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),

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
