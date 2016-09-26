//
//  UpvoteControl.swift
//  Raúl Riera
//
//  Created by Raúl Riera on 26/04/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable
open class UpvoteControl: UIControl {
    /**
    The current count value
    
    The default value for this property is 0. It will increment and decrement internally depending of the `selected` property
    */
    @IBInspectable open var count: Int = 0 {
        didSet {
            updateCountLabel()
        }
    }
    
    @IBInspectable open var borderRadius: CGFloat = 0 {
        didSet {
            updateLayer()
        }
    }
    @IBInspectable open var shadow: Bool = false {
        didSet {
            updateLayer()
        }
    }
    
    @IBInspectable open var vertical: Bool = true {
        didSet {
            updateCountLabel()
        }
    }
    
    /**
    The font of the text
    
    Until Xcode supports @IBInspectable for UIFonts, this is the only way to change the font of the inner label
    */
    @IBInspectable open var font: UIFont? {
        didSet {
            countLabel.font = font
        }
    }
    
    /**
    The color of text
    
    The default value for this property is a black color (set through the blackColor class method of UIColor).
    */
    @IBInspectable open var textColor: UIColor = .black {
        didSet {
            countLabel.textColor = textColor
        }
    }
    
    fileprivate var countLabel: UILabel = UILabel()

    override open var isSelected: Bool {
        didSet {
            if isSelected {
                countLabel.textColor = tintColor
            } else {
                countLabel.textColor = textColor
            }
        }
    }
    
    // MARK: Overrides
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with:event)
        
        if let touch = touch , touch.tapCount > 0 {
            if isSelected {
                count -= 1
            } else {
                count += 1
            }
            
            isSelected = !isSelected
            super.sendActions(for: .valueChanged)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    // MARK: Private
    
    fileprivate func configureView() {
        // Allow this method to only run once
        guard countLabel.superview == .none else { return }
        
        updateLayer()
    
        countLabel = UILabel(frame: bounds)
        countLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        countLabel.numberOfLines = 0
        countLabel.lineBreakMode = .byWordWrapping
        countLabel.textAlignment = .center
        countLabel.isUserInteractionEnabled = false

        countLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countLabel)

        let centerXConstraint = NSLayoutConstraint(item: countLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: countLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        
        countLabel.setNeedsDisplay()
    }
    
    fileprivate func updateLayer() {
        layer.cornerRadius = borderRadius
        
        if shadow {
            layer.shadowColor = UIColor.darkGray.cgColor
            layer.shadowRadius = 0.5
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowOpacity = 0.5
        }
    }
    
    fileprivate func updateCountLabel() {
        if vertical {
            countLabel.text = "▲\n\(count)"
        } else {
            countLabel.text = "▲ \(count)"
        }
    }
}
