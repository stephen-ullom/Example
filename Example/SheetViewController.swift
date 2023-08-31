//
//  Scroller.swift
//  Example
//
//  Created by Stephen Ullom on 8/17/23.
//

import UIKit

class SheetViewController: UIViewController {
  let sheetView = UIView()

  var sheetTopConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()

    let label = UILabel()

    view.addSubview(sheetView)

    sheetView.addSubview(label)
    sheetView.layer.cornerRadius = 24
    sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    sheetView.backgroundColor = .blue
    sheetView.translatesAutoresizingMaskIntoConstraints = false
    //    sheetView.isHidden = true

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    view.addGestureRecognizer(tapGesture)

    label.text = "Hello"
    label.translatesAutoresizingMaskIntoConstraints = false

    sheetTopConstraint = sheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -500)

    NSLayoutConstraint.activate([
      sheetTopConstraint,
      sheetView.leftAnchor.constraint(equalTo: view.leftAnchor),
      sheetView.rightAnchor.constraint(equalTo: view.rightAnchor),
      sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      label.centerYAnchor.constraint(equalTo: sheetView.centerYAnchor),
      label.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
    ])
  }

  @objc func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)
    
    if !sheetView.frame.contains(location) {
      dismissSheet()
    }
  }

  func presentSheet() {
    view.isHidden = false
    UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.8) {
      self.sheetTopConstraint.constant = -500
      self.view.layoutIfNeeded()
    }.startAnimation()
  }

  func dismissSheet() {
    let animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.8) {
      self.sheetTopConstraint.constant = 0
      self.view.layoutIfNeeded()
    }

    animator.addCompletion { _ in
      self.view.isHidden = true
    }

    animator.startAnimation()
  }
}
