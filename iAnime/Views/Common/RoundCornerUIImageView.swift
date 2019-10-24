//
//  RoundCornerUIImageView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class RoundCornerUIImageView: UIImageView {

    @IBInspectable var radius : CGFloat = 4.0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = radius
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ cornerRadius : CGFloat) {
        self.init(frame: CGRect.zero)
        radius = cornerRadius
        self.layer.cornerRadius = radius
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}
