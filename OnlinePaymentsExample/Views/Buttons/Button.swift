//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import UIKit

enum ExampleButtonType {
    case primary
    case secondary
    case destructive
}

class Button : UIButton {
    
    init() {
        self.exampleButtonType = .primary
        super.init(frame: .zero)
        layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var exampleButtonType: ExampleButtonType {
        didSet {
            switch exampleButtonType {
            case .primary:
                setTitleColor(UIColor.white, for: .normal)
                setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
                backgroundColor = AppConstants.kPrimaryColor
                titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
            case .secondary:
                setTitleColor(UIColor.gray, for: .normal)
                setTitleColor(UIColor.gray.withAlphaComponent(0.5), for: .highlighted)
                backgroundColor = UIColor.clear
                titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
            case .destructive:
                setTitleColor(UIColor.white, for: .normal)
                setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
                backgroundColor = AppConstants.kDestructiveColor
                titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
            }
        }
    }
    
    override var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            super.isEnabled = newValue
            alpha = newValue ? 1 : 0.3
        }
    }
}
