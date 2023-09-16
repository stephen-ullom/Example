//
//  Scroller.swift
//  Example
//
//  Created by Stephen Ullom on 8/17/23.
//

import UIKit

class SheetViewController: UIViewController, UIScrollViewDelegate {
  let sheetView = UIView()
  let scrollView = UIScrollView()

  var safeAreaInsets: UIEdgeInsets?
  var mediumDetent: CGFloat = 500

  private var sheetViewBottomConstraint: NSLayoutConstraint!
  private var bottomPadding: CGFloat = 32
  private var sheetIsDragging = false
  private var sheetIsLocked = false

  private var sheetTop: CGFloat {
    get {
      return view.frame.height - sheetViewBottomConstraint.constant + bottomPadding
    }

    set(top) {
      let maxHeight = view.frame.height

      if top > maxHeight {
        sheetViewBottomConstraint.constant = bottomPadding
      } else {
        sheetViewBottomConstraint.constant = maxHeight - top + bottomPadding
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // View
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    view.addGestureRecognizer(tapGesture)
    view.isHidden = true
    view.addSubview(sheetView)

    // SheetView
    sheetViewBottomConstraint = sheetView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: mediumDetent)
    sheetView.layer.cornerRadius = 24
    sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    sheetView.backgroundColor = .systemBlue
    sheetView.translatesAutoresizingMaskIntoConstraints = false

    // ScrollView
    scrollView.delegate = self
    scrollView.showsVerticalScrollIndicator = false
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    sheetView.addSubview(scrollView)

    // ListView
    let listView = ListView()
    listView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(listView)

    NSLayoutConstraint.activate([
      sheetView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: bottomPadding),
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

  override func viewSafeAreaInsetsDidChange() {
    let bottomInset = view.safeAreaInsets.bottom
    scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    scrollView.contentInset.bottom = bottomInset + bottomPadding
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrollOffset = scrollView.contentOffset.y
    let maxHeight = view.frame.height

    var newOffset = sheetTop + scrollOffset
    var animate = false

    if scrollOffset < 0 {
      // Move down
      scrollView.contentOffset.y = 0
      if sheetIsDragging {
        animate = true
        scrollView.showsVerticalScrollIndicator = false
      }
    } else if scrollOffset > 0 {
      // Move up
      if newOffset > maxHeight {
        newOffset = maxHeight
        scrollView.showsVerticalScrollIndicator = true
      } else {
        scrollView.contentOffset.y = 0
      }
      if sheetIsDragging {
        animate = true
      }
    }

    if animate {
      UIView.animate(withDuration: 0, delay: 0, options: [.allowUserInteraction], animations: {
        self.sheetTop = newOffset
        self.view.layoutIfNeeded()
      })
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

    let scrollVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
    let scrollOffset = scrollView.contentOffset.y

    let resistance: CGFloat = 7
    let targetPosition = sheetTop + scrollOffset - (scrollVelocity / resistance)

    let closestLocation = closestToTarget([frameHeight, mediumDetent, 0], target: targetPosition)

    let isMaxHeight = sheetViewBottomConstraint.constant == bottomPadding
    let shouldSnapToMax = closestLocation == frameHeight

    if closestLocation == 0 {
      dismissSheet(velocity: scrollVelocity / 100)
    } else {
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
          self.sheetTop = closestLocation
          self.view.layoutIfNeeded()
        })
    }
  }

  @objc func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)

    if !sheetView.frame.contains(location) {
      dismissSheet()
    }
  }

  public func presentSheet() {
    view.isHidden = false
    UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7) {
      self.sheetTop = self.mediumDetent
      self.view.layoutIfNeeded()
    }.startAnimation()
  }

  public func dismissSheet(velocity: Double = 0) {
    let initialVelocity = CGVector(dx: 0, dy: velocity)
    let timingParameters = UISpringTimingParameters(dampingRatio: 1, initialVelocity: initialVelocity)

    let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: timingParameters)
    animator.addAnimations {
      self.sheetTop = 0
      self.view.layoutIfNeeded()
    }
    animator.addCompletion { _ in
      self.view.isHidden = true
    }
    animator.startAnimation()
  }
}
