//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit
import OnlinePaymentsKit

class COBrandsExplanationTableViewCell: TableViewCell {

    override class var reuseIdentifier: String {
        return "co-brand-explanation-cell"
    }
    var limitedBackgroundView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.attributedText = COBrandsExplanationTableViewCell.cellString()
        textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        textLabel?.numberOfLines = 0
        limitedBackgroundView.addSubview(textLabel!)
        limitedBackgroundView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.contentView.addSubview(limitedBackgroundView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func cellString() -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 12)
        let fontAttribute = [NSAttributedString.Key.font: font]

        let cellKey = "gc.general.cobrands.introText"
        let cellString =
            NSLocalizedString(
                cellKey,
                tableName: SDKConstants.kSDKLocalizable,
                bundle: AppConstants.sdkBundle,
                value: "",
                comment: ""
            )
        let cellStringWithFont = NSAttributedString(string: cellString, attributes: fontAttribute)

        return cellStringWithFont
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = accessoryAndMarginCompatibleWidth()
        let leftMargin = accessoryCompatibleLeftMargin()
        limitedBackgroundView.frame = CGRect(x: leftMargin, y: 4, width: width, height: (self.textLabel?.frame.height)!)
        textLabel?.frame = limitedBackgroundView.bounds
    }
}
