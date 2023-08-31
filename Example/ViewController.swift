//
//  ViewController.swift
//  Example
//
//  Created by Stephen Ullom on 8/16/23.
//

import UIKit

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate, ScrollingPageDelegate {
  let scrollerView = Scroller()
  let pagerView = Pager(transitionStyle: .scroll, navigationOrientation: .horizontal)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    let button1 = UIButton(type: .system)
    button1.configuration = .filled()
    button1.setTitle("Scroll Sheet", for: .normal)
    button1.addTarget(self, action: #selector(openScroller), for: .touchUpInside)
    
    let button2 = UIButton(type: .system)
    button2.configuration = .filled()
    button2.tintColor = .systemRed
    button2.setTitle("Page Sheet", for: .normal)
    button2.addTarget(self, action: #selector(openPager), for: .touchUpInside)
    
    view.addSubview(button1)
    view.addSubview(button2)
    
    button1.translatesAutoresizingMaskIntoConstraints = false
    button2.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
      button2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32)
    ])
  }
  
  // MARK: Scroller
  
  @objc func openScroller() {
    if let sheet = scrollerView.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
//      sheet.detents = [.custom(resolver: { context in
//        return 600
//      })]
      sheet.prefersGrabberVisible = true
    }
    present(scrollerView, animated: true, completion: nil)
  }
  
  func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
    if sheetPresentationController.selectedDetentIdentifier == .large {
      print("Large")
      pagerView.scrollingPage.scrollView.isScrollEnabled = true
    } else {
      pagerView.scrollingPage.scrollView.isScrollEnabled = false
    }
  }
  
  func scrollingPageDidScroll(gestureRecognizer: UIPanGestureRecognizer) {
//    print("offset", offset)
    
//    if let sheet = pagerView.presentationController {
////      sheet.offsetFromBottom = offset
//
//    }
    
    
    guard let presentedView = gestureRecognizer.view else { return }
    
    let translation = gestureRecognizer.translation(in: presentedView.superview)
    gestureRecognizer.setTranslation(.zero, in: presentedView.superview)
    
    var frame = presentedView.frame
    frame.origin.y += translation.y
    presentedView.frame = frame
    
    if gestureRecognizer.state == .ended {
      // Handle gesture ending, e.g., dismiss if dragged down beyond a threshold
    }
  }
  
  // MARK: Pager
  
  @objc func openPager() {
    if let sheet = pagerView.sheetPresentationController {
      pagerView.scrollingPage.delegate = self
//      sheet.detents = [.medium(), .large()]
      sheet.detents = [.custom { _ in 500 }, .large()]
      sheet.prefersGrabberVisible = true
    }
    present(pagerView, animated: true, completion: nil)
    
//    pagerView.modalPresentationStyle = .pageSheet
//    pagerView.presentationController?.delegate = self
//    pagerView.modalPresentationStyle = .currentContext
//    present(pagerView, animated: true, completion: nil)
  }
  
//  // UIAdaptivePresentationControllerDelegate method
//  func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
//    // Return true to allow dismissal via swipe gesture
//    return true
//  }
}
