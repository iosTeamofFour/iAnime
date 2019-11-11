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

    
    var draftData : DraftData?
    var drawingInfo : DrawingInfo?


    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(presentingViewController)
        if let drawingVC = presentingViewController as? DraftingViewController {
            print("向DrafingVC回传数据")
            drawingVC.drawingInfo = drawingInfo
        }
    }
    
    @IBAction func SendRequestColorize(_ sender: UIButton) {
        
    }
    
    @IBAction func PublishColorization(_ sender: UIButton) {
        
    }
    
    private func HandleSendingColorizeRequest() {
        
    }
    
    private func HandlePublishColorization() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 将数据通过segue传到下一个VC
        print(segue.destination)
        if let publishNav = segue.destination as? UINavigationController,
            let publishVC = publishNav.viewControllers.first as? PublishViewController {
            print(publishVC)
            publishVC.draftData = draftData
            publishVC.drawingInfo = drawingInfo
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
