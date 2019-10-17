//
//  SettingTableViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/15.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    @IBInspectable var TargetStoryboard : String = "Settings"
    @IBInspectable var ReuseCellIdentifier : String = "SettingTableViewCell"
    
    open var SettingItems : [(String, [[String]])] = [
        ("个人信息",[
            ["个人资料","PersonalInfo"]
        ]),
        ("社交",[
            ["我喜欢的作品","MyFavIllu"],
            ["我关注的人","Following"],
            ["关注我的人","Follower"]
        ]),
        ("系统",[
            ["夜间模式","","NightModeTableViewCell"],
            ["设置","SystemSettings"]
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
        
        let(_,mapping) = SettingItems[indexPath.section]
        let cellInfo = mapping[indexPath.row]
        let cellIdentifier = cellInfo.count == 3 ? cellInfo[2] : ReuseCellIdentifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as? SettingTableViewCell else {
            print("Cannit load cell \(cellIdentifier) at \(indexPath.section), \(indexPath.row)")
            return SettingTableViewCell()
        }
        print("加载Cell: \(cellIdentifier)")
        cell.SettingName.text = cellInfo[0]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do onclick action
        let (_,mapping) = SettingItems[indexPath.section]
        let cellInfo = mapping[indexPath.row]
        
        if (cellInfo[1] as NSString).length > 0 {
             GoToExternalStoryboardWithVCSpecified(TargetStoryboard, vcIdentifier: cellInfo[1], nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.textLabel?.font = v.textLabel?.font.withSize(14)
        v.textLabel?.textColor = UIColor.lightGray
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingItems[section].0
    }
}
