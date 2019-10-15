//
//  SettingTableViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/15.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBInspectable var TargetStoryboard : String = ""
    @IBInspectable var ReuseCellIdentifier : String = "SettingTableViewCell"
    
    private(set)var  SettingItems : [ (String, [(String,String)])] = [
        ("个人信息",[
            ("个人资料","PersonalInfo")
        ]),
        ("社交",[
            ("我喜欢的作品","MyFavIllu"),
            ("我关注的人","Following"),
            ("关注我的人","Follower")
        ]),
        ("系统",[
            ("夜间模式","NightMode"),
            ("设置","Settings")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return SettingItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let (_, mapping) = SettingItems[section]
        return mapping.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseCellIdentifier, for: indexPath) as? SettingTableViewCell else {
            print("Cannit load cell \(ReuseCellIdentifier) at \(indexPath.section), \(indexPath.row)")
            return SettingTableViewCell()
        }
        
        // 正常加载Setting
        let(_,mapping) = SettingItems[indexPath.section]
        cell.SettingName.text = mapping[indexPath.row].0
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do onclick action
        let (_,mapping) = SettingItems[indexPath.section]
        let (shownName, executeVC) = mapping[indexPath.row]
        print("点击了\(shownName), 即将跳转到\(executeVC)")
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.textLabel?.font = v.textLabel?.font.withSize(14)
        v.textLabel?.textColor = UIColor.lightGray
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingItems[section].0
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
