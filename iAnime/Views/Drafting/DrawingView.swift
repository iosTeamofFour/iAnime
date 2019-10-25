
import UIKit
import Foundation


struct DrawingHistory {
    var ControlPoints : [CGPoint]
    var Forces : [CGFloat]
    var TouchingMode : [Bool]
    var UsedColor : RGB
}

class DrawingView: UIImageView {
    
    // -------- 绘制相关变量 ---------
    
    
    private var IsDrawing = false
    private var ShouldDrawPoints : [LinePoint]?
    
    private var ctr : Int = 0
    private var pts = Array<CGPoint>(repeating: CGPoint.zero, count: 5)
    private var forces = Array<CGFloat>(repeating: 0, count: 5)
    
    private var lastForce : CGFloat = 1.0
    
    
    
    private(set) var CurrentLineColor : RGB = RGB(R:255,G:0,B:0)
    private(set) var CurrentLineWidth : CGFloat = 2.5
    
    private var CurrentDrawingCtx : CGContext?
    

    private var TouchingWithoutPen = true
    
    
    // ----------  历史记录回退相关变量 ------------
    
    private var histories : [DrawingHistory] = []
    
    private var ctrGroups : [CGPoint] = []
    private var forceGroups : [CGFloat] = []
    private var TouchingWithoutPenHistory : [Bool] = []
    

    func SetPaintingLineColor(_ rgb : RGB) {
        CurrentLineColor = rgb
    }
    
    func SetPaintingLineWidth(_ width : CGFloat)  {
        CurrentLineWidth = width
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let lm = image ?? UIImage()
        
        ctr = 0
        
        
        TrackTouch(touch, touch.location(in: self), touch.force, touch.maximumPossibleForce)
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        CurrentDrawingCtx = UIGraphicsGetCurrentContext()
        CurrentLineColor.AsUIColor.setStroke()
        lm.draw(in: bounds)
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
        
        if let coal = event?.coalescedTouches(for: touch), coal.count > 0 {
            for c in coal {
                ctr += 1
                TrackTouch(c,c.location(in: self), c.force, c.maximumPossibleForce)
                TryPlotLine()
            }
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
            
        else {
            ctr += 1
            TrackTouch(touch,touch.location(in: self), touch.force, touch.maximumPossibleForce)
            TryPlotLine()
            
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    
    func HandleUndo() {
        
        // 重绘之前所有路径点
        histories.popLast()
        
        pts = Array<CGPoint>(repeating: CGPoint.zero, count: 5)
        forces = Array<CGFloat>(repeating: 1, count: 5)
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        CurrentDrawingCtx = UIGraphicsGetCurrentContext()
        
        
        for i in 0..<histories.count {
            let oneCtrGroup = histories[i].ControlPoints
            let oneForceGroup = histories[i].Forces
            let touchMode = histories[i].TouchingMode
            CurrentDrawingCtx?.setStrokeColor(histories[i].UsedColor.AsUIColor.cgColor)
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
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
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
        ctr = 0
        UIGraphicsEndImageContext()
        
//        historyCtr.append(ctrGroups)
//        historyForces.append(forceGroups)
//        historyColor.append(CurrentLineColor)
        
        
        histories.append(DrawingHistory(ControlPoints: ctrGroups, Forces: forceGroups, TouchingMode: TouchingWithoutPenHistory, UsedColor: CurrentLineColor))
        
        ctrGroups.removeAll()
        forceGroups.removeAll()
        TouchingWithoutPenHistory.removeAll()
        
        for i in 0..<5 {
            forces[i] = 0
        }
    }
}
