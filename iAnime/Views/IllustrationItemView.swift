//
//  IllustrationItemView.swift
//  iAnime
//
//  Created by Zoom on 2019/10/8.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class IllustrationItemView: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var image : UIImageView!
    private var name : UILabel!
    private var dateStr : UILabel!
    
    var illustration : Illustration? {
        didSet {
            UpdateIllustrationView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 8
    }
    
    required init(coder: NSCoder) {
        super.init(coder : coder)
        axis = .vertical
        spacing = 8
    }
    
    private func InitSubViews() {
        image = UIImageView()
        image.addConstraint(NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: image, attribute: .height, multiplier: 9/16, constant: 0))
        
        image.layer.cornerRadius = 4
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        
        name = UILabel()
        
        dateStr = UILabel()
        
        dateStr.font.withSize(12.0)
        dateStr.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
        
        addArrangedSubview(image)
        addArrangedSubview(name)
        addArrangedSubview(dateStr)
    }
    private func UpdateIllustrationView() {
        if image == nil {
            InitSubViews()
        }
        
        if let illu = illustration {
            image.image = illu.Image
            name.text = illu.Name
            
            // TODO - Change this formatter to a singleton.
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-M-d"
            dateStr.text = fmt.string(from: illu.UploadDate)
        }
    }
    
}
