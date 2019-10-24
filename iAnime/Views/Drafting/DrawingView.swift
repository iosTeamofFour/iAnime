//
//  DrawingView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/24.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class DrawingView: UIView {

    // -------- 绘制相关变量 ---------
    
    private var DrawingPath: UIBezierPath?
    private var StartPoint : CGPoint!
    private var EndPoint : CGPoint!
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        DrawingPath?.stroke()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        StartPoint = touches.first!.location(in: self)
        if DrawingPath == nil {
            DrawingPath = UIBezierPath()
            DrawingPath?.lineWidth = 2
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            for coalescedTouch in event!.coalescedTouches(for: touch)! {
                DrawingPath?.move(to: StartPoint)
                EndPoint = coalescedTouch.location(in: self)
                DrawingPath?.addLine(to: EndPoint)
                StartPoint = EndPoint
                setNeedsDisplay()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        StartPoint = nil
        EndPoint = nil
    }

}
