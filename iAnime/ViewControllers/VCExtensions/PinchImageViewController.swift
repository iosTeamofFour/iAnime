//
//  PinchImageViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/17.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class PinchImageViewController: ReturnArrowViewController {
    
    // 当前显示的imageView
    var imageView: UIImageView!
    
    // 正在加载露出半截的imageView
    var nextImageView : UIImageView?
    
    // imageView父容器
    @IBOutlet weak var scroller: UIScrollView!
    
    
    // 是否正在执行最大最小放大倍数限制操作(因为是自己模拟的缩放事件, 开了线程, 不应该被其他触摸事件打断)
    private var IsDoingOverScale = false
    
    // 最后一次双指缩放的中心点, 给 Pinch .ended时的限制最大最小缩放比例的回缩函数用的
    private var LastScaleCenterPoint : CGPoint = CGPoint.zero
    
    // 待加载的Images
    var Images : [UIImage] = []

    
    // 加载完毕的ImageViews
    private(set) var ImageViews : Dictionary<Int,UIImageView> = [:]
    
    // 当前展示的Image在数组中的下标
    private(set) var CurrentPresentImageIndex = -1
    private(set) var NextImageViewIndex = -1
    
    // 手势识别控件
    private var PinchGestureRecognizer : UIPinchGestureRecognizer!
    
    private var PanGestureRecognizer : UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitGestureRecognizer()
        let iv = LoadImage(0)
        PresentImage(iv, 0)
    }
    
    private func InitGestureRecognizer() {
        PinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(OnImageViewPinch(_:)))
        PanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(OnImageViewPan(_:)))
    }
    
    private func LoadImage(_ index : Int) -> UIImageView {
        if !Images.InRange(index) {
            // 不在数组中, 拒绝加载.
            fatalError("Index out of range!")
        }
        
        // 主要ImageViews起到一个缓存的作用, 图片被用户划掉再划回来的时候就不需要再初始化UIImage对象进行加载, 直接可以用。
        var iv : UIImageView!
        if let _iv = ImageViews[index] {
            
            iv = _iv
        }
        else {
            let image = Images[index]
            let _iv = UIImageView()
            _iv.image = image
            _iv.isUserInteractionEnabled = true
            ImageViews[index] = _iv
            iv = _iv
        }
        
        let ivSize = iv.GetCGSizeInAspectFit(view.bounds.size)
        let y = (view.frame.size.height - ivSize!.height)/2
        let x = (view.frame.size.width - ivSize!.width) / 2
        scroller.addSubview(iv)
        iv.frame = CGRect(x: x, y: y, width: ivSize!.width, height: ivSize!.height)
        return iv
    }
    
    private func PresentImage(_ iv: UIImageView, _ index :Int) {
        CurrentPresentImageIndex = index
//        iv.frame.origin.x = 0
        imageView = iv
//        imageView.layoutIfNeeded()
        print(imageView.frame)
        AttachGestureRecognizerToImageView(iv)
    }
    
    // 为当前imageView添加/移除手势识别器
    
    private func AttachGestureRecognizerToImageView(_ iv : UIImageView) {
        iv.addGestureRecognizer(PinchGestureRecognizer)
        iv.addGestureRecognizer(PanGestureRecognizer)
    }
    
    private func DetachGestureRecognizerFromImageView(_ iv:UIImageView) {
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
                    ivToScale.transform = self.ComputeScaleMatrix(centerPoint, CGFloat(stepLength), ivToScale,nil)
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
                if ivMinX == 0 && CurrentPresentImageIndex == 0 && trans.x > 0 {
                    trans.x = 0
                }
                // 右边贴边了, 又想向←移动, 又不能切下一张图，取消掉此次的X
                if ivMaxX == view.frame.width && CurrentPresentImageIndex == Images.count-1 && trans.x < 0 {
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
                    nextImageView?.frame.origin.x += realTransX
                    
                    ivMinX += realTransX
                    ivMaxX += realTransX
                    
                    if imageView.frame.minX >= 0 && trans.x > 0 && nextImageView == nil && CurrentPresentImageIndex - 1 >= 0 {
                        // 加载上一张
                            nextImageView = LoadImage(CurrentPresentImageIndex - 1)
                            NextImageViewIndex = CurrentPresentImageIndex - 1
                            nextImageView?.frame.origin.x = ivMinX - nextImageView!.frame.width - 10
                    }
                    else if imageView.frame.maxX <= view.frame.width && trans.x < 0 && nextImageView == nil && CurrentPresentImageIndex + 1 < Images.count {
                        // 加载下一张
                            nextImageView = LoadImage(CurrentPresentImageIndex + 1)
                            NextImageViewIndex = CurrentPresentImageIndex + 1
                            nextImageView?.frame.origin.x = ivMaxX + 10
                    }
                    else if nextImageView == nil {
                         // 不是加载图片，只是单纯需要贴边了，那就强行要求图片靠边。
                        SnapImageViewToEdges()
                    }
                }
                
                // 处理Y 轴移动，注意正在加载下一张图的过程中不再响应当前图片的Y移动
                
                if ivMinY <= 0 && ivMaxY >= view.frame.height && nextImageView == nil{
                    let realTransY = trans.y * imageView.transform.d
                    imageView.frame.origin.y += realTransY
                }
                
                sender.setTranslation(CGPoint.zero, in: imageView)
                
                // 确保对frame的改动已经生效。
                imageView.layoutIfNeeded()
                nextImageView?.layoutIfNeeded()
                view.layoutIfNeeded()
            }
            else if sender.state == .ended {
                if nextImageView == nil {
                    SnapImageViewToEdges()
                }
                else {
                    if abs(nextImageView!.frame.minX) < (3*view.frame.width/4) {
                        // 彻底完成对新图的加载
                        
                        let IsNext = NextImageViewIndex > CurrentPresentImageIndex
                        let OldImageViewOffsetX = IsNext ? -imageView.frame.maxX : view.frame.width - imageView.frame.minX
                        UIView.animate(withDuration: 0.15, animations: {
                            self.nextImageView?.frame.origin.x = 0
                            self.imageView.frame.origin.x += OldImageViewOffsetX
                        }, completion: {
                            _ in
                            self.imageView.removeFromSuperview()
                            self.DetachGestureRecognizerFromImageView(self.imageView)
                            self.PresentImage(self.nextImageView!, self.NextImageViewIndex)
                            self.nextImageView = nil
                            
                        })
                    }
                    else {
                        // 还原当前视图  去除上一张图:
                        let IsNext = NextImageViewIndex > CurrentPresentImageIndex
                        var OldImageViewOffsetX : CGFloat = 0
                        
                        if let nv = nextImageView {
                            OldImageViewOffsetX = IsNext ? view.frame.width - nv.frame.minX : -nv.frame.maxX
                        }
                        
                        UIView.animate(withDuration: 0.15, animations: {
                            self.nextImageView?.frame.origin.x += OldImageViewOffsetX
                            self.SnapImageViewToEdges()
                        }, completion: {
                            _ in
                            self.nextImageView?.removeFromSuperview()
                            self.nextImageView = nil
                        })
                    }
                }
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
        }
        if ivMaxX < view.frame.width {
            imageView.frame.origin.x += view.frame.width - ivMaxX
        }
        if ivMinY > 0 {
            imageView.frame.origin.y = 0
        }
        if ivMaxY < view.frame.height {
            imageView.frame.origin.y += view.frame.height - ivMaxY
        }
        
        imageView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
}
