//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import Foundation
import OnlinePaymentsKit

class FormRowCurrency: FormRowWithInfoButton {
    var integerField: FormRowField
    var fractionalField: FormRowField

    var paymentProductField: PaymentProductField

    init(paymentProductField: PaymentProductField, integerField: FormRowField, fractionalField: FormRowField) {
        self.paymentProductField = paymentProductField
        self.integerField = integerField
        self.fractionalField = fractionalField
    }
}
