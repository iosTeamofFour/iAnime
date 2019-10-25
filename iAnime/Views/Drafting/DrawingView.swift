////
////  DrawingView.swift
////  iAnime
////
////  Created by NemesissLin on 2019/10/24.
////  Copyright © 2019 NemesissLin. All rights reserved.
////
//
//import UIKit
//import Foundation
//
//struct LineSegment {
//    var pa : CGPoint
//    var pb : CGPoint
//}
//
//
//class DrawingView: UIView {
//
//    // -------- 绘制相关变量 ---------
//
//    private var DrawingPath: UIBezierPath?
//    private var DrawingLayer : CAShapeLayer!
//
//
//    private var StartPoint : CGPoint!
//    private var EndPoint : CGPoint!
//
//
//    private var IsDrawing = false
//    private var ShouldDrawPoints : [LinePoint]?
//
//    private var ctr : Int = 0
//    private var bufferIdx : Int = 0
//    private var pts = Array<CGPoint>(repeating: CGPoint.zero, count: 5)
//    private var pointsBuffer = Array<CGPoint>(repeating: CGPoint.zero, count: 100)
//    private var IsFirstTouch = false
//    private var lastSegmentOfPrev : LineSegment?
//
//
//    private(set) var CurrentLineColor : RGB = RGB(R:255,G:0,B:0)
//    private(set) var CurrentLineWidth : CGFloat = 3
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        UIColor.black.setStroke()
//
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        UIColor.black.setStroke()
//    }
//
//    func SetPaintingLineColor(_ rgb : RGB) {
//        CurrentLineColor = rgb
//    }
//
//    func SetPaintingLineWidth(_ width : CGFloat)  {
//        CurrentLineWidth = width
//    }
//
//    private func InitDrawingLayer() {
//        DrawingLayer = CAShapeLayer()
//        DrawingLayer.fillColor = CurrentLineColor.AsUIColor.cgColor
//        DrawingLayer.strokeColor = CurrentLineColor.AsUIColor.cgColor
//        DrawingLayer.lineCap = .round
//        layer.addSublayer(DrawingLayer)
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//
//        EndPoint = nil
//        ctr = 0
//        bufferIdx = 0
//
//        StartPoint = touch.location(in: self)
//        pts[0] = StartPoint
//
//        IsFirstTouch = true
//
//        InitDrawingLayer()
//        DrawingPath = UIBezierPath()
//        DrawCircleAtEndPoint(StartPoint)
//    }
//
//    private func DrawCircleAtEndPoint(_ endPoint : CGPoint) {
//
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        guard let touch = touches.first else { return }
//        if let coal = event?.coalescedTouches(for: touch), coal.count > 0 {
//            for c in coal {
//                ctr += 1
//                pts[ctr] = c.location(in: self)
//                TryPlotLine()
//            }
//        }
//        else {
//            ctr += 1
//            pts[ctr] = touch.location(in: self)
//            TryPlotLine()
//        }
//
//    }
//
//    private func TryPlotLine() {
//        if ctr == 4 {
//            pts[3] = CGPoint(x: (pts[2].x + pts[4].x)/2.0, y:(pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
//
//            for i in 0..<4 {
//                pointsBuffer[bufferIdx + i] = pts[i]
//            }
//
//            bufferIdx += 4
//
//            var ls : [LineSegment] = []
//
//            for i in stride(from: 0, to: bufferIdx, by: 4) {
//                if IsFirstTouch {
//                    ls.append(LineSegment(pa: pointsBuffer[0], pb: pointsBuffer[0]))
//                    DrawingPath?.move(to: ls[0].pa)
//                    IsFirstTouch = false
//                }
//
//                else {
//                    ls.append(lastSegmentOfPrev!)
//                }
//
//                let lambda1 = CurrentLineWidth / Vector2.distance(pointsBuffer[i].AsVector2(), pointsBuffer[i+1].AsVector2())
//                let lambda2 = CurrentLineWidth / Vector2.distance(pointsBuffer[i+1].AsVector2(), pointsBuffer[i+2].AsVector2())
//                let lambda3 = CurrentLineWidth / Vector2.distance(pointsBuffer[i+2].AsVector2(), pointsBuffer[i+3].AsVector2())
//
//                ls.append(lineSegmentPerpendicularTo(pointsBuffer[i], pointsBuffer[i+1], lambda1))
//                ls.append(lineSegmentPerpendicularTo(pointsBuffer[i+1], pointsBuffer[i+2], lambda2))
//                ls.append(lineSegmentPerpendicularTo(pointsBuffer[i+2], pointsBuffer[i+3], lambda3))
//
//                DrawingPath?.move(to: ls[0].pa)
//                DrawingPath?.addCurve(to: ls[3].pa, controlPoint1: ls[1].pa, controlPoint2: ls[2].pa)
//                DrawingPath?.addLine(to: ls[3].pb)
//                DrawingPath?.addCurve(to: ls[0].pb, controlPoint1: ls[2].pb, controlPoint2: ls[1].pb)
//                DrawingPath?.close()
//                DrawingLayer.path = DrawingPath?.cgPath
//                lastSegmentOfPrev = ls[3]
//            }
//
////            DrawingPath?.move(to: pts[0])
////            DrawingPath?.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])// add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
////            replace points and get ready to handle the next segment
//            pts[0] = pts[3];
//            pts[1] = pts[4];
//            bufferIdx = 0
//            ctr = 1;
//            EndPoint = pts[3]
//        }
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        ctr = 0
//    }
//
//
//    private func lineSegmentPerpendicularTo(_ p1 : CGPoint, _ p0 : CGPoint, _ lambda: CGFloat) -> LineSegment {
//        let dx = p1.x - p0.x
//        let dy = p1.y - p0.y
//
//        let xa = p1.x + (lambda/2) * dy
//        let ya = p1.y - (lambda/2) * dx
//
//        let xb = p1.x - (lambda/2) * dy
//        let yb = p1.y + (lambda/2) * dx
//
//        return LineSegment(pa: CGPoint(x: xa, y: ya), pb: CGPoint(x: xb, y: yb))
//    }
//}
//
//


