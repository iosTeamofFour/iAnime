//
//  MultistateButton.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

struct ButtonState {
    var Text : String
    var Image : UIImage?
    var TitleFont : UIFont?
    var OnClicked : ((MultistateButton)->Void)?
    var TitleFontColor : UIColor?
    
    init(_ text : String, _ image : UIImage?, _ titleFont : UIFont?,_ titleColor : UIColor? ,_ onClicked : ((MultistateButton)->Void)?) {
        
        Text = text
        Image = image
        TitleFont = titleFont
        TitleFontColor = titleColor
        OnClicked = onClicked
    }
}

@IBDesignable
class MultistateButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(OnSelfClicked(_:)), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(OnSelfClicked(_:)), for: .touchUpInside)
    }
    
    private(set) var ButtonState : [ButtonState] = []
    private(set) var CurrentState = -1
    func AddStates(_ states : [ButtonState]) {
        ButtonState.append(contentsOf: states)
        if CurrentState == -1 {
            PresentNewState(0)
        }
    }
    
    func NextState(_ index : Int) {
        if !ButtonState.InRange(index) {
            print("State requested \(index) is out of range!")
            return
        }
        PresentNewState(index)
    }
    
    private func PresentNewState(_ index : Int ){
        let nextState = ButtonState[index]
        CurrentState = index
        
        setTitle(nextState.Text, for: .normal)
        titleLabel?.font = nextState.TitleFont ?? titleLabel?.font
        
        setImage(nextState.Image ?? currentImage, for: .normal)
        setTitleColor(nextState.TitleFontColor, for: .normal)
        tintColor = nextState.TitleFontColor ?? tintColor
        
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 4, left: -2, bottom: 4, right: 1)
    }
    
    @objc private func OnSelfClicked(_ sender: MultistateButton) {
        ButtonState[CurrentState].OnClicked?(sender)
    }
}
