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


class PublishViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var WorkInfo: UITableView!
    
    @IBOutlet weak var WorkPreview: UIImageView!
    
    var SelectedTag : [String] = [] {
        didSet {
            drawingInfo?.Tags = SelectedTag
        }
    }
    
    var drawingInfo : DrawingInfo?
    var draftData : DraftData?
    var previewImagePNG : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let previewData = previewImagePNG {
            WorkPreview.image = UIImage(data: previewData)
        }
        WorkInfo.delegate = self
        WorkInfo.dataSource = self
    }
    
     override func viewWillAppear(_ animated: Bool) {
        UpdateTagsList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SyncAllDataToDrawingInfoInstance()
    }
    
    private func UpdateTagsList() {
        
        SelectedTag = drawingInfo?.Tags ?? []
        
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
    
    private func SyncAllDataToDrawingInfoInstance() {
        
        // 同步作品名称和作品描述
        
        var namePath = IndexPath(row: 0, section: 0)
        drawingInfo?.Name = (WorkInfo.cellForRow(at: namePath) as! InputCell).input.text ?? ""
        namePath.row = 1
        drawingInfo?.Description = (WorkInfo.cellForRow(at: namePath) as! InputCell).input.text ?? ""
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // =============== 作品相关属性TableView控制 ==============
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 将drawingInfo中的数据加载到Cell中
        let target = CellsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: target.value.rawValue, for: indexPath)
        switch target.value {
        case .Text:
            let inputCell = cell as! InputCell
            inputCell.title.text = target.key
            if indexPath.row == 0 {
                // 作品名称
                inputCell.input.text = drawingInfo?.Name
            }
            else {
                // 作品描述
                inputCell.input.text = drawingInfo?.Description
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
                 // 允许二次创作
                switchCell.toggle.addTarget(self, action: #selector(HandleChangeAllowFork(_:)), for: .valueChanged)
                switchCell.toggle.isOn = drawingInfo?.AllowFork ?? true
            }
            else {
               // 允许保存到本地
                switchCell.toggle.addTarget(self, action: #selector(HandleChangeAllowSaveToLocal(_:)), for: .valueChanged)
                switchCell.toggle.isOn = drawingInfo?.AllowSaveToLocal ?? true
            }
            break
        }
        return cell
    }
    
    @objc private func HandleChangeAllowSaveToLocal(_ sender: UISwitch) {
        // 同步是否允许保存到本地的设置
        drawingInfo?.AllowSaveToLocal = sender.isOn
    }
    
    @objc private func HandleChangeAllowFork(_ sender : UISwitch) {
        // 同步是否允许将此作品进行二次创作的设置
        drawingInfo?.AllowFork = sender.isOn
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
