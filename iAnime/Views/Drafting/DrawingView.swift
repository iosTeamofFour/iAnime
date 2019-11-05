
import UIKit
import Foundation


class DrawingView: UIImageView {
    
    // -------- 绘制相关变量 ---------
    
    
    private var IsDrawing = false
    
    private var ctr : Int = 0
    private var pts = Array<CGPoint>(repeating: CGPoint.zero, count: 5)
    private var forces = Array<CGFloat>(repeating: 0, count: 5)
    
    private var lastForce : CGFloat = 1.0
    
    private(set) var CurrentLineColor : RGB = RGB(R:0,G:0,B:0)
    private(set) var CurrentLineWidth : CGFloat = 2.5
    
    private var CurrentDrawingCtx : CGContext?
    private var TouchingWithoutPen = true
    
    
    var CurrentToolType = UsingToolType.Pinching
    
    
    // ----------  历史记录回退相关变量 ------------
    
    private(set) var histories : [DrawingHistory] = []
    private var popedHistories : [DrawingHistory] = []
    
    private var ctrGroups : [CGPoint] = []
    private var forceGroups : [CGFloat] = []
    private var TouchingWithoutPenHistory : [Bool] = []
    
    // ---------- 颜色锚点和颜色标记点相关变量 --------------
    
    private var OneAnchorPoint : UIBezierPath?
    
    private(set) var anchors : Dictionary<Vector2,ColorAnchor> = [:]
    private(set) var hints : Dictionary<Vector2,ColorHint> = [:]
    
    
    
    // ---------- 与父VC通信相关变量 ---------------
    
    var draftingController : DraftingViewController!
    

    func SetPaintingLineColor(_ rgb : RGB) {
        CurrentLineColor = rgb
    }
    
    func SetPaintingLineWidth(_ width : CGFloat)  {
        CurrentLineWidth = width
    }
    
    private func NotifyVCEnableUndo() {
        draftingController.NotifyCanUndo()
    }
    
    private func NotifyVCEnableRedo() {
        draftingController.NotifyCanRedo()
    }
    
    private func NotifyVCDisableRedo() {
        popedHistories.removeAll()
        draftingController.NofityCanNotRedo()
    }
    
    
    
