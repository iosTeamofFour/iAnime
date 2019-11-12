//
//  IlluItemCell.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SnapKit

class IlluItemCell: UICollectionViewCell {
    
    var illustrationView : IllustrationItemView? {
        didSet {
            if let illu = illustrationView {
                oldValue?.removeFromSuperview()
                UpdateIllustration(illu)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func UpdateIllustration(_ illu : IllustrationItemView) {
        addSubview(illu)
        
        illu.snp.makeConstraints {
            make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
