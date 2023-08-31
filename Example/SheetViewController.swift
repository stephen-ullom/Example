//
//  Scroller.swift
//  Example
//
//  Created by Stephen Ullom on 8/17/23.
//

import UIKit

class SheetViewController: UIViewController, UIScrollViewDelegate {
  let sheetView = UIView()
  let listView = ListView()

  var sheetTopConstraint: NSLayoutConstraint!

  private var defaultHeight = 600.0

  override func viewDidLoad() {
    super.viewDidLoad()

    // View
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    view.addGestureRecognizer(tapGesture)

    // SheetView
    view.addSubview(sheetView)

    sheetTopConstraint = sheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -defaultHeight)

    let sheetViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(sheetPanned(_:)))
    sheetView.addGestureRecognizer(sheetViewPanGesture)

    //    sheetView.isHidden = true
    sheetView.layer.cornerRadius = 24
    sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    sheetView.backgroundColor = .blue
    sheetView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sheetTopConstraint,
      sheetView.leftAnchor.constraint(equalTo: view.leftAnchor),
      sheetView.rightAnchor.constraint(equalTo: view.rightAnchor),
      sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    // ListView
    sheetView.addSubview(listView.view)
    listView.view?.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      listView.view.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 48),
      listView.view.leftAnchor.constraint(equalTo: sheetView.leftAnchor),
      listView.view.rightAnchor.constraint(equalTo: sheetView.rightAnchor),
      listView.view.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor),
    ])

    // ScrollView
    let scrollView = listView.scrollView
    scrollView.delegate = self

    let scrollViewPanGesture = scrollView.panGestureRecognizer
    scrollViewPanGesture.addTarget(self, action: #selector(scrollViewPanned(_:)))
  }

  @objc func scrollViewPanned(_ gestureRecognizer: UIPanGestureRecognizer) {
    let translation = gestureRecognizer.translation(in: view)

    if gestureRecognizer.state == .changed {
      if translation.y > 0 && listView.scrollView.contentOffset.y < 0 {
        setSheetHeight(height: defaultHeight - translation.y)
      }
    } else if gestureRecognizer.state == .ended {
      UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
        self.setSheetHeight(height: self.defaultHeight)
      }.startAnimation()
    }
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
      self.setSheetHeight(height: self.defaultHeight)
    }.startAnimation()
  }

  public func dismissSheet() {
    let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
      self.setSheetHeight(height: 0)
    }

    animator.addCompletion { _ in
      self.view.isHidden = true
    }

    animator.startAnimation()
  }
}
