//
//  CommsButton.swift
//  commspro
//
//  Created by Anthony Picciano on 1/2/17.
//  Copyright © 2017 Anthony Picciano. All rights reserved.
//

import UIKit

@IBDesignable
class CommsButton: UIButton {
    
    @IBInspectable var buttonText: String = String() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        CommsProStyleKit.drawButton(frame: bounds, message: buttonText, isEnabled: isEnabled, isHighlighted: isSelected)
    }

}
