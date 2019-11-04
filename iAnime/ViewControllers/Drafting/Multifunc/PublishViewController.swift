//
//  PublishViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/5.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

enum WorkInfoCellType : String {
    case Text = "InputCell"
    case Jump = "EnterCell"
    case Switch = "SwitchCell"
}

struct PublishWorkInfo {
    var Name : String
    var Description : String
    var LabelList : [String]
    var AllowSaveToLocal : Bool
    var AllowFork : Bool
}

class PublishViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var WorkInfo: UITableView!
    var SelectedTag : [String] = ["简单的一个"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkInfo.delegate = self
        WorkInfo.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UpdateTagsList()
    }
    
    private func UpdateTagsList() {
        let path = IndexPath(row: 2, section: 0)
        if let tagsCell = WorkInfo.cellForRow(at: path) as? EnterCell {
            tagsCell.subTitle.text = " ".Join(SelectedTag)
            WorkInfo.reloadRows(at: [path], with: .none)
        }
    }
    
    private var CellsList : [Pair<String,WorkInfoCellType>] = [
        Pair("作品名称", .Text),
        Pair("作品描述",.Text),
        Pair("标签列表",.Jump),
        Pair("允许保存到本地",.Switch),
        Pair("允许二次创作",.Switch)
    ]
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        if let tagsManager = dest as? WorkTagManager {
            tagsManager.Tags = SelectedTag
        }
    }
    
    @IBAction func CancelToDrawing(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func BeginPublishWork(_ sender: UIBarButtonItem) {
    }
    
    

    
    // =============== 作品相关属性TableViewz控制
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let target = CellsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: target.value.rawValue, for: indexPath)
        switch target.value {
        case .Text:
            let inputCell = cell as! InputCell
            inputCell.title.text = target.key
            if indexPath.row == 0 {
                // 作品名称
                inputCell.input.text = "假装作品名称"
            }
            else {
                // 作品描述
                inputCell.input.text = "假装作品描述"
            }
            
            break
        case .Jump:
            let jumpCell = cell as! EnterCell
            jumpCell.title.text = target.key
            jumpCell.subTitle.text = " ".Join(SelectedTag)
            break
        default:
            let switchCell = cell as! SwitchCell
            switchCell.title.text = target.key
            // Other one must be Switch
            if indexPath.row == 4 {
                // 允许保存到本地
                switchCell.toggle.isOn = false
            }
            else {
                // 允许二次创作
                switchCell.toggle.isOn = true
            }
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "作品属性"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.textLabel?.font = v.textLabel?.font.withSize(14)
        v.textLabel?.textColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let target = CellsList[indexPath.row]
        if target.value == .Jump {
            return indexPath
        }
        return nil
    }
}
