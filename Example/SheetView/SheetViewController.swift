//
//  Scroller.swift
//  Example
//
//  Created by Stephen Ullom on 8/17/23.
//

import UIKit

class SheetViewController: UIViewController, UIScrollViewDelegate {
  let sheetView = UIView()
  var sheetViewTopConstraint: NSLayoutConstraint!

  let scrollView = UIScrollView()

  private var closeHeight = 100.0

  private var panStartPosition = 0.0
  private var scrollStartPosition = 0.0

  override func viewDidLoad() {
    super.viewDidLoad()

    // View
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    view.addGestureRecognizer(tapGesture)
    view.isHidden = true
    view.addSubview(sheetView)

    // SheetView

    sheetViewTopConstraint = sheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)

//    let sheetViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(sheetPanned(_:)))
//    sheetView.addGestureRecognizer(sheetViewPanGesture)

    // sheetView.isHidden = true
    sheetView.layer.cornerRadius = 24
    sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    sheetView.backgroundColor = .systemBlue
    sheetView.translatesAutoresizingMaskIntoConstraints = false

    // ScrollView

    scrollView.delegate = self

//    let scrollViewPanGesture = scrollView.panGestureRecognizer
//    scrollViewPanGesture.addTarget(self, action: #selector(scrollViewPanned(_:)))

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
      sheetViewTopConstraint.constant = -newOffset
      scrollView.contentOffset.y = 0
    } else if yOffset > 0 {
      // Move up
      if (newOffset > maxHeight) {
        newOffset = maxHeight
      } else {
        scrollView.contentOffset.y = 0
      }
      sheetViewTopConstraint.constant = -newOffset
    }
  }

//  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//    if gestureRecognizer == listView.scrollView.panGestureRecognizer {
//      return shouldAllowScrolling()
//    }
//    return true
//  }

//  func shouldAllowScrolling() -> Bool {
//    let maxHeight = view.frame.height
//    let currentHeight = sheetView.frame.height
//
//    return currentHeight == maxHeight
//  }

  @objc func scrollViewPanned(_ gestureRecognizer: UIPanGestureRecognizer) {
    let translation = gestureRecognizer.translation(in: view)
    let maxHeight = view.frame.height
    let currentHeight = sheetView.frame.height
    let scrollOffset = scrollView.contentOffset.y

    if gestureRecognizer.state == .began {
      panStartPosition = currentHeight
      scrollStartPosition = scrollOffset
    } else if gestureRecognizer.state == .changed {
      // Move sheet
//      if translation.y > 0 {
//        // Scrolling down
//        if scrollOffset <= 0 {
//          setSheetHeight(height: panStartPosition - translation.y + scrollStartPosition)
//        }
//      } else {
//        // Scrolling up
//        if currentHeight < maxHeight {
//          scrollView.contentOffset.y = 0
//        }
//        setSheetHeight(height: panStartPosition - translation.y)
//      }
    } else if gestureRecognizer.state == .ended {
      UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.8) {
//        let closestPosition = closestToTarget([maxHeight, self.defaultHeight, self.closeHeight], target: currentHeight)
//        if closestPosition == self.closeHeight {
//          self.dismissSheet()
//        } else {
//          self.setSheetHeight(height: closestPosition)
//        }
        self.setSheetHeight(height: maxHeight)
      }.startAnimation()
    }
  }

//  @objc func sheetPanned(_ gestureRecognizer: UIPanGestureRecognizer) {
//    let translation = gestureRecognizer.translation(in: view)
//    let height = defaultHeight - translation.y
//
//    if gestureRecognizer.state == .changed {
//      setSheetHeight(height: height)
//    } else if gestureRecognizer.state == .ended {
//      if height > 200 {
//        UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.8) {
//          self.setSheetHeight(height: self.defaultHeight)
//        }.startAnimation()
//      } else {
//        dismissSheet()
//      }
//    }
//  }

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
      self.setSheetHeight(height: self.view.frame.height)
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
