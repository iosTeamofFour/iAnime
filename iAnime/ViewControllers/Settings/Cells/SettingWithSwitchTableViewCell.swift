//
//  SettingWithSwitchTableViewCell.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/17.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class SettingWithSwitchTableViewCell: SettingTableViewCell {
    
    @IBOutlet weak var SwitchButton: UISwitch!
    var OnSwitchChanged : ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SwitchButton.addTarget(self, action: #selector(OnToggleSwitch), for: .valueChanged)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func OnToggleSwitch() {
        OnSwitchChanged?(SwitchButton.isOn)
    }
}
