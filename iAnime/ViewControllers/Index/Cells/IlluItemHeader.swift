//
//  IlluItemHeader.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class IlluItemHeader: UICollectionReusableView {
    var header : UILabel!
    var TypeTitle : String = "Local Illu" {
        didSet {
            header.text = TypeTitle
        }
    }
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
        header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).Activate()
        header.font = header.font.withSize(22)
        header.text = TypeTitle
    }
}
