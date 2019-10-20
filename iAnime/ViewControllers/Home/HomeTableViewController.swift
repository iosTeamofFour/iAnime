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
    
//    open var SettingItems : [(String, [[String]])] = [
//        ("个人信息",[
//            ["个人资料","PersonalInfo"]
//        ]),
//        ("社交",[
//            ["我喜欢的作品","MyFavIllu"],
//            ["我关注的人","Following"],
//            ["关注我的人","Follower"]
//        ]),
//        ("系统",[
//            ["夜间模式","","NightModeTableViewCell"],
//            ["设置","SystemSettings"]
//        ])
//    ]
    var SettingItems : [SettingGroup]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SettingItems = [
            SettingGroup(GroupName: "个人信息", GroupItems: [
                    SegueSettingCell<String>(CellName: "个人资料",
                                                  TargetCellIdentifier: ReuseCellIdentifier,
                                                  TargetStoryboard: "Person",
                                                  TargetViewController: "PersonalInfo",
                                                  PushToNavigationController: true,
                                                  BackItemKey: "返回",
                                                  ShowNavigationBar : false)
                ]),
            SettingGroup(GroupName: "社交", GroupItems: [
                    SegueSettingCell<String>(CellName: "我喜欢的作品",
                                             TargetCellIdentifier: ReuseCellIdentifier,
                                             TargetStoryboard: TargetStoryboard,
                                             TargetViewController: "MyFavIllu",
                                             PushToNavigationController: true,
                                             BackItemKey: "返回",
                                             ShowNavigationBar : true),
                    SegueSettingCell<String>(CellName: "我关注的人",
                                             TargetCellIdentifier: ReuseCellIdentifier,
                                             TargetStoryboard: TargetStoryboard,
                                             TargetViewController: "Following",
                                             PushToNavigationController: true,
                                             BackItemKey: "返回",
                                             ShowNavigationBar : true),
                    SegueSettingCell<String>(CellName: "关注我的人",
                                             TargetCellIdentifier: ReuseCellIdentifier,
                                             TargetStoryboard: TargetStoryboard,
                                             TargetViewController: "Follower",
                                             PushToNavigationController: true,
                                             BackItemKey: "返回",
                                             ShowNavigationBar : true)
                ]),
            SettingGroup(GroupName: "系统", GroupItems: [
                    OptionSettingCell(CellName: "夜间模式",
                                           TargetCellIdentifier: "NightModeTableViewCell"),
                    SegueSettingCell<String>(CellName: "设置",
                                             TargetCellIdentifier: ReuseCellIdentifier,
                                             TargetStoryboard: TargetStoryboard,
                                             TargetViewController: "SystemSettings",
                                             PushToNavigationController: true,
                                             BackItemKey: "返回",
                                             ShowNavigationBar : true)
                ])
        ]
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return SettingItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SettingItems[section].GroupItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let group = SettingItems[indexPath.section]
        let cellItem = group.GroupItems[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellItem.TargetCellIdentifier,for: indexPath) as? SettingTableViewCell else {
            print("Cannit load cell at \(indexPath.section), \(indexPath.row)")
            return SettingTableViewCell()
        }
//        print("加载Cell: \(cellItem.CellName)")
        cell.SettingName.text = cellItem.CellName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do onclick action
//        let (_,mapping) = SettingItems[indexPath.section]
//        let cellInfo = mapping[indexPath.row]
//
//        if (cellInfo[1] as NSString).length > 0 {
//             GoToExternalStoryboardWithVCSpecified(TargetStoryboard, vcIdentifier: cellInfo[1], nil)
//        }
        
        let cellItem = SettingItems[indexPath.section].GroupItems[indexPath.row]
        if let typedCellItem = cellItem as? SegueSettingCell<String> {
            if typedCellItem.PushToNavigationController {
                GoToExternalStoryboardWithVCSpecified(typedCellItem.TargetStoryboard ?? TargetStoryboard,
                                                      vcIdentifier: typedCellItem.TargetViewController,
                                                      typedCellItem.BackItemKey)
                    .ToggleVisibleForNavigationItem(typedCellItem.ShowNavigationBar)
            }
            else {
                let sb = UIStoryboard(name: typedCellItem.TargetStoryboard ?? TargetStoryboard, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: typedCellItem.TargetViewController)
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.textLabel?.font = v.textLabel?.font.withSize(14)
        v.textLabel?.textColor = UIColor.lightGray
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingItems[section].GroupName
    }
}
