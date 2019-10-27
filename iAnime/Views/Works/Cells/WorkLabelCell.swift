//
//  WorkLabelCell.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/27.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SnapKit
class WorkLabelCell: UICollectionViewCell {
    
    private var labelBtn : LabelButton!
    private var separator : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func InitCellContent(_ title : String,_ searchText : String) {
        labelBtn = LabelButton(title,searchText)
        separator = UILabel()
        
        addSubview(labelBtn)
        
        separator.text = "/"
        
        labelBtn.snp.makeConstraints {
            make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        LoadSeparatorToCell()
    }
    private func LoadSeparatorToCell() {
        addSubview(separator)
        separator.snp.makeConstraints {
            make in
            make.leading.equalTo(labelBtn.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(labelBtn.snp.centerY)
        }
    }
    
    func HideSeparator() {
        separator.isHidden = true
    }
    
    func ShowSeparator() {
        separator.isHidden = false
    }
}
