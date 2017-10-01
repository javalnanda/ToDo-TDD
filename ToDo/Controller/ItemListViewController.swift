//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Javal Nanda on 30/09/17.
//  Copyright © 2017 Equal experts. All rights reserved.
//

import Foundation
import UIKit

class ItemListViewController: UIViewController {
    
    let itemManager = ItemManager()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  
        tableView.reloadData()
    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showDetails(sender:)),
            name: NSNotification.Name("ItemSelectedNotification"),
            object: nil)
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = self.itemManager
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController =
            storyboard?.instantiateViewController(
                withIdentifier: "InputViewController")
                as? InputViewController {
            nextViewController.itemManager = self.itemManager
            present(nextViewController, animated: true, completion: nil)
        }
        
    }
    
    @objc func showDetails(sender: NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int else
        { fatalError() }
        
        if let nextViewController = storyboard?.instantiateViewController(
            withIdentifier: "DetailViewController") as? DetailViewController {
            
            
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController,
                                                     animated: true)
        }
    }
}
