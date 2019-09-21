//
//  MainViewController.swift
//  07_IOSDrawing
//
//  Created by sy on 2019/9/21.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewController",
            let detailVC = segue.destination as? DetailViewController,
            let selectedIndexpath = self.tableView.indexPathForSelectedRow {
            detailVC.detailMenuItem = DetailMenuItem.allDetailMenuItems()[selectedIndexpath.row]
        }
    }
    
    
    // MARK: - table view delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailMenuItem.allDetailMenuItems().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        let allMenuItem = DetailMenuItem.allDetailMenuItems()
        cell.textLabel?.text = allMenuItem[indexPath.row].menuLable
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailViewController", sender: nil)
    }

}
