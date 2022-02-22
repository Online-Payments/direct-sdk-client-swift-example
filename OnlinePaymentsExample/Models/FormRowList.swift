//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import OnlinePaymentsKit

class FormRowList: FormRow {
    var items = [ValueMappingItem]()
    var selectedRow = 0
    var paymentProductField: PaymentProductField
    
    init(paymentProductField: PaymentProductField) {
        self.paymentProductField = paymentProductField
    }
}
