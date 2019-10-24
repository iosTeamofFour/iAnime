//
//  DrawingView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/24.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import Foundation

class DrawingView: UIView {
    
    // -------- 绘制相关变量 ---------
    
    private var DrawingPath: UIBezierPath?
    private var StartPoint : CGPoint!
    private var EndPoint : CGPoint!
    private var PanRecognizer : UIPanGestureRecognizer!
    
    
    private var A : CGPoint = CGPoint.zero
    private var B : CGPoint = CGPoint.zero
    private var C : CGPoint = CGPoint.zero
    private var D : CGPoint = CGPoint.zero
    
    private var prevA : CGPoint = CGPoint.zero
    private var prevB : CGPoint = CGPoint.zero
    private var prevC : CGPoint = CGPoint.zero
    private var prevD : CGPoint = CGPoint.zero
    
    private var CurrentDrawingPoints : [LinePoint] = []
    private var velocities : [CGFloat] = []
    
    private var DrawingLayer : CAShapeLayer!
    
    private var IsDrawing = false
    private var ShouldDrawPoints : [LinePoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UIColor.black.setStroke()
        //        InitPanRecognizer()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UIColor.black.setStroke()
        //        InitPanRecognizer()
    }
    
    //    private func InitPanRecognizer() {
    //        PanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(OnMovingPen))
    //        addGestureRecognizer(PanRecognizer)
    //        isUserInteractionEnabled = true
    //    }
    
    
    
    private func GetLineWidth(_ recognizer : UIPanGestureRecognizer) -> CGFloat {
        let velocityLength = recognizer.velocity(in: self).AsVector2().length
        var size = velocityLength / 166.0
        size = CGFloat((1.0...40.0).clamp(Double(size)))
        
        if velocities.count > 1 {
            size = size * 0.2 + velocities[velocities.count - 1] * 0.8
        }
        velocities.append(size)
        return size
    }
    private func GetCurrentLinePoint(_ location : CGPoint) -> LinePoint {
        //        let velocity = GetLineWidth(PanRecognizer)
        return LinePoint(Position: location, Width: 2)
    }
    
    
    // A simple way to smooth drafting curves.
    
    private func CalculateSmoothLinePoints() -> [LinePoint]? {
        
        if CurrentDrawingPoints.count > 2 {
            var smoothPoints : [LinePoint] = []
            for i in 2..<CurrentDrawingPoints.count {
                let prev2Point = CurrentDrawingPoints[i-2]
                let prev1Point = CurrentDrawingPoints[i-1]
                let currentPoint = CurrentDrawingPoints[i]
                
                
                
                
                let midPoint1 = CGPoint.MidPoint(prev1Point.Position, prev2Point.Position).AsVector2()
                let midPoint2 = CGPoint.MidPoint(prev1Point.Position, currentPoint.Position).AsVector2()
                
                let segmentDistance : CGFloat = 2
                let midPointDistance = Vector2.distance(midPoint1, midPoint2)
                let numberOfSegments = min(128, max(floorf(Float(midPointDistance / segmentDistance)),32))
                
                var t : CGFloat = 0.0
                let step : CGFloat = 1.0 / CGFloat(numberOfSegments)
                
                for _ in 0..<Int(numberOfSegments) {
                    let k1 = midPoint1.multiply(pow(1-t, 2))
                    let k2 = prev1Point.Position.AsVector2().multiply(2.0 * (1-t) * t)
                    let k3 = midPoint2.multiply(t * t)
                    let newPointPos = k1 + k2 + k3
                    let newPointWidth = pow(1-t, 2) * (0.5 * (prev1Point.Width + prev2Point.Width)) + 2.0 * (1-t) * t * prev1Point.Width + t * t * ((currentPoint.Width + prev1Point.Width) * 0.5)
                    
                    let newPoint = LinePoint(Position: newPointPos.AsCGPoint(), Width: newPointWidth)
                    
                    smoothPoints.append(newPoint)
                    t += step
                }
                
            }
            CurrentDrawingPoints.removeSubrange(0...CurrentDrawingPoints.count-2)
            return smoothPoints
        }
        return nil
    }
    
    
    
