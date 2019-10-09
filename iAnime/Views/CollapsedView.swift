//
//  CollapsedView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class CollapsedView: UIView {

    private(set) var ViewName : String!
    
    convenience init(_ Name : String) {
        self.init(frame: CGRect.zero)
        ViewName = Name
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
