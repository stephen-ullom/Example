//
//  PagerScrollView.swift
//  Example
//
//  Created by Stephen Ullom on 8/27/23.
//

import UIKit

protocol ScrollingPageDelegate: AnyObject {
  func scrollingPageDidScroll(gestureRecognizer: UIPanGestureRecognizer)
}

class ScrollingPage: UIViewController {
  
  weak var delegate: ScrollingPageDelegate?
  
  let scrollView = UIScrollView()
  
  var initialContentOffset: CGPoint = .zero
  var isDraggingScrollView = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.frame = view.bounds
    scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    view.backgroundColor = .systemRed
    view.addSubview(scrollView)
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    scrollView.addSubview(stackView)
    scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan))
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
    stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
    stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
    
    for i in 0 ..< 20 {
      let label = UILabel()
      label.text = "Label \(i + 1)"
      label.textColor = .white
      label.textAlignment = .center
      stackView.addArrangedSubview(label)
      
      label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
  }
  
  @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
    
    delegate?.scrollingPageDidScroll(gestureRecognizer: recognizer)
//    let deltaY = recognizer.translation(in: view).y
//    
//    switch recognizer.state {
//    case .possible:
//      break
//    case .began:
//      break
//    case .changed:
////      print(deltaY)
//    case .ended, .cancelled, .failed:
//      break
//      
//    @unknown default:
//      break
//    }
  }
}
