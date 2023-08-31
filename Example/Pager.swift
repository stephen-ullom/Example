//
//  SheetController.swift
//  Example
//
//  Created by Stephen Ullom on 8/16/23.
//

import UIKit

class StaticPage: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGreen
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
    label.text = "Swipe right"
    label.textAlignment = .center
    view.addSubview(label)
  }
}

class Pager: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  var pages: [UIViewController] = []
  
  let scrollingPage = ScrollingPage()
  let staticPage = StaticPage()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    delegate = self
    
    pages = [scrollingPage, staticPage]
    
    if let firstViewController = pages.first {
      setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
  }
  
  func updatePosition(offsetY: CGFloat) {
//    print(offsetY)
    
    //    print(sheetPresentationController.offset)
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
