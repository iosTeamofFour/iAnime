//
//  LabelButton.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/27.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class LabelButton: UIButton {
    
    private(set) var ClickToSearchText : String!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    convenience init(_ title : String,_ searchText : String) {
        self.init(type : .system)
        adjustsImageWhenHighlighted = true
        showsTouchWhenHighlighted = true
        ClickToSearchText = searchText
        setTitle(title, for: .normal)
        BindSearchAction()
    }
    
    private func BindSearchAction() {
        addTarget(self, action: #selector(BeginSearchText), for: .touchUpInside)
    }
    
    @objc private func BeginSearchText(_ sender : LabelButton) {
        print("即将搜索: \(ClickToSearchText)")
        // 到时候跳转到搜索界面执行搜索的逻辑写在这里
    }
}
