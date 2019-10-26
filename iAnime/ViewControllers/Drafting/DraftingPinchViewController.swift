//
//  PinchImageViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/17.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class DraftingPinchViewController: UIViewController {
    
    // 当前显示的imageView
    var _imageView : UIImageView!
    
    var imageView : UIImageView! {
        get {
            return _imageView
        }
    }
    
    var backgroundIv : UIImageView! {
        get {
            return UIImageView()
        }
    }
    
    // 是否正在执行最大最小放大倍数限制操作(因为是自己模拟的缩放事件, 开了线程, 不应该被其他触摸事件打断)
    private var IsDoingOverScale = false
    
    // 最后一次双指缩放的中心点, 给 Pinch .ended时的限制最大最小缩放比例的回缩函数用的
    private var LastScaleCenterPoint : CGPoint = CGPoint.zero

    // 手势识别控件
    var PinchGestureRecognizer : UIPinchGestureRecognizer!
    
    var PanGestureRecognizer : UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitGestureRecognizer()
        PlaceImageViews()
    }
    
    private func PlaceImageViews() {
        let (width, height) = UIUtils.GetScreenWHDP()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        backgroundIv.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    private func InitGestureRecognizer() {
        PinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(OnImageViewPinch(_:)))
        PanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(OnImageViewPan(_:)))
    }
    
    func EnableGestrueRecognizer() {
        PinchGestureRecognizer.isEnabled = true
        PanGestureRecognizer.isEnabled = true
    }
    
    func DisableGestureRecognizer() {
        PinchGestureRecognizer.isEnabled = false
        PanGestureRecognizer.isEnabled = false
    }
    
    // 为当前imageView添加/移除手势识别器
    
    func AttachGestureRecognizerToImageView(_ iv : UIImageView) {
        iv.addGestureRecognizer(PinchGestureRecognizer)
        iv.addGestureRecognizer(PanGestureRecognizer)
    }
    
    func DetachGestureRecognizerFromImageView(_ iv:UIImageView) {
        iv.removeGestureRecognizer(PinchGestureRecognizer)
        iv.removeGestureRecognizer(PanGestureRecognizer)
    }
    
    private func ComputeScaleMatrix(_ centerPoint: CGPoint,_ scale : CGFloat,_ imageView : UIImageView, _ lm : CGAffineTransform?) -> CGAffineTransform {
        
        /*
         将图片以某点作为中心点放大是比较简单的, 因为可以利用矩阵的连乘，针对只会根据图片当前所在正中心为基准放大的模式, 只要把"图片的正中心"移动到”实际的放大中心"
         将图片放大之后再将正中心移回原来的位置就可以了。
         */
        
        var cp = centerPoint
        let ivBounds = imageView.bounds
        
        cp.x -= ivBounds.midX
        cp.y -= ivBounds.midY
        
        var matrix = lm ?? imageView.transform
        
        matrix = matrix.translatedBy(x: cp.x, y: cp.y)
        matrix = matrix.scaledBy(x: scale, y: scale)
        matrix = matrix.translatedBy(x: -cp.x, y: -cp.y)
        return matrix
    }
    
    private func ComputeScaleOffsetMatrix(_ iv : UIImageView) {
        // 计算缩放后新x, y的位置
        var offsetX : CGFloat = 0
        // 在缩放过程中如果缩放中心点比较靠左，不断缩小的时候会导致图片的左边界缩到屏幕的里面，这是不行的，需要进行计算跑进屏幕里面的Offset，还原回去进行贴边操作
        // 注意这里不要使用translatedBy，矩阵操作更新速度不及时, 会导致当左边贴边的时候，如果再不断向右拉动图片会看到图片的左边不断的抖动，非常难看。
        if iv.frame.minX > 0 && iv.frame.maxX >= view.frame.width {
            offsetX = -iv.frame.minX
        }
            // 同理如果图片的右边缩进屏幕中心了需要计算Offset
        else if iv.frame.maxX < view.frame.width && iv.frame.minX < 0 {
            offsetX = view.frame.width - iv.frame.maxX
        }
            // 两条边都缩进屏幕里面的时候，平衡中心
        else if 0<=iv.frame.minX && iv.frame.maxX <= view.frame.width {
            let XCenter = (iv.frame.minX + iv.frame.maxX) / 2
            offsetX = (view.frame.width/2 - XCenter)
        }
        // Y 同理，只不过我不知道为什么这里对于Y的offset都要/2, 否则就会不断上下抖动。
        var offsetY : CGFloat = 0
        if iv.frame.minY > 0 && iv.frame.maxY >= view.frame.height {
            offsetY = -iv.frame.minY/2
        }
            
        else if iv.frame.maxY < view.frame.height && iv.frame.minY < 0 {
            offsetY = (view.frame.height - iv.frame.maxY)/2
        }
            
        else if 0<=iv.frame.minY && iv.frame.maxY <= view.frame.height {
            let YCenter = (iv.frame.minY + iv.frame.maxY) / 2
            offsetY = (view.frame.height/2 - YCenter)/2
        }
        // 应用Offset
        iv.frame.origin.x += offsetX
        iv.frame.origin.y += offsetY
        backgroundIv.frame.origin.x += offsetX
        backgroundIv.frame.origin.y += offsetY
        iv.layoutIfNeeded()
    }
    
    @objc func OnImageViewPinch(_ sender: UIPinchGestureRecognizer) {
        
        if !IsDoingOverScale {
            if sender.state == .changed {
                let centerPoint = sender.location(in: imageView)
                LastScaleCenterPoint = centerPoint
                // 计算缩放矩阵
                let matrix = ComputeScaleMatrix(centerPoint, sender.scale, imageView, nil)
                // 检测是否需要进行贴边操作，需要的话就偏移回去。
                ComputeScaleOffsetMatrix(imageView)
                imageView.transform = matrix
                backgroundIv.transform = matrix
            }
            
            if sender.state == .ended {
                // 康康是不是超出了最大放大倍率，如果是就要回缩/ 回放大。
                let lastScale = imageView.transform.a
                if lastScale > 4 {
                    ScaleImageView(0.1, lastScale, 4, imageView, LastScaleCenterPoint)
                }
                else if lastScale < 1 {
                    ScaleImageView(0.1, lastScale, 1, imageView, LastScaleCenterPoint)
                }
            }
        }
        sender.scale = 1
    }
    
    private func ScaleImageView(_ last : CGFloat, _ currentScale : CGFloat, _ targetScale : CGFloat, _ ivToScale : UIImageView, _ centerPoint : CGPoint) {
        // 自己模拟一个小步进多迭代的函数来实现这个效果
        
        // (0.9975^K) * N = 目标倍数
        // (1.0025^K) * N = 目标倍数
        if targetScale == currentScale {
            return
        }
        let stepLength = targetScale > currentScale ? 1.0025 : 0.9975
        let stepCount = Int(Double((log(targetScale) - log(currentScale))) / log(stepLength))
        IsDoingOverScale = true
        DispatchQueue.global().async {
            let sleepTime = Float(last) / Float(stepCount)
            
            for _ in 0..<stepCount {
                DispatchQueue.main.async {
                    let transformMat = self.ComputeScaleMatrix(centerPoint, CGFloat(stepLength), ivToScale,nil)
                    ivToScale.transform = transformMat
                    self.backgroundIv.transform = transformMat
                    self.ComputeScaleOffsetMatrix(ivToScale)
                }
                usleep(useconds_t(sleepTime * 1000 * 1000))
            }
            self.IsDoingOverScale = false
        }
    }
    
    // 处理图片的左右移动
    @objc func OnImageViewPan(_ sender: UIPanGestureRecognizer) {
        if !IsDoingOverScale {
            
            if sender.state == .began || sender.state == .changed {
                var trans = sender.translation(in: imageView)
                
                var ivMinY = imageView.frame.minY, ivMaxY = imageView.frame.maxY
                var ivMinX = imageView.frame.minX, ivMaxX = imageView.frame.maxX
                
                // 左边贴边了，但是想 → 移动，又不是切换上一张图，就取消掉此次的X偏移
                if ivMinX == 0  && trans.x > 0 {
                    trans.x = 0
                }
                // 右边贴边了, 又想向←移动, 又不能切下一张图，取消掉此次的X
                if ivMaxX == view.frame.width && trans.x < 0 {
                    trans.x = 0
                }
                // 对Y的上下移动同理
                if ivMinY == 0 && trans.y > 0 {
                    trans.y = 0
                }
                
                if ivMaxY == view.frame.height && trans.y < 0 {
                    trans.y = 0
                }
                
                // 如果X被允许移动
                if trans.x != 0 {
                    
                    let realTransX = trans.x * imageView.transform.a
                    
                    imageView.frame.origin.x += realTransX
                    
                    backgroundIv.frame.origin.x += realTransX
                    
                    ivMinX += realTransX
                    ivMaxX += realTransX
                    
                    SnapImageViewToEdges()
                }
                
                // 处理Y 轴移动，注意正在加载下一张图的过程中不再响应当前图片的Y移动
                
                if ivMinY <= 0 && ivMaxY >= view.frame.height {
                    let realTransY = trans.y * imageView.transform.d
                    imageView.frame.origin.y += realTransY
                    backgroundIv.frame.origin.y += realTransY
                }
                
                sender.setTranslation(CGPoint.zero, in: imageView)
                
                // 确保对frame的改动已经生效。
                imageView.layoutIfNeeded()
                backgroundIv.layoutIfNeeded()
                view.layoutIfNeeded()
            }
            else if sender.state == .ended {
                
                SnapImageViewToEdges()
            }
        }
        sender.setTranslation(CGPoint.zero, in: imageView)
    }
    
    private func SnapImageViewToEdges() {
        // 要求当前图片贴紧四边
        let ivMinY = imageView.frame.minY, ivMaxY = imageView.frame.maxY
        let ivMinX = imageView.frame.minX, ivMaxX = imageView.frame.maxX
        if ivMinX > 0 {
            imageView.frame.origin.x = 0
            backgroundIv.frame.origin.x = 0
        }
        if ivMaxX < view.frame.width {
            imageView.frame.origin.x += view.frame.width - ivMaxX
            backgroundIv.frame.origin.x += view.frame.width - ivMaxX
        }
        if ivMinY > 0 {
            imageView.frame.origin.y = 0
            backgroundIv.frame.origin.y = 0
        }
        if ivMaxY < view.frame.height {
            imageView.frame.origin.y += view.frame.height - ivMaxY
            backgroundIv.frame.origin.y += view.frame.height - ivMaxY
        }
        
        imageView.layoutIfNeeded()
        backgroundIv.layoutIfNeeded()
        view.layoutIfNeeded()
    }
}
