//
//  LeftAlignedImageButton.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/19.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

@IBDesignable
class LeftAlignedImageButton: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width
        return titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)
    }
}
