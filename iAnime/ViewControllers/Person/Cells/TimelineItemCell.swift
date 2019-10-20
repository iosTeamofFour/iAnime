//
//  TimelineItemCell.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class TimelineItemCell: UICollectionViewCell {
    
    var imageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame:CGRect) {
        super.init(frame: frame)
        InitSubview()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        InitSubview()
    }
    
    private func InitSubview() {
        imageView = RoundCornerUIImageView(4)
        imageView.topAnchor.constraint(equalTo: topAnchor).Activate()
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).Activate()
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).Activate()
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).Activate()
    }
}
