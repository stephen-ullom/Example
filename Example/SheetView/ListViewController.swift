//
//  ListViewController.swift
//  Example
//
//  Created by Stephen Ullom on 10/21/24.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return 20  // Sample row count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
}
