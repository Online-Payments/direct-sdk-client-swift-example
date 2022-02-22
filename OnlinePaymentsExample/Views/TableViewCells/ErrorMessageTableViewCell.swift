//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit

class ErrorMessageTableViewCell: LabelTableViewCell {

    override class var reuseIdentifier: String { return "error-cell" }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        labelView.font = UIFont.systemFont(ofSize: 12.0)
        labelView.numberOfLines = 0
        labelView.textColor = UIColor.red

        addSubview(labelView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
