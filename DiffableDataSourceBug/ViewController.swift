//
//  ViewController.swift
//  DiffableDataSourceBug
//
//  Created by Emilio Pavia on 19/02/2020.
//  Copyright © 2020 Emilio Pavia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var data: [Model] = Array(1...100).map { Model(identifier: $0, text: String($0)) }
    
    lazy var dataSource = UITableViewDiffableDataSource<Int, Model>(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = model.text
        cell.textLabel?.textColor = model.textColor
        return cell
    })
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Model>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    @IBAction func edit(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Change the first visible item",
                                            message: "By using animation the cell is not refreshed (i.e. the cellProvider isn't called), but if you make the cell disappear and appear again, it has the updated value.\n\nNo issues without animation.",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Without animation", style: .default, handler: { _ in
            self.changeFirstVisibleRow(animatingDifferences: false)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "With animation", style: .default, handler: { _ in
            self.changeFirstVisibleRow(animatingDifferences: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func changeFirstVisibleRow(animatingDifferences: Bool) {
        guard let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first else { return }
        guard let item = dataSource.itemIdentifier(for: firstVisibleIndexPath) else { return }
        item.text = String(describing: Date())

        var snapshot = NSDiffableDataSourceSnapshot<Int, Model>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

