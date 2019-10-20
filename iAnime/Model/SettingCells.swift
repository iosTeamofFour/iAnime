//
//  SettingCells.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit

struct SettingGroup {
    var GroupName: String
    var GroupItems : [ISettingCell]
}


protocol ISettingCell {
    var CellName : String { get set }
    var TargetCellIdentifier : String { get set }
}

struct SegueSettingCell<TViewController> : ISettingCell {
    var CellName : String
    var TargetCellIdentifier : String
    var TargetStoryboard : String?
    var TargetViewController : TViewController
    var PushToNavigationController : Bool = true
    var BackItemKey : String?
    var ShowNavigationBar : Bool = true
}

struct OptionSettingCell : ISettingCell {
    var CellName: String
    var TargetCellIdentifier: String
}
