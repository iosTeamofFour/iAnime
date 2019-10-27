//
//  LabelItem.swift
//  iAnime
//
//  Created by Zoom on 2019/10/24.
//  Copyright © 2019 NemesissLin. All rights reserved.
//
import UIKit
class LabelItem: UICollectionViewCell  {
    
    var LabelButton : UIButton!
    
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
    
        LabelButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(LabelButton)
        LabelButton.widthAnchor.constraint(equalTo: widthAnchor).Activate()
        LabelButton.heightAnchor.constraint(equalTo: heightAnchor).Activate()
    }
}
