//
//  InputCell.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/5.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class InputCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var input: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
