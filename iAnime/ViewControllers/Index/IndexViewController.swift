//
//  IndexViewController.swift
//  iAnime
//
//  Created by Zoom on 2019/10/8.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    
    @IBOutlet weak var CreateDrawButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CreateDrawButton.AddCircleShadow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ============== 加号按钮的功能 ================
    
    @IBAction func OnEnterDrawingMode(_ sender: UIButton) {
        var actions = [
            UIAlertAction(title: "从图库中选择", style: .default, handler: {
                _ in
                self.BeginPickImageFromLibrary(.photoLibrary)
            }),
            UIAlertAction(title: "拍摄一张线稿", style: .default, handler: {
                _ in
                self.BeginPickImageFromLibrary(.camera)
            }),
            UIAlertAction(title: "从空白画布开始", style: .default, handler: {
                _ in self.GoToDrawingView(nil)
            }),
            UIAlertAction(title: "取消", style: .cancel, handler: nil)
        ]
        
        if PersistenceManager.IfHaveSuchDraft() {
            actions.append(UIAlertAction(title: "读取保存的草稿", style: .default, handler: {
                _ in
                let (info, data) = PersistenceManager.LoadDraftWorkDataWithDrawingInfo()
                self.GoToDrawingView(data!, info!)
            }))
            
            actions.append(UIAlertAction(title: "删除保存的草稿", style: .default, handler: {
                _ in
                if PersistenceManager.DeleteDraftData() {
                    self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "草稿已经被删除。", SingleAction: UIAlertAction.Well(nil)), animated: true, completion: nil)
                }
                else {
                    self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "出现未知错误, 草稿删除失败。", SingleAction: UIAlertAction.Well(nil)), animated: true, completion: nil)
                }
            }))
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let sheet = UIAlertController.MakeAlertSheetPopover("开始创作", "选择线稿来源", actions, sender)
            present(sheet, animated: true, completion: nil)
        }
        else {
            let sheet = UIAlertController.MakeAlertSheet("开始创作", "选择线稿来源", actions)
            present(sheet, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        let alert = UIAlertController.MakeSingleSelectionAlertDialog("未选择图片", ControllerMsg: "要以一张初始线稿开始创作, 您必须选择一张图片。",SingleAction: UIAlertAction.Well(nil))
        present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            let alert = UIAlertController.MakeSingleSelectionAlertDialog("未选择图片", ControllerMsg: "必须选择一张有效的图片。",SingleAction: UIAlertAction.Well(nil))
            present(alert, animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
        GoToDrawingView(pickedImage)
    }
    private func BeginPickImageFromLibrary(_ type : UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    
    func GoToDrawingView(_ withBackground : UIImage?) {
        let sb = UIStoryboard(name: "Drafting", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "DrawingView") as? DraftingViewController {
            vc.shouldLoadBackground	 = withBackground
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func GoToDrawingView(_ withRestoreData : DraftData, _ withRestoreDrawingInfo : DrawingInfo) {
        let sb = UIStoryboard(name: "Drafting", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "DrawingView") as? DraftingViewController {
            
            vc.shouldRestoreData = withRestoreData
            vc.drawingInfo = withRestoreDrawingInfo
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}

