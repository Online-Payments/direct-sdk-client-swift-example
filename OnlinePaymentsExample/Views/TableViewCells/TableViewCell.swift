//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    // This 'unused' variable can be ignored, since it is used with inheritance by other classes
    // periphery:ignore
    class var reuseIdentifier: String {
        return "tableviewcell"
    }

    init(reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.isUserInteractionEnabled = true
    }

    func accessoryAndMarginCompatibleWidth() -> CGFloat {
        if self.accessoryType != .none {
            if self.contentView.frame.width > self.frame.midX - 320/2 + 320 {
                return 320
            }

            return self.contentView.frame.width - 16
        }

        if self.contentView.frame.width > self.frame.midX - 320/2 + 320 + 16 + 22 + 16 {
            return 320
        }

        return self.contentView.frame.width - 16 - 16
    }

    func accessoryCompatibleLeftMargin() -> CGFloat {
        if self.accessoryType != .none {
            if self.contentView.frame.width > self.frame.midX - 320/2 + 320 {
                return self.frame.midX - 320/2
            }

            return 16
        }

        if self.contentView.frame.width > self.frame.midX - 320/2 + 320 + 16 + 22 + 16 {
            return self.frame.midX - 320/2
        }

        return 16
    }
}
