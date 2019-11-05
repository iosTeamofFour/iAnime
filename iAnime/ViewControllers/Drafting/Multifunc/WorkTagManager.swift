//
//  WorkTagManager.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/5.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class WorkTagManager: UITableViewController {

    
    var Tags : [String] = [
        "标签1",
        "标签2",
        "标签3",
        "标签4"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            // 向上一个VC（PublishViewController回传数据）
            let vcParent = navigationController?.viewControllers.last
            if let publish = vcParent as? PublishViewController {
                publish.SelectedTag = Tags
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Tags.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)

        if let tagCell = cell as? TagCell {
            tagCell.title.text = Tags[indexPath.row]
        }
        return cell
    }
 
    

    @IBAction func AddTag(_ sender: UIBarButtonItem) {
        
        // 显示添加标签的对话框
        let alertController = UIAlertController(title: "添加标签", message: "", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "输入标签名"
            textField.isSecureTextEntry = false
        }
        
        let confirmAction = UIAlertAction(title: "好", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            let tagText = textField.text
            
            if let unwrapTagText = tagText {
                let path = IndexPath(row: self.Tags.count, section: 0)
                self.Tags.append(unwrapTagText)
                self.tableView.insertRows(at: [path], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Tags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
 
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
}
