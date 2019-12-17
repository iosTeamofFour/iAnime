//
//  MultifuncViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/4.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ColorizeRequestStatus : String {
    case Pending = "等待"
    case Uploading = "上传"
    case Processing = "处理"
    case Finished = "完成"
}

struct ColorizeRequest {
    var image : UIImage?
    var timestamp : String
    var percentage: Int
    var status : ColorizeRequestStatus
    var receipt : String
}

class MultifuncViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var SaveToLocalBtn: UIButton!
    
    var draftData : DraftData?
    var drawingInfo : DrawingInfo?
    var drawingVC : DraftingViewController!
    
    var SelectedColorizationImageReceipt : String?
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 拿到 DraftingViewController 的实例
        SaveToLocalBtn.addTarget(self, action: #selector(HandleSaveToLocalWork(_:)), for: .touchUpInside)
    }

    
    @IBAction func PublishColorizedWork(_ sender: UIButton) {
        if let receipt = SelectedColorizationImageReceipt, let info = drawingInfo {
            let (container, _) = ShowLoadingIndicator()
            
            ColorizeServices.PublishWork(info, receipt, {
                NewWorkId in
                container.removeFromSuperview()
                self.AllowDismissWhenClickOutside()
                
                self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "您已成功上传作品。新的作品ID为: \(NewWorkId)。谢谢您为这个世界上色。", SingleAction: UIAlertAction.Well(nil)), animated: true, completion: nil)
                
            }, {
                failedCode in
                container.removeFromSuperview()
                self.AllowDismissWhenClickOutside()
                self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "抱歉，目前我们无法保存您上传的作品，请稍后再试。", SingleAction: UIAlertAction.Well(nil)), animated: true, completion: nil)
            })
        }
        else {
            present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "要发布作品，您必须先选择一张用于发布的上色稿。从右到左轻划已完成的上色任务以选择。", SingleAction: UIAlertAction.Well(nil)), animated: true, completion: nil)
        }
    }
    
    @objc func HandleSaveToLocalWork(_ sender: UIButton) {
        let (container, _) = ShowLoadingIndicator()
        DispatchQueue.global().async {
            if let info = self.drawingInfo, let png = self.drawingVC.ExportDrawingViewToImageFile() {
                info.CreatedTime = Date2Unix(Date())
                // 接下来将持久化当前画板内容、历史记录信息以及作品信息
                let persistResult = PersistenceManager.PersistLocalWorkDataWithDrawingInfo(self.draftData, info, png)
                DispatchQueue.main.async {
                    container.removeFromSuperview()
                    self.AllowDismissWhenClickOutside()
                    let hint = UIAlertController.MakeAlertDialog("保存到本地作品", persistResult ? "保存成功" : "保存失败", [UIAlertAction(title: "好", style: .cancel, handler: nil)])
                    self.present(hint, animated: true, completion: nil)
                }
            }
            else {
                print("暂无Drawing Info, 无法持久化")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 将数据通过segue传到下一个VC
        if let publishNav = segue.destination as? UINavigationController,
            let publishVC = publishNav.viewControllers.first as? PublishViewController {
            publishVC.draftData = self.draftData
            publishVC.drawingInfo = self.drawingInfo
            let png = self.drawingVC.ExportDrawingViewToImageFile()
            publishVC.previewImagePNG = png
        }
    }
    
    @IBAction func unwindToMultifuncVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceVC = unwindSegue.source
        // 从PublishVC拿回数据
        if let publishVC = sourceVC as? PublishViewController {
            draftData = publishVC.draftData
            drawingInfo = publishVC.drawingInfo
        }
    }
}
