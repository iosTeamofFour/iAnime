//
//  IllustrationItemView.swift
//  iAnime
//
//  Created by Zoom on 2019/10/8.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SnapKit

class IllustrationItemView: UIStackView {
    
    var image : UIImageView!
    var name : UILabel!
    var dateStr : UILabel!
    var drawingInfo : DrawingInfo?
    
    var shouldLoadImage : UIImage?
    
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
    
    func SetDrawingInfo(_ drawingInfo : DrawingInfo, _ previewImage : UIImage) {
        self.drawingInfo = drawingInfo
        shouldLoadImage = previewImage
        UpdateIllustrationView()
    }
    
    func InitSubViews() {
        image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.layer.cornerRadius = 4
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        
        name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        dateStr = UILabel()
        dateStr.translatesAutoresizingMaskIntoConstraints = false
        
        name.font = name.font.withSize(18.0)
        dateStr.font = dateStr.font.withSize(16.0)
        dateStr.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
        
        addArrangedSubview(image)
        addArrangedSubview(name)
        addArrangedSubview(dateStr)
        
        image.addConstraint(NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: image, attribute: .height, multiplier: 9/16, constant: 0))
        name.snp.makeConstraints {
            make in
            make.height.equalTo(20.0)
        }
        
    }
    func UpdateIllustrationView() {
        if image == nil {
            InitSubViews()
        }
        
        if let illu = drawingInfo {
            name.text = illu.Name
            image.image = shouldLoadImage
            // TODO - Change this formatter to a singleton.
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-M-d"
            dateStr.text = fmt.string(from: Unix2Date(illu.CreatedTime))
        }
    }
}
