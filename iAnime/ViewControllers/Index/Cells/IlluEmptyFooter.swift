//
//  IlluEmptyFooter.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SnapKit

enum IlluEmptyType {
    case LocalEmpty
    case NetworkEmpty
    case NetworkError
}

class IlluEmptyFooter: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var label : UILabel!
    
    func InitSubView(_ emptyType : IlluEmptyType) {
        if label == nil {
            label = UILabel()
            label.textAlignment = .center
            
            label.font = label.font.withSize(22)
            addSubview(label)
            
            label.snp.makeConstraints {
                
                make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                
            }
        }
        switch emptyType {
        case .LocalEmpty:
            label.text = "再怎么找也没有啦"
            break
        case .NetworkEmpty:
            label.text = "再怎么找也没有啦"
            break
        case .NetworkError:
            label.text = "电波无法到达喔"
            break
        }
    }
}
