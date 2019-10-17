//
//  NightModeTableViewCell.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/17.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class NightModeTableViewCell: SettingWithSwitchTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func OnToggleSwitch() {
        super.OnToggleSwitch()
        print("当前夜间模式打开状况: \(SwitchButton.isOn)")
    }
}
