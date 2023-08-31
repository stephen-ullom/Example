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

  var defaultHeight = 600.0

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

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(sheetPanned(_:)))
    sheetView.addGestureRecognizer(panGesture)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    view.addGestureRecognizer(tapGesture)

    label.text = "Hello"
    label.translatesAutoresizingMaskIntoConstraints = false

    sheetTopConstraint = sheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -defaultHeight)

    NSLayoutConstraint.activate([
      sheetTopConstraint,
      sheetView.leftAnchor.constraint(equalTo: view.leftAnchor),
      sheetView.rightAnchor.constraint(equalTo: view.rightAnchor),
      sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      label.centerYAnchor.constraint(equalTo: sheetView.centerYAnchor),
      label.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
    ])
  }

  @objc func sheetPanned(_ gestureRecognizer: UIPanGestureRecognizer) {
    if gestureRecognizer.state == .changed {
      let translation = gestureRecognizer.translation(in: view)
      sheetTopConstraint.constant = -defaultHeight + translation.y
    } else if gestureRecognizer.state == .ended {
      UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
        self.sheetTopConstraint.constant = -self.defaultHeight
        self.view.layoutIfNeeded()
      }.startAnimation()
    }
  }

  @objc func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)

    if !sheetView.frame.contains(location) {
      dismissSheet()
    }
  }

  func presentSheet() {
    view.isHidden = false
    UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
      self.sheetTopConstraint.constant = -self.defaultHeight
      self.view.layoutIfNeeded()
    }.startAnimation()
  }

  func dismissSheet() {
    let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
      self.sheetTopConstraint.constant = 0
      self.view.layoutIfNeeded()
    }

    animator.addCompletion { _ in
      self.view.isHidden = true
    }

    animator.startAnimation()
  }
}
