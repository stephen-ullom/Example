//
//  Scroller.swift
//  Example
//
//  Created by Stephen Ullom on 8/17/23.
//

import UIKit

// enum SheetState {
//  case dragging
//  case
// }

class SheetViewController: UIViewController, UIScrollViewDelegate {
  let sheetView = UIView()
  var sheetViewTopConstraint: NSLayoutConstraint!

  let scrollView = UIScrollView()

  private var mediumDetent: CGFloat = 500

  private var panStartPosition: CGFloat = 0
  private var scrollStartPosition: CGFloat = 0

  var sheetIsDragging = false

  override func viewDidLoad() {
    super.viewDidLoad()

    // View
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    view.addGestureRecognizer(tapGesture)
    view.isHidden = true
    view.addSubview(sheetView)

    // SheetView
    sheetViewTopConstraint = sheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
    // sheetView.isHidden = true
    sheetView.layer.cornerRadius = 24
    sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    sheetView.backgroundColor = .systemBlue
    sheetView.translatesAutoresizingMaskIntoConstraints = false

    // ScrollView
    scrollView.delegate = self
    scrollView.translatesAutoresizingMaskIntoConstraints = false

    sheetView.addSubview(scrollView)

    // ListView
    let listView = ListView()
    listView.translatesAutoresizingMaskIntoConstraints = false

    scrollView.addSubview(listView)

    NSLayoutConstraint.activate([
      sheetViewTopConstraint,
      sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      scrollView.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 48),
      scrollView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor),

      listView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      listView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      listView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      listView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      listView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    ])
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let yOffset = scrollView.contentOffset.y
    let maxHeight = view.frame.height
    let sheetViewHeight = sheetView.frame.height

    var newOffset = sheetViewHeight + yOffset

    if yOffset < 0 {
      // Move down
      scrollView.contentOffset.y = 0
      if sheetIsDragging {
        UIView.animate(withDuration: 0, delay: 0, options: [.allowUserInteraction], animations: {
          self.sheetViewTopConstraint.constant = -newOffset
          self.view.layoutIfNeeded()
        })
      }
    } else if yOffset > 0 {
      // Move up
      if newOffset > maxHeight {
        newOffset = maxHeight
      } else {
        scrollView.contentOffset.y = 0
      }
      if sheetIsDragging {
        UIView.animate(withDuration: 0, delay: 0, options: [.allowUserInteraction], animations: {
          self.sheetViewTopConstraint.constant = -newOffset
          self.view.layoutIfNeeded()
        })
      }
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    sheetIsDragging = false
    snapToDetents()
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    sheetIsDragging = true
  }

  func snapToDetents() {
    let frameHeight = view.frame.height
    let sheetViewHeight = sheetView.frame.height

    let scrollVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
    let scrollOffset = scrollView.contentOffset.y

    let resistance: CGFloat = 4
    let targetPosition = sheetViewHeight + scrollOffset - (scrollVelocity / resistance)

    let closestLocation = closestToTarget([frameHeight, mediumDetent, 0], target: targetPosition)

    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: (scrollVelocity / resistance) / frameHeight,
      options: [.allowUserInteraction],
      animations: {
        self.sheetViewTopConstraint.constant = -closestLocation
        self.view.layoutIfNeeded()
      })
  }

  @objc func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)

    if !sheetView.frame.contains(location) {
      dismissSheet()
    }
  }

  private func setSheetHeight(height: CGFloat) {
    let maxHeight = view.frame.height
    if height > maxHeight {
      sheetViewTopConstraint.constant = -maxHeight
    } else if height > 0 {
      sheetViewTopConstraint.constant = -height
    } else {
      sheetViewTopConstraint.constant = 0
    }
    view.layoutIfNeeded()
  }

  public func presentSheet() {
    view.isHidden = false
    UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
      self.setSheetHeight(height: self.mediumDetent)
    }.startAnimation()
  }

  public func dismissSheet() {
    let animator = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.8) {
      self.setSheetHeight(height: 0)
    }

    animator.addCompletion { _ in
      self.view.isHidden = true
    }

    animator.startAnimation()
  }
}

func closestToTarget(_ numbers: [Double], target: Double) -> Double {
  var closestNumber: Double = numbers[0]
  var closestDifference: Double = abs(numbers[0] - target)

  for number in numbers {
    let difference = abs(number - target)
    if difference < closestDifference {
      closestNumber = number
      closestDifference = difference
    }
  }

  return closestNumber
}
