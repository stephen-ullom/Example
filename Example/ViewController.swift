//
//  ViewController.swift
//  Example
//
//  Created by Stephen Ullom on 8/16/23.
//

import UIKit

class ViewController: UIViewController, UISheetPresentationControllerDelegate {
  
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
//      sheet.delegate = self
      sheet.detents = [.medium(), .large()]
      sheet.prefersGrabberVisible = true
    }
    present(scrollerView, animated: true, completion: nil)
  }
  
  func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
    if sheetPresentationController.selectedDetentIdentifier == .large {
      print("Large")
      pagerView.secondPage.scrollView.isScrollEnabled = true
    } else {
      pagerView.secondPage.scrollView.isScrollEnabled = false
    }
  }
  
  // MARK: Pager
  
  @objc func openPager() {
    if let sheet = pagerView.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
      sheet.delegate = self
      sheet.prefersGrabberVisible = true
    }
    present(pagerView, animated: true, completion: nil)
  }
  
}

