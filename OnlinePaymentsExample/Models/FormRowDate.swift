//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import Foundation
import OnlinePaymentsKit

class FormRowDate : FormRow {
    
    var paymentProductField: PaymentProductField
    var date: Date
    init(paymentProductField field: PaymentProductField, value: String) {
        if value != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            
            date = formatter.date(from: value) ?? Date()

        } else {
            date = Date()
        }

        self.paymentProductField = field
    }
    
}
