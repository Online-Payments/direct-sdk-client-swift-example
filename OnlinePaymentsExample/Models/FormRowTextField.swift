//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit
import OnlinePaymentsKit

struct FormRowField {
    var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType
    var isSecure: Bool

    init(text: String, placeholder: String, keyboardType: UIKeyboardType, isSecure: Bool) {
        self.text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecure = isSecure
    }
}

class FormRowTextField: FormRowWithInfoButton {
    var paymentProductField: PaymentProductField
    var logo: UIImage?
    var field: FormRowField

    init(paymentProductField: PaymentProductField, field: FormRowField) {
        self.paymentProductField = paymentProductField
        self.field = field
    }
}
