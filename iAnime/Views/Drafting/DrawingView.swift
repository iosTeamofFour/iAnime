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
    private var DrawingLayer : CAShapeLayer!
    
    
    private var StartPoint : CGPoint!
    private var EndPoint : CGPoint!
    
    
    private var IsDrawing = false
    private var ShouldDrawPoints : [LinePoint]?
    
    private var ctr : Int = 0
    private var pts = Array<CGPoint>(repeating: CGPoint.zero, count: 5)
    
    private(set) var CurrentLineColor : RGB = RGB(R:255,G:0,B:0)
    private(set) var CurrentLineWidth : CGFloat = 10
    override init(frame: CGRect) {
        super.init(frame: frame)
        UIColor.black.setStroke()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UIColor.black.setStroke()
    }
    
    func SetPaintingLineColor(_ rgb : RGB) {
        CurrentLineColor = rgb
    }
    
    func SetPaintingLineWidth(_ width : CGFloat)  {
        CurrentLineWidth = width
    }
    
    private func InitDrawingLayer() {
        DrawingLayer = CAShapeLayer()
        DrawingLayer.fillColor = UIColor.clear.cgColor
        DrawingLayer.strokeColor = CurrentLineColor.AsUIColor.cgColor
        DrawingLayer.lineWidth = CurrentLineWidth
        DrawingLayer.lineCap = .round
        layer.addSublayer(DrawingLayer)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        EndPoint = nil
        
        
        ctr = 0
        StartPoint = touch.location(in: self)
        
        pts[0] = StartPoint
        
        InitDrawingLayer()
        
        DrawingPath = UIBezierPath()
        DrawCircleAtEndPoint(StartPoint)
    }
    
    private func DrawCircleAtEndPoint(_ endPoint : CGPoint) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        if let coal = event?.coalescedTouches(for: touch), coal.count > 0 {
            for c in coal {
                ctr += 1
                pts[ctr] = c.location(in: self)
            }
        }
        else {
            ctr += 1
            pts[ctr] = touch.location(in: self)
        }
        TryPlotLine()
    }
    
    private func TryPlotLine() {
        if ctr == 4 {
            pts[3] = CGPoint(x: (pts[2].x + pts[4].x)/2.0, y:(pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
            
            DrawingPath?.move(to: pts[0])
            DrawingPath?.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])// add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
            DrawingLayer.path = DrawingPath?.cgPath
            // replace points and get ready to handle the next segment
            pts[0] = pts[3];
            pts[1] = pts[4];
            ctr = 1;
            
            EndPoint = pts[3]
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        DrawCircleAtEndPoint(EndPoint)
        ctr = 0

    }
    
}


