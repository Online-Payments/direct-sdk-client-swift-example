//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import Foundation
import OnlinePaymentsKit

class FormRowSwitch: FormRowWithInfoButton {
    var isOn: Bool
    var title: NSAttributedString
    var target: Any?
    var action: Selector?
    var field: PaymentProductField?
    
    init(title: NSAttributedString, isOn: Bool, target: Any?, action: Selector?, paymentProductField field: PaymentProductField?) {
        self.title = title
        self.isOn = isOn
        self.target = target
        self.action = action
        self.field = field
    }
    convenience init(title: String, isOn: Bool, target: Any?, action: Selector?, paymentProductField field: PaymentProductField?) {
        self.init(title: NSAttributedString(string: title), isOn: isOn, target: target, action: action, paymentProductField: field)
    }

}
