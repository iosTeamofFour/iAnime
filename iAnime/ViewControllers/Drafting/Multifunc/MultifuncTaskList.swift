//
//  MultifuncTaskList.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/10.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class MultifuncTaskList: MultifuncViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private var ReuseIdentifier = "ColorizeRequestCell"
    
    @IBOutlet weak var ColorizeRequestList: UITableView!
    
    var datas : [ColorizeRequest] = []
    var results : Dictionary<String,Image> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ColorizeRequestList.delegate = self
        ColorizeRequestList.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BeginRefreshColorizeTaskList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let drawingVC = presentingViewController as? DraftingViewController {
            print("向DrafingVC回传数据")
            drawingVC.drawingInfo = drawingInfo
            drawingVC.ColorizedResult = results
            drawingVC.ColorizeRequests = datas
        }
    }
    

    
    @IBAction func SendColorizeRequest(_ sender: UIButton) {
        let drawingViewSize = self.drawingVC.drawing.bounds.size
        let png = self.drawingVC.ExportDrawingViewToImageFile()
        DispatchQueue.global().async {
            
            var points : [[CGFloat]] = []
            for an in self.draftData!.Anchors {
                let percentX = an.anchor.point.x / drawingViewSize.width
                let percentY = an.anchor.point.y / drawingViewSize.height
                let R255 = an.anchor.color.R
                let G255 = an.anchor.color.G
                let B255 = an.anchor.color.B
                let CurrPoint = [percentX, percentY, R255, G255, B255, 0]
                points.append(CurrPoint)
            }
            
            for an in self.draftData!.Hints {
                let percentX = an.hint.point.x / drawingViewSize.width
                let percentY = an.hint.point.y / drawingViewSize.height
                let R255 = an.hint.color.R
                let G255 = an.hint.color.G
                let B255 = an.hint.color.B
                let CurrPoint = [percentX, percentY, R255, G255, B255, 2]
                points.append(CurrPoint)
            }
            let base64PNG = png?.base64EncodedString()
            let json = JSON(["points":points, "image": base64PNG! ])
            ColorizeServices.SendColorizeRequest(json, { receipt in
                DispatchQueue.main.async {
                    let driedImage = UIImage(data: png!)!
                    let resizedImage = driedImage.Resize(CGSize(width: driedImage.size.width * 0.3, height : driedImage.size.height * 0.3))
                    let request = ColorizeRequest(image: resizedImage, timestamp: Date().ToString(), percentage: 0, status: .Pending, receipt: receipt)
                    self.AppendRequestToTaskList(request)
                }
            }, { (code, err) in
                DispatchQueue.main.async {
                    self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "提交上色请求出现错误, 原因为 \(code) \(String(describing: err))", SingleAction: UIAlertAction.Well(nil)), animated: true, completion: nil)
                }
            })
        }
    }
    
    private func BeginRefreshColorizeTaskList() {
        if let MultiTaskVC = drawingVC.presentedViewController, MultiTaskVC == self {
            print("开启新的一轮刷新...")
            performSelector(inBackground: #selector(RefreshColorizeTaskList), with: self)
        }
    }
    
    @objc private func RefreshColorizeTaskList() {
        for (index,req) in datas.enumerated() {
            if req.status == .Pending {
                ColorizeServices.QueryColorizeRequestStatus(req.receipt, {
                    json in
                    let StatusCode = json["StatusCode"]
                    print("上色任务 \(req.receipt) 当前状态为 \(StatusCode)")
                    if StatusCode == 0 {
                        // 出现状态切换，表示已经上色完成
                        self.datas[index].status = .Finished
                        DispatchQueue.main.async {
                            self.ColorizeRequestList.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        }
                    }
                }, {
                    (code,err) in
                    print("查询\(req.status)的状态失败, 原因为: \(code)  \(err)")
                })
            }
        }
        usleep(5 * 1000 * 1000)
        BeginRefreshColorizeTaskList()
    }
    
    private func AppendRequestToTaskList(_ request : ColorizeRequest) {
        datas.append(request)
        ColorizeRequestList.insertRows(at: [IndexPath(row: datas.count - 1, section: 0)], with: .automatic)
    }
    
    
    
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = datas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier, for: indexPath)
        if let colorizeCell = cell as? ColorizeRequestCell {
            colorizeCell.RequestImg.image = data.image
            colorizeCell.ProcessPercentage.text = data.status.rawValue
            colorizeCell.RequestDate.text = data.timestamp
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "正在处理的上色任务"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 响应点击事件
        let req = datas[indexPath.row]
        if req.status == .Finished {
            // 这时候才考虑读取结果
            if let image = results[req.receipt] {
                drawingVC.LoadColorizedImage(image)
            }
            else {
                ColorizeServices.ReceiveColorizedImage(req.receipt, {
                    image in
                    self.dismiss(animated: false, completion: nil)
                    self.drawingVC.LoadColorizedImage(image)
                }, { err in print("加载图片失败, 原因: \(err)")})
            }
        }
    }
    
    
    @available(iOS 11.0, *)
    func SelectAsFinalUploadColorizationResult(_ indexPath : IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "选择") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            // 3
            let CellCount = self.datas.count
            
            for i in 0..<CellCount {
                if let RequestCell = self.ColorizeRequestList.cellForRow(at: IndexPath(row: i, section: 0)) as? ColorizeRequestCell {
                    RequestCell.DeselectAsUploadImags()
                }
            }
            
            if let CurrentSelectedCell = self.ColorizeRequestList.cellForRow(at: indexPath) as? ColorizeRequestCell {
                CurrentSelectedCell.SelectedAsUploadImage()
                self.SelectedColorizationImageReceipt = self.datas[indexPath.row].receipt
                print("成功选择 Receipt: \(self.datas[indexPath.row].receipt) 作为最终上色作品Receipt。")
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        }
        action.backgroundColor = UIColor.orange
        return action
    }

    @available(iOS 11.0, *)
    func SelectAsDeleteFinishedResult(_ indexPath : IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "移除") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            completionHandler(self.PerformDeleteColorizeRequest(self.ColorizeRequestList, indexPath))
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [SelectAsDeleteFinishedResult(indexPath), SelectAsFinalUploadColorizationResult(indexPath)])
    }
    
    
    
    private func PerformDeleteColorizeRequest(_ tableView : UITableView, _ indexPath : IndexPath) -> Bool {
        let target = indexPath.row
        let data = datas[target]
        // 只有Finished状态的可以被删除
        if data.status == .Finished {
            datas.remove(at: target)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            PerformDeleteColorizeRequest(tableView, indexPath)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.textLabel?.font = v.textLabel?.font.withSize(14)
        v.textLabel?.textColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let data = datas[indexPath.row]
        if data.status == ColorizeRequestStatus.Finished {
            return indexPath
        }
        return nil
    }
}
