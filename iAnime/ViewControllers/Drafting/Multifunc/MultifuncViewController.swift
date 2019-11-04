//
//  MultifuncViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/4.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

enum ColorizeRequestStatus : String {
    case Pending = "等待上传"
    case Uploading = "正在上传"
    case Processing = "正在处理"
    case Finished = "完成上色"
}

struct ColorizeRequest {
    var image : UIImage?
    var timestamp : String
    var percentage: Int
    var status : ColorizeRequestStatus
}

class MultifuncViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    var CurrentSketchImage : UIImage?
    var CurrentPointsData : [Int]?
    
    private var ReuseIdentifier = "ColorizeRequestCell"
    
    @IBOutlet weak var ColorizeRequestList: UITableView!
    
    private var datas : [ColorizeRequest] = [
        ColorizeRequest(image: nil, timestamp: "2019年11月04日", percentage: 10, status: ColorizeRequestStatus.Pending),
        ColorizeRequest(image: nil, timestamp: "2019年11月03日", percentage: 39, status: ColorizeRequestStatus.Finished),
        ColorizeRequest(image: nil, timestamp: "2019年11月05日", percentage: 40, status: ColorizeRequestStatus.Uploading)
    ]
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        ColorizeRequestList.delegate = self
        ColorizeRequestList.dataSource = self
    }
    @IBAction func SendRequestColorize(_ sender: UIButton) {
        
    }
    
    @IBAction func PublishColorization(_ sender: UIButton) {
        
    }
    
    private func HandleSendingColorizeRequest() {
        
    }
    
    private func HandlePublishColorization() {
        
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
            colorizeCell.ProcessPercentage.text = String(data.percentage)
            colorizeCell.RequestDate.text = data.timestamp
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "正在处理的上色任务"
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let target = indexPath.row
            let data = datas[target]
            if data.status == .Finished {
                datas.remove(at: target)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            else if data.status == .Pending {
                print("取消一个还没发给服务器的任务")
                datas.remove(at: target)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
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
