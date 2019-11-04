//
//  ColorizeRequestCell.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/4.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class ColorizeRequestCell: UITableViewCell {
    @IBOutlet weak var RequestImg: UIImageView!
    @IBOutlet weak var RequestDate: UILabel!
    @IBOutlet weak var ProcessPercentage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
