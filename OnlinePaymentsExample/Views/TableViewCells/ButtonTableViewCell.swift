//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit

class ButtonTableViewCell: TableViewCell {
    private var button: Button = Button()

    override class var reuseIdentifier: String { return "button-cell" }

    var buttonType: ExampleButtonType {
        get {
            return button.exampleButtonType
        }
        set {
            button.exampleButtonType = newValue
        }
    }

    var title: String? {
        get {
            return button.title(for: .normal)
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }

    var isEnabled: Bool {
        get {
            return button.isEnabled
        }
        set {
            button.isEnabled = newValue
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func sharedInit() {
        addSubview(button)
        buttonType = .primary
    }

    func setClickTarget(_ target: Any, action: Selector) {
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.addTarget(target, action: action, for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = accessoryAndMarginCompatibleWidth()
        let leftMargin = accessoryCompatibleLeftMargin()
        let height = contentView.frame.size.height
        button.frame = CGRect(x: leftMargin, y: buttonType == .secondary ? 6 : 12, width: width, height: height - 12)
    }

    override func prepareForReuse() {
        button.removeTarget(nil, action: nil, for: .allEvents)
    }
}
