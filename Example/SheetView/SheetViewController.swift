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
  var sheetViewBottomConstraint: NSLayoutConstraint!
  let scrollView = UIScrollView()

  private var mediumDetent: CGFloat = 500

  var sheetIsDragging = false
  var sheetIsLocked = false

  override func viewDidLoad() {
    super.viewDidLoad()

    // View
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    view.addGestureRecognizer(tapGesture)
    view.isHidden = true
    view.addSubview(sheetView)

    // SheetView
    sheetViewBottomConstraint = sheetView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: mediumDetent)
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
      sheetView.heightAnchor.constraint(equalTo: view.heightAnchor),
      sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      sheetViewBottomConstraint,

      scrollView.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 80),
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
    let scrollOffset = scrollView.contentOffset.y
    let maxHeight = view.frame.height
    let top = maxHeight - sheetViewBottomConstraint.constant

    var newOffset = top + scrollOffset

    if scrollOffset < 0 {
      // Move down
      scrollView.contentOffset.y = 0
      if sheetIsDragging {
        UIView.animate(withDuration: 0, delay: 0, options: [.allowUserInteraction], animations: {
          self.setSheetTop(newOffset)
          self.view.layoutIfNeeded()
        })
      }
    } else if scrollOffset > 0 {
      // Move up
      if newOffset > maxHeight {
        newOffset = maxHeight
      } else {
        scrollView.contentOffset.y = 0
      }
      if sheetIsDragging {
        UIView.animate(withDuration: 0, delay: 0, options: [.allowUserInteraction], animations: {
          self.setSheetTop(newOffset)
          self.view.layoutIfNeeded()
        })
      }
    }

    if sheetIsLocked {
      scrollView.contentOffset.y = 0
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    sheetIsDragging = false
    snapToDetents(willDecelerate: decelerate)
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    sheetIsLocked = false
    sheetIsDragging = true
  }

  func snapToDetents(willDecelerate decelerate: Bool) {
    let frameHeight = view.frame.height
    let sheetTop = frameHeight - sheetViewBottomConstraint.constant

    let scrollVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
    let scrollOffset = scrollView.contentOffset.y

    let resistance: CGFloat = 7
    let targetPosition = sheetTop + scrollOffset - (scrollVelocity / resistance)

    let closestLocation = closestToTarget([frameHeight, mediumDetent, 0], target: targetPosition)

    let isMaxHeight = sheetViewBottomConstraint.constant == 0
    let shouldSnapToMax = closestLocation == frameHeight

    if decelerate && shouldSnapToMax && !isMaxHeight {
      sheetIsLocked = true
    }

    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: (scrollVelocity / resistance) / frameHeight,
      options: [.allowUserInteraction],
      animations: {
        self.setSheetTop(closestLocation)
        self.view.layoutIfNeeded()
      })
  }

  @objc func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)

    if !sheetView.frame.contains(location) {
      dismissSheet()
    }
  }

  private func setSheetTop(_ top: CGFloat) {
    let maxHeight = view.frame.height

    if top > maxHeight {
      sheetViewBottomConstraint.constant = 0
    } else {
      sheetViewBottomConstraint.constant = maxHeight - top
    }
  }

  public func presentSheet() {
    view.isHidden = false
    UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7) {
      self.setSheetTop(self.mediumDetent)
      self.view.layoutIfNeeded()
    }.startAnimation()
  }

  public func dismissSheet() {
    let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
      self.setSheetTop(0)
      self.view.layoutIfNeeded()
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