    private func AppendCurrentTouchPoint( _ touch : UITouch,_ threshold : CGFloat = 0.25) {
        let point = touch.location(in: self)
        let eps = threshold
        if CurrentDrawingPoints.count > 0 {
            let distance = Vector2.distance(point.AsVector2(), CurrentDrawingPoints.last!.Position.AsVector2())
            if distance < eps {
                return
            }
        }
        let linePoint = GetCurrentLinePoint(point)
        CurrentDrawingPoints.append(linePoint)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        StartPoint = nil
        EndPoint = nil
        DrawingPath = nil
        DrawingLayer = nil
        
        velocities.removeAll()
        CurrentDrawingPoints.removeAll()
        
        
        StartPoint = touch.location(in: self)
        
        DrawingLayer = CAShapeLayer()
        DrawingLayer.fillColor = UIColor.clear.cgColor
        DrawingLayer.strokeColor = UIColor.black.cgColor
        DrawingLayer.lineWidth = 2
        
        DrawingPath = UIBezierPath()
        DrawingPath?.lineWidth = 2
        
        layer.addSublayer(DrawingLayer)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let point = touches.first!.location(in: self)
        //
        //        let eps : CGFloat = 1.5
        //        if CurrentDrawingPoints.count > 0 {
        //            let distance = Vector2.distance(point.AsVector2(), CurrentDrawingPoints.last!.Position.AsVector2())
        //            if distance < eps {
        //                return
        //            }
        //        }
        //
        //        let linePoint = GetCurrentLinePoint(point)
        //        CurrentDrawingPoints.append(linePoint)
        //        setNeedsDisplay()
        
        
        guard let touch = touches.first else { return }
        
        
        if let coalesced = event?.coalescedTouches(for: touch), coalesced.count > 0 {
            for coalTouch in coalesced {
                CurrentDrawingPoints.append(LinePoint.init(Position: coalTouch.location(in: self), Width: 2))
            }
            if !IsDrawing {
                if CurrentDrawingPoints.count > 20 {
                    print("\(CurrentDrawingPoints.count)   直接渲染  \(CurrentDrawingPoints.count)")
                    for ptr in CurrentDrawingPoints {
                        self.DrawingPath?.move(to: self.StartPoint)
                        self.EndPoint = ptr.Position
                        self.DrawingPath?.addLine(to: self.EndPoint)
                        self.StartPoint = self.EndPoint
                    }
                    self.DrawingLayer.path = self.DrawingPath?.cgPath
                    CurrentDrawingPoints.removeAll()
                }
                else {
                    self.ShouldDrawPoints = self.CalculateSmoothLinePoints()
                    print("\(CurrentDrawingPoints.count)   进行平滑   \(ShouldDrawPoints?.count)")
                    if let should = self.ShouldDrawPoints {
                        
                        for ptr in should {
                            self.DrawingPath?.move(to: self.StartPoint)
                            self.EndPoint = ptr.Position
                            self.DrawingPath?.addLine(to: self.EndPoint)
                            self.StartPoint = self.EndPoint
                        }
                        self.DrawingLayer.path = self.DrawingPath?.cgPath
//                        CurrentDrawingPoints.removeAll()
                    }
                }
            }
        }
            
        else {
            AppendCurrentTouchPoint(touch)
            if !IsDrawing {
                self.ShouldDrawPoints = self.CalculateSmoothLinePoints()
                if let should = self.ShouldDrawPoints {
                    
                    for ptr in should {
                        self.DrawingPath?.move(to: self.StartPoint)
                        self.EndPoint = ptr.Position
                        self.DrawingPath?.addLine(to: self.EndPoint)
                        self.StartPoint = self.EndPoint
                    }
                    self.DrawingLayer.path = self.DrawingPath?.cgPath
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 清除掉velocity和当前正在绘画点
        //        velocities.removeAll()
        //        CurrentDrawingPoints.removeAll()
        //        setNeedsDisplay()
        

        
    }
    
    
    //        IsDrawing = true
    //        if let smoothLines = ShouldDrawPoints {
    //            //            for i in 1..<smoothLines.count {
    //            if StartPoint == nil {
    //                StartPoint = smoothLines.first!.Position
    //            }
    //            drawingPath.move(to: StartPoint)
    //            drawingPath.addLine(to: smoothLines.last!.Position)
    //            drawingPath.lineWidth = 10
    //            //            }
    //            StartPoint = smoothLines.last!.Position
    //            drawingPath.stroke()
    //        }
    //        IsDrawing = false
    
    
    
    
    //        StartPoint = touches.first!.location(in: self)
    //        if DrawingPath == nil {
    //            DrawingPath = UIBezierPath()
    //            DrawingPath?.lineWidth = 2
    //        }
    
    //        for touch in touches {
    //            for coalescedTouch in event!.coalescedTouches(for: touch)! {
    //                DrawingPath?.move(to: StartPoint)
    //                EndPoint = coalescedTouch.location(in: self)
    //                DrawingPath?.addLine(to: EndPoint)
    //                StartPoint = EndPoint
    //                setNeedsDisplay()
    //            }
    //        }
    
    //        StartPoint = nil
    //        EndPoint = nil
}


public extension CGPoint {
    public static func MidPoint(_ lhs : CGPoint, _ rhs : CGPoint) -> CGPoint {
        return CGPoint(x: (lhs.x + rhs.x)/2, y: (lhs.y + rhs.y)/2)
    }
    
}
