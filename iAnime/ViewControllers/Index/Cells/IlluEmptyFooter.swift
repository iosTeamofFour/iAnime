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
    var imageView : UIImageView!
    var verticalContainer : UIStackView!
    
    func InitSubView(_ emptyType : IlluEmptyType) {
        if label == nil {
            
            verticalContainer = UIStackView()
            verticalContainer.axis = .vertical
            verticalContainer.autoresizesSubviews = false
            verticalContainer.spacing = 16
            addSubview(verticalContainer)
            verticalContainer.snp.makeConstraints {
                make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(200)
            }
            
            let paddingView = UIView()
            
            paddingView.snp.makeConstraints {
                make in
                make.height.equalTo(100)
            }
            
            verticalContainer.addArrangedSubview(paddingView)
            
            label = UILabel()
            imageView = UIImageView()
            imageView.image = UIImage(named: "EmptyBox")
            
            paddingView.addSubview(imageView)
            
            imageView.snp.makeConstraints {
                make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(96)
                make.height.equalTo(imageView.snp.width)
            }
            
            label.textAlignment = .center
            label.font = label.font.withSize(22)
            label.textColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1)
            
            
            verticalContainer.addArrangedSubview(label)
            
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
