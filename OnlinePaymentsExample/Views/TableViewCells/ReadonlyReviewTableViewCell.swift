//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit
import OnlinePaymentsKit

class ReadonlyReviewCell: TableViewCell {
    override class var reuseIdentifier: String {
        return "readonly-review-cell"
    }
    var data: [String:String] = [:] {
        didSet {
            self.updateLabel()
        }
    }
    private var labelNeedsUpdate: Bool = true
    var labelView: UITextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(labelView)
        labelView.isEditable = false
        labelView.isScrollEnabled = false
        self.clipsToBounds = true
        self.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateLabel() {
        
        let attributedString = ReadonlyReviewCell.labelAttributedString(for: self.data, in: self.frame.size.width);
        self.labelView.attributedText = attributedString;
        labelView.sizeToFit()
        self.labelNeedsUpdate = false
        self.setNeedsLayout()
    }
    
    class func labelAttributedString(for data: [String: String], in width: CGFloat) -> NSAttributedString {
        let successStringKey = "gc.app.paymentProductDetails.searchConsumer.result.success.summary";

        var successString = NSLocalizedString(successStringKey, tableName: SDKConstants.kSDKLocalizable,
                                              bundle: AppConstants.sdkBundle,
                                              value: successStringKey, comment: "");
        successString = successString.replacingOccurrences(of: "{br}", with: "\n")
        for (key, value) in data {
            successString = successString.replacingOccurrences(of: "{\(key)}", with:value)
        }
        
        let attributedString = NSMutableAttributedString(string:successString)
        return attributedString;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = accessoryAndMarginCompatibleWidth()
        let leftMargin = accessoryCompatibleLeftMargin()
        var labelFrame = CGRect(x: leftMargin, y: 10, width: width, height: DatePickerTableViewCell.pickerHeight)
        labelFrame.size.height = self.labelView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        self.labelView.frame = labelFrame
        
        if (self.labelNeedsUpdate) {
            self.updateLabel()
        }
    }
    
    class func cellHeight(for data: [String: String], in width: CGFloat) -> CGFloat {
        let label = UITextView()
        label.isEditable = false
        label.isScrollEnabled = false
        label.attributedText = self.labelAttributedString(for: data, in: width)
        let height = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        return height
    }
}
