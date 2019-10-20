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
        imageView = RoundCornerUIImageView(6)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.widthAnchor.constraint(equalTo: widthAnchor).Activate()
        imageView.heightAnchor.constraint(equalTo: heightAnchor).Activate()
    }
}
