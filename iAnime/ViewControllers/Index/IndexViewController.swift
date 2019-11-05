//
//  IndexViewController.swift
//  iAnime
//
//  Created by Zoom on 2019/10/8.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var MyIlluGrid: GridView!
    
    
    @IBOutlet weak var CreateDrawButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CreateDrawButton.AddCircleShadow()
//        MyIlluGrid.OnPlacedGrid = {
//            grid in
//            self.LoadFakeIllustration()
//            self.LoadFakeIllustration()
//            self.LoadFakeIllustration()
// }
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
        
        if PersistenceManager.CheckIfDraftExists() {
            actions.append(UIAlertAction(title: "读取保存的草稿", style: .default, handler: {
                _ in
                if let draft = PersistenceManager.LoadDraftData() {
                    self.GoToDrawingView(draft)
                }
                else {
                    self.GoToDrawingView(nil)
                }
            }))
        }
        
        let sheet = UIAlertController.MakeAlertSheet("开始创作", "选择线稿来源", actions)
        present(sheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        let alert = UIAlertController.MakeAlertDialog("未选择图片", "要以一张初始线稿开始创作, 您必须选择一张图片。",[
                UIAlertAction(title: "好", style: .cancel, handler: nil)
            ])
        present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            let alert = UIAlertController.MakeAlertDialog("未选择图片", "必须选择一张有效的图片。",[
                UIAlertAction(title: "好", style: .cancel, handler: nil)
                ])
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
    
    private func GoToDrawingView(_ withBackground : UIImage?) {
        let sb = UIStoryboard(name: "Drafting", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "DrawingView") as? DraftingViewController {
            vc.shouldLoadBackground	 = withBackground
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func GoToDrawingView(_ withRestoreData : DraftData) {
        let sb = UIStoryboard(name: "Drafting", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "DrawingView") as? DraftingViewController {
            
            vc.shouldRestoreData = withRestoreData
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    //    private func LoadFakeIllustration() {
//        let illu1 = Illustration(Image: UIImage(named: "Left-2")!, Name: "Zhengzeming", UploadDate: Date())
//
//        let illu2 = Illustration(Image: UIImage(named: "Left-3")!, Name: "Huangpixuan", UploadDate: Date())
//        let item2 = IllustrationItemView()
//        item2.illustration = illu2
//
//        let item1 = IllustrationItemView()
//        item1.illustration = illu1
//
//
//        MyIlluGrid.AddItem(item1)
//        MyIlluGrid.AddItem(item2)
//    }
}

