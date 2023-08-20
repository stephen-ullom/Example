//
//  SheetController.swift
//  Example
//
//  Created by Stephen Ullom on 8/16/23.
//

import UIKit
import UIKit

class FirstPageController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGreen
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
    label.text = "Swipe right"
    label.textAlignment = .center
    view.addSubview(label)
  }
}

class SecondPageController: UIViewController {
  
  let scrollView = UIScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemRed
    scrollView.frame = view.bounds
    scrollView.isScrollEnabled = false
    scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(scrollView)
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    scrollView.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
    stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
    stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
    
    for i in 0..<20 {
      let label = UILabel()
      label.text = "Label \(i + 1)"
      label.textColor = .white
      label.textAlignment = .center
      stackView.addArrangedSubview(label)
      
      label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
  }
}

class Pager: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

  var pages: [UIViewController] = []
  
  let firstPage = FirstPageController()
  let secondPage = SecondPageController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    delegate = self
    
    pages = [firstPage, secondPage]
    
    if let firstViewController = pages.first {
      setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController), index > 0 else {
      return nil
    }
    return pages[index - 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
      return nil
    }
    return pages[index + 1]
  }
}
