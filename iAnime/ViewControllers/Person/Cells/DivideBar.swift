//
//  DivideBar.swift
//  iAnime
//
//  Created by Zoom on 2019/10/24.
//  Copyright © 2019 NemesissLin. All rights reserved.
//


import UIKit

class DivideBar: UICollectionReusableView {
    
    var divideBar : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        InitDivideBar()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         InitDivideBar()
    }
    
    private func  InitDivideBar() {
        divideBar = UILabel()
        divideBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divideBar)
        divideBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).Activate()
        divideBar.font = divideBar.font.withSize(14)
        divideBar.text = "/"
    }
}

