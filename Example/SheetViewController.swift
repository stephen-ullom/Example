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

  private var defaultHeight = 600.0

  override func viewDidLoad() {
    super.viewDidLoad()

    let listView = ListView()
    listView.view?.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(sheetView)

    sheetView.addSubview(listView.view)
    sheetView.layer.cornerRadius = 24
    sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    sheetView.backgroundColor = .blue
    sheetView.translatesAutoresizingMaskIntoConstraints = false
    //    sheetView.isHidden = true

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(sheetPanned(_:)))
    sheetView.addGestureRecognizer(panGesture)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    view.addGestureRecognizer(tapGesture)

    sheetTopConstraint = sheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -defaultHeight)

    NSLayoutConstraint.activate([
      sheetTopConstraint,
      sheetView.leftAnchor.constraint(equalTo: view.leftAnchor),
      sheetView.rightAnchor.constraint(equalTo: view.rightAnchor),
      sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      listView.view.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 48),
      listView.view.leftAnchor.constraint(equalTo: sheetView.leftAnchor),
      listView.view.rightAnchor.constraint(equalTo: sheetView.rightAnchor),
      listView.view.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor),
    ])
  }

  @objc func sheetPanned(_ gestureRecognizer: UIPanGestureRecognizer) {
    let translation = gestureRecognizer.translation(in: view)
    let height = defaultHeight - translation.y

    if gestureRecognizer.state == .changed {
      setSheetHeight(height: height)
    } else if gestureRecognizer.state == .ended {
      if height > 200 {
        UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
          self.setSheetHeight(height: self.defaultHeight)
        }.startAnimation()
      } else {
        dismissSheet()
      }
    }
  }

  @objc func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)

    if !sheetView.frame.contains(location) {
      dismissSheet()
    }
  }

  private func setSheetHeight(height: CGFloat) {
    let maxHeight = view.frame.height - view.safeAreaInsets.top
    if height > maxHeight {
      sheetTopConstraint.constant = -maxHeight
    } else if height > 0 {
      sheetTopConstraint.constant = -height
    } else {
      sheetTopConstraint.constant = 0
    }
    view.layoutIfNeeded()
  }

  public func presentSheet() {
    view.isHidden = false
    UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
//      self.sheetTopConstraint.constant = -self.defaultHeight
      self.setSheetHeight(height: self.defaultHeight)
//      self.view.layoutIfNeeded()
    }.startAnimation()
  }

  public func dismissSheet() {
    let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
//      self.sheetTopConstraint.constant = 0
//      self.view.layoutIfNeeded()
      self.setSheetHeight(height: 0)
    }

    animator.addCompletion { _ in
      self.view.isHidden = true
    }

    animator.startAnimation()
  }
}
