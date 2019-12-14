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

class MultifuncViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var SaveToLocalBtn: UIButton!
    
    var draftData : DraftData?
    var drawingInfo : DrawingInfo?
    var drawingVC : DraftingViewController!
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 拿到 DraftingViewController 的实例
        drawingVC = presentingViewController as? DraftingViewController
        
        SaveToLocalBtn.addTarget(self, action: #selector(HandleSaveToLocalWork(_:)), for: .touchUpInside)
        SaveToLocalBtn.isEnabled = draftData != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let drawingVC = presentingViewController as? DraftingViewController {
            print("向DrafingVC回传数据")
            drawingVC.drawingInfo = drawingInfo
        }
    }
    
    @IBAction func SendRequestColorize(_ sender: UIButton) {
        
    }
    
    @IBAction func PublishColorization(_ sender: UIButton) {
        
    }
    
    
    @objc func HandleSaveToLocalWork(_ sender: UIButton) {
        let (container, indicator) = ShowLoadingIndicator()
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