//
//  DrawingView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/24.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import Foundation

class DrawingView: UIImageView {
    
    // -------- 绘制相关变量 ---------
    
    
    private var IsDrawing = false
    private var ShouldDrawPoints : [LinePoint]?
    
    private var ctr : Int = 0
    private var pts = Array<CGPoint>(repeating: CGPoint.zero, count: 5)
    private var forces = Array<CGFloat>(repeating: 0, count: 5)
    
    private var lastForce : CGFloat = 1.0
    
    private var historyCtr : [[CGPoint]] = []
    private var historyForces : [[CGFloat]] = []
    
    private var ctrGroups : [CGPoint] = []
    private var forceGroups : [CGFloat] = []
    
    private var historyColor : [RGB] = []
    
    
    private(set) var CurrentLineColor : RGB = RGB(R:255,G:0,B:0)
    private(set) var CurrentLineWidth : CGFloat = 2.5
    
    private var CurrentDrawingCtx : CGContext?
    
    private var TouchingWithoutPen = true

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

        historyCtr.popLast()
        historyForces.popLast()
        historyColor.popLast()
        
        pts = Array<CGPoint>(repeating: CGPoint.zero, count: 5)
        forces = Array<CGFloat>(repeating: 1, count: 5)
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        CurrentDrawingCtx = UIGraphicsGetCurrentContext()
        
        for i in 0..<historyCtr.count {
            let oneCtrGroup = historyCtr[i]
            let oneForceGroup = historyForces[i]
            CurrentDrawingCtx?.setStrokeColor(historyColor[i].AsUIColor.cgColor)
            ctr = 0
            pts[ctr] = oneCtrGroup[0]
            forces[ctr] = oneForceGroup[0]
            for j in 1..<oneCtrGroup.count {
                ctr += 1
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
            
            var lineWidth = CurrentLineWidth * totalForce
            
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
        
        historyCtr.append(ctrGroups)
        historyForces.append(forceGroups)
        historyColor.append(CurrentLineColor)
        
        ctrGroups.removeAll()
        forceGroups.removeAll()
        for i in 0..<5 {
            forces[i] = 0
        }
    }
}


