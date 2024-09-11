//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import UIKit
import OnlinePaymentsKit

class CoBrandsSelectionTableViewCell: TableViewCell {

    override class var reuseIdentifier: String {
        return "co-brand-selection-cell"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let font = UIFont.systemFont(ofSize: 13)
        let underlineAttributes =
            [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.font: font
            ] as [NSAttributedString.Key: Any]?

        let cobrandsString =
            NSLocalizedString(
                "CobrandsDetectedText",
                tableName: AppConstants.kAppLocalizable,
                bundle: AppConstants.appBundle,
                value: "",
                comment: ""
            )

        textLabel?.attributedText = NSAttributedString(string: cobrandsString, attributes: underlineAttributes)
        textLabel?.textAlignment = .right
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = accessoryAndMarginCompatibleWidth()
        let leftMargin = accessoryCompatibleLeftMargin()
        textLabel?.frame = CGRect(x: leftMargin, y: 4, width: width, height: 36)
    }
}
