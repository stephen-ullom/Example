//
//  PageViewController.swift
//  Example
//
//  Created by Stephen Ullom on 10/21/24.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource
{

    let pages = [
        ListViewController(), ListViewController(), ListViewController(),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        setViewControllers(
            [pages[0]], direction: .forward, animated: true, completion: nil)
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! ListViewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! ListViewController),
            index < pages.count - 1
        else { return nil }
        return pages[index + 1]
    }
}
