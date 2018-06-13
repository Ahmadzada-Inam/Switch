//
//  Switch.swift
//  Switch
//
//  Created by Inam Ahmad-zada on 2018-01-10.
//  Copyright © 2018 Inam Ahmad-zada. All rights reserved.
//

import UIKit

@IBDesignable
class Switch: UIControl {

    // Background tint color for `ON` state
    @IBInspectable
    public var onTintColor: UIColor = UIColor.clear {
        didSet {
            setup()
        }
    }
    
    // Background tint color for `OFF` state
    @IBInspectable
    public var offTintColor: UIColor = UIColor.clear {
        didSet {
            setup()
        }
    }
    
    // Corner radius multiple for main view
    @IBInspectable
    public var cornerRadiusMultiple: CGFloat {
        get {
            return self.mainCornerRadiusMultiple
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                mainCornerRadiusMultiple = 0.5
            }
            else {
                mainCornerRadiusMultiple = newValue
            }
        }
    }
    
    private var mainCornerRadiusMultiple: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }
    
    // Thumb tint color for `ON` state
    @IBInspectable
    public var onThumbTintColor: UIColor = UIColor.red {
        didSet {
            setup()
        }
    }
    
    // Thumb tint color for `OFF` state
    @IBInspectable
    public var offThumbTintColor: UIColor = UIColor.white {
        didSet {
            setup()
        }
    }
    
    // Corner radius multiple for thumb view
    @IBInspectable
    public var thumbCornerRadiusMultiple: CGFloat {
        get {
            return self.thumbMainCornerRadiusMultiple
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                thumbMainCornerRadiusMultiple = 0.5
            }
            else {
                thumbMainCornerRadiusMultiple = newValue
            }
        }
    }
    
    private var thumbMainCornerRadiusMultiple: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    public var thumbSize: CGSize = .zero {
        didSet {
            layoutSubviews()
        }
    }
    
    // Padding between thumb view and border
    private var padding: CGFloat = 2.0
    
    public var labelOn: UILabel = UILabel()
    public var labelOff: UILabel = UILabel()
    // Boolean to check if labels are enabled for toggle
    public var labelsAreEnabled: Bool = true {
        didSet {
            setup()
        }
    }
    
    // Font used for ON and OFF labels
    @IBInspectable
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 10) {
        didSet {
            setup()
        }
    }
    
    // Text color used for ON and OFF labels
    @IBInspectable
    public var textColor: UIColor = UIColor.white {
        didSet {
            setup()
        }
    }
    
    // Boolean value to check if toggle is switched on
    @IBInspectable
    public var isOn: Bool = true {
        didSet {
            setup()
        }
    }
    
    public var animationDuration: TimeInterval = 0.5
    
    fileprivate var thumbView = UIView(frame: .zero)
    fileprivate var onPoint: CGPoint = .zero
    fileprivate var offPoint: CGPoint = .zero
    fileprivate var isAnimating: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    /// Clean all the subviews
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    /// Setup the UI for toggle
    func setup() {
        self.clear()
        self.clipsToBounds = true
        self.thumbView.backgroundColor = self.isOn ? onThumbTintColor : offThumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(thumbView)
        self.layer.borderColor = self.onThumbTintColor.cgColor
        self.layer.borderWidth = 1.5
        
        setupLabels()
    }
    
    /// If labels are enabled, setup ON and OFF labels
    fileprivate func setupLabels() {
        guard labelsAreEnabled else {
            self.labelOn.alpha = 0.0
            self.labelOff.alpha = 0.0
            return
        }
        
        self.labelOn.alpha = self.isOn ? 1.0 : 0.0
        self.labelOff.alpha = self.isOn ? 0.0 : 1.0
        let labelWidth = self.bounds.width / 2 - padding
        self.labelOn.frame = CGRect(x: padding / 2 + self.layer.borderWidth, y: 0, width: labelWidth, height: self.bounds.height)
        self.labelOff.frame = CGRect(x: self.bounds.width / 2 + padding / 2, y: 0, width: labelWidth, height: self.bounds.height)
        self.labelOn.font = self.font
        self.labelOff.font = self.font
        self.labelOn.text = "ON"
        self.labelOff.text = "OFF"
        self.labelOn.textColor = self.textColor
        self.labelOff.textColor = self.textColor
        self.labelOn.textAlignment = .center
        self.labelOff.textAlignment = .center
        self.insertSubview(labelOn, belowSubview: thumbView)
        self.insertSubview(labelOff, belowSubview: thumbView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update subviews if animation is not in progress
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.mainCornerRadiusMultiple
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
            let thumbHeight = self.bounds.size.height - self.padding * 2 - self.layer.borderWidth * 2
            let thumbSize = self.thumbSize != .zero ? self.thumbSize : CGSize(width: thumbHeight, height: thumbHeight)
            let yPosition = (self.bounds.size.height - thumbHeight) / 2
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbHeight - self.padding - self.layer.borderWidth, y: yPosition)
            self.offPoint = CGPoint(x: self.padding + self.layer.borderWidth, y: yPosition)
            thumbView.frame = CGRect(origin: self.isOn ? onPoint : offPoint, size: thumbSize)
            thumbView.layer.cornerRadius = thumbHeight * self.thumbMainCornerRadiusMultiple
            
            if labelsAreEnabled {
                let labelWidth = self.bounds.width / 2 - padding
                self.labelOn.frame = CGRect(x: padding / 2 + self.layer.borderWidth, y: 0, width: labelWidth, height: self.bounds.height)
                self.labelOff.frame = CGRect(x: self.bounds.width / 2 + padding / 2, y: 0, width: labelWidth, height: self.bounds.height)
            }
        }
    }
    
    /// Animate function to call when user interacts with the view
    private func animate() {
        self.isOn = !self.isOn
        self.isAnimating = true
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
            self.thumbView.backgroundColor = self.isOn ? self.onThumbTintColor : self.offThumbTintColor
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            self.labelOn.alpha = self.isOn ? 1.0 : 0.0
            self.labelOff.alpha = self.isOn ? 0.0 : 1.0
        }) { _ in
            self.isAnimating = false
            self.sendActions(for: UIControlEvents.valueChanged)
        }
    }
    
    /// Receive touch events
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
}