    // ------- 颜色锚点和颜色提示点相关绘制函数 -------------
    
    
    func DrawColorPoint( _ at : CGPoint,_ type : ColorPointType, _ color : RGB) {
        // 绘制颜色锚点/颜色提示点
        let
        up = CGPoint(x: at.x, y: at.y - 6),
        right = CGPoint(x: at.x + 6, y: at.y),
        down = CGPoint(x: at.x, y: at.y + 6),
        left = CGPoint(x: at.x - 6, y: at.y)

        let anchorLayer = CAShapeLayer(layer: layer)
        let currScaling = transform.a
        anchorLayer.frame = bounds
        anchorLayer.lineWidth = 3 * 1 / currScaling
        anchorLayer.fillColor = color.AsUIColor.cgColor
        anchorLayer.strokeColor = UIColor.white.cgColor
        
        switch type {
        case .Anchor:
            OneAnchorPoint = UIBezierPath()
            OneAnchorPoint?.move(to: up)
            OneAnchorPoint?.addLine(to: right)
            OneAnchorPoint?.addLine(to: down)
            OneAnchorPoint?.addLine(to: left)
            OneAnchorPoint?.close()
            OneAnchorPoint?.apply(CGAffineTransform(translationX: -at.x, y: -at.y))
            OneAnchorPoint?.apply(CGAffineTransform(scaleX: 1 / currScaling , y: 1 / currScaling))
            OneAnchorPoint?.apply(CGAffineTransform(translationX: at.x, y: at.y))
            anchorLayer.path = OneAnchorPoint?.cgPath
            anchors[at.AsVector2()] = ColorAnchor(color: color, point: at,path : OneAnchorPoint!, layer: anchorLayer)
            
            break
        case .Hint:
            OneAnchorPoint = UIBezierPath()
            OneAnchorPoint?.addArc(withCenter: at, radius: 5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            OneAnchorPoint?.apply(CGAffineTransform(translationX: -at.x, y: -at.y))
            OneAnchorPoint?.apply(CGAffineTransform(scaleX: 1 / currScaling , y: 1 / currScaling))
            OneAnchorPoint?.apply(CGAffineTransform(translationX: at.x, y: at.y))
            anchorLayer.path = OneAnchorPoint?.cgPath
            hints[at.AsVector2()] = ColorHint(color: color, point: at, path : OneAnchorPoint!, layer: anchorLayer)
            break
        }
        layer.addSublayer(anchorLayer)
    }
    
    func FixColorPointSize(_ currentScaling : CGFloat) {
        // 在画布进行伸缩的时候同步缩放颜色提示点和颜色锚点
        for (_,an) in anchors {
            let p = an.point
            let path = an.path
            path.apply(CGAffineTransform(translationX: -p.x, y: -p.y))
            path.apply(CGAffineTransform(scaleX: 1 / currentScaling, y: 1 / currentScaling))
            path.apply(CGAffineTransform(translationX: p.x, y: p.y))
            an.layer.lineWidth = an.layer.lineWidth / currentScaling
            an.layer.path = path.cgPath
        }
        
        for (_,an) in hints {
            let p = an.point
            let path = an.path

            path.apply(CGAffineTransform(translationX: -p.x, y: -p.y))
            path.apply(CGAffineTransform(scaleX: 1 / currentScaling, y: 1 / currentScaling))
            path.apply(CGAffineTransform(translationX: p.x, y: p.y))
            an.layer.lineWidth = an.layer.lineWidth / currentScaling
            an.layer.path = path.cgPath
        }
    }
    
    private func TryEraseColorPoint(_ near : CGPoint) {
        // 橡皮擦功能，尝试去除附近的锚点
        let nearVec = near.AsVector2()
        
        for (point,anchor) in anchors {
            if Vector2.distance(point, nearVec) < 5 {
                anchor.layer.removeFromSuperlayer()
                anchors.removeValue(forKey: point)
            }
        }
        
        for (point,hint) in hints {
            if Vector2.distance(point, nearVec) < 5 {
                hint.layer.removeFromSuperlayer()
                hints.removeValue(forKey: point)
            }
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ----------- 跟踪手指绘制相关函数 ---------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            guard let touch = touches.first else { return }
            
            switch CurrentToolType {
            case .ColorAnchor:
                DrawColorPoint(touch.location(in: self), .Anchor, CurrentLineColor)
                break
            case .ColorHint:
                DrawColorPoint(touch.location(in: self), .Hint, CurrentLineColor)
                break
            case .Drawing:
                NotifyVCDisableRedo()
                
                ctr = 0
                TrackTouch(touch, touch.location(in: self), touch.force, touch.maximumPossibleForce)
                
                UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
                CurrentDrawingCtx = UIGraphicsGetCurrentContext()
                CurrentLineColor.AsUIColor.setStroke()
                let lm = image ?? UIImage()
                lm.draw(in: bounds)
                break
            case .Eraser:
                break
            case .Pinching:
                break
            }
        
    }
    
    private func TrackTouch(_ touchEv : UITouch,_ touchPoint : CGPoint, _ force : CGFloat, _ maxForce : CGFloat) {
        pts[ctr] = touchPoint
        ctrGroups.append(pts[ctr])
        
        forces[ctr] = GetForce(touchEv,force, maxForce)
        forceGroups.append(forces[ctr])
        
        TouchingWithoutPenHistory.append(TouchingWithoutPen)
    }
    
    private func GetForce(_ touchEv : UITouch,_ force : CGFloat, _ maxForce : CGFloat) -> CGFloat {
        if force == 0 && touchEv.type != .pencil {
            TouchingWithoutPen = true
            return CurrentLineWidth
        }
        TouchingWithoutPen = false
        let maxF = CGFloat((0.1...3).clamp(Double(maxForce)))
        let clampedF = (0.1...maxF).clamp(force)
        
        return clampedF
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
            guard let touch = touches.first else { return }
            
            switch CurrentToolType {
            case .Eraser:
                TryEraseColorPoint(touch.location(in: self))
                break
            case .Drawing:
                if let coal = event?.coalescedTouches(for: touch), coal.count > 0 {
                    for c in coal {
                        ctr += 1
                        TrackTouch(c,c.location(in: self), c.force, c.maximumPossibleForce)
                        TryPlotLine()
                    }
                }
                else {
                    ctr += 1
                    TrackTouch(touch,touch.location(in: self), touch.force, touch.maximumPossibleForce)
                    TryPlotLine()
                }
                image = UIGraphicsGetImageFromCurrentImageContext()
                break
            default:
                break
            }
        
    }
    

    func HandleRedo() -> Bool {
        if popedHistories.count > 0 {
            let next = popedHistories.popLast()!
            histories.append(next)
            
            let lm = image ?? UIImage()
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            CurrentDrawingCtx = UIGraphicsGetCurrentContext()
            
            lm.draw(in: bounds)
            let lastWidth = CurrentLineWidth
            
            CurrentLineWidth = next.UsedPenLineWidth
            let oneCtrGroup = next.ControlPoints
            let oneForceGroup = next.Forces
            let touchMode = next.TouchingMode
            CurrentDrawingCtx?.setStrokeColor(next.UsedColor.AsUIColor.cgColor)
            CurrentLineWidth = next.UsedPenLineWidth
            ctr = 0
            pts[ctr] = oneCtrGroup[0]
            forces[ctr] = oneForceGroup[0]
            for j in 1..<oneCtrGroup.count {
                ctr += 1
                TouchingWithoutPen = touchMode[j]
                pts[ctr] = oneCtrGroup[j]
                forces[ctr] = oneForceGroup[j]
                TryPlotLine()
            }
            CurrentLineWidth = lastWidth
            NotifyVCEnableUndo()
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return popedHistories.count > 0
    }
    
    func HandleUndo() -> Bool {
        // 重绘之前所有路径点
        if histories.count > 0 {
            popedHistories.append(histories.popLast()!)
            ReplayDrawingHistories(histories)
        }
        return histories.count > 0
    }
    
    func ReplayDrawingHistories(_ histories : [DrawingHistory]) {
        self.histories = histories
        
        pts = Array<CGPoint>(repeating: CGPoint.zero, count: 5)
        forces = Array<CGFloat>(repeating: 1, count: 5)
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        CurrentDrawingCtx = UIGraphicsGetCurrentContext()
        
        let lastWidth = CurrentLineWidth
        
        for i in 0..<histories.count {
            let oneCtrGroup = histories[i].ControlPoints
            let oneForceGroup = histories[i].Forces
            let touchMode = histories[i].TouchingMode
            CurrentLineWidth = histories[i].UsedPenLineWidth
            CurrentDrawingCtx?.setStrokeColor(histories[i].UsedColor.AsUIColor.cgColor)
            CurrentLineWidth = histories[i].UsedPenLineWidth
            ctr = 0
            pts[ctr] = oneCtrGroup[0]
            forces[ctr] = oneForceGroup[0]
            for j in 1..<oneCtrGroup.count {
                ctr += 1
                TouchingWithoutPen = touchMode[j]
                pts[ctr] = oneCtrGroup[j]
                forces[ctr] = oneForceGroup[j]
                TryPlotLine()
            }
        }
        CurrentLineWidth = lastWidth
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        NotifyVCEnableRedo()
    }
    
    private func TryPlotLine() {
        
        if ctr == 4 {
            
            CurrentDrawingCtx?.setShouldAntialias(true)
            CurrentDrawingCtx?.setAllowsAntialiasing(true)
            
            var totalForce = (0.4 * forces[2] + 0.3 * forces[3] + 0.3 * forces[4]) * 0.3 + lastForce * 0.7
            
            if totalForce > 1.5 {
                totalForce = 1.5
            }
            
            if TouchingWithoutPen {
                totalForce = 1
            }
            
            let lineWidth = CurrentLineWidth * totalForce
            lastForce = totalForce

            CurrentDrawingCtx?.setLineWidth(lineWidth)
            CurrentDrawingCtx?.setLineCap(.round)
            
            pts[3] = CGPoint(x: (pts[2].x + pts[4].x)/2.0, y:(pts[2].y + pts[4].y)/2.0)
            
            CurrentDrawingCtx?.move(to: pts[0])
            CurrentDrawingCtx?.addCurve(to: pts[3], control1: pts[1], control2: pts[2])
            CurrentDrawingCtx?.strokePath()
            
            // replace points and get ready to handle the next segment
            pts[0] = pts[3] // 起始点 0
            pts[1] = pts[4] // 第一个控制点 1  第二个控制点2  3结束点 4下一轮的第一个控制点
            ctr = 1
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            
            switch CurrentToolType {
            case .Drawing:
                ctr = 0
                UIGraphicsEndImageContext()
                
                histories.append(DrawingHistory(ControlPoints: ctrGroups, Forces: forceGroups, TouchingMode: TouchingWithoutPenHistory, UsedColor: CurrentLineColor, UsedPenLineWidth : CurrentLineWidth))
                
                ctrGroups.removeAll()
                forceGroups.removeAll()
                TouchingWithoutPenHistory.removeAll()
                
                for i in 0..<5 {
                    forces[i] = 0
                }
                
                NotifyVCEnableUndo()
                break
            default:
                break
            }
        
    }
}
