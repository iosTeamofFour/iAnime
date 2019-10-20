//
//  TimelineHeader.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class TimelineHeader: UICollectionReusableView {
    
    var header : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        InitHeaderTitle()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        InitHeaderTitle()
    }
    
    private func InitHeaderTitle() {
        header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        addSubview(header)
        header.centerYAnchor.constraint(equalTo: centerYAnchor).Activate()
        header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).Activate()
        header.font = header.font.withSize(22)
        header.text = "Date Text"
    }
}
