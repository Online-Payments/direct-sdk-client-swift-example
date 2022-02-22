//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import Foundation
import OnlinePaymentsKit

class TableSectionConverter {
    static func paymentProductsTableSectionFromAccounts(onFile accountsOnFile: [AccountOnFile], paymentItems: PaymentItems) -> PaymentProductsTableSection {
        
        let section = PaymentProductsTableSection()
        section.type = .gcAccountOnFileType
        
        for accountOnFile in accountsOnFile.sorted(by: { (a, b) -> Bool in
            return paymentItems.paymentItem(withIdentifier:a.paymentProductIdentifier)?.displayHints.displayOrder ?? Int.max < paymentItems.paymentItem(withIdentifier:b.paymentProductIdentifier)?.displayHints.displayOrder ?? Int.max;
        }) {
            if let product = paymentItems.paymentItem(withIdentifier: accountOnFile.paymentProductIdentifier) {
                let row = PaymentProductsTableRow()
                let displayName = accountOnFile.label
                row.name = displayName
                row.accountOnFileIdentifier = accountOnFile.identifier
                row.paymentProductIdentifier = accountOnFile.paymentProductIdentifier
                row.logo = product.displayHints.logoImage
                
                section.rows.append(row)
            }
        }
        
        return section
    }
    
    static func paymentProductsTableSection(from paymentItems: PaymentItems) -> PaymentProductsTableSection {
        let section = PaymentProductsTableSection()
        
        for paymentItem in paymentItems.paymentItems.sorted(by: { (a, b) -> Bool in
            return a.displayHints.displayOrder ?? Int.max < b.displayHints.displayOrder ?? Int.max;
        }) {
            section.type = .gcPaymentProductType
            
            let row = PaymentProductsTableRow()
            let paymentProductKey = localizationKey(with: paymentItem)
            let paymentProductValue = NSLocalizedString(paymentProductKey, tableName: SDKConstants.kSDKLocalizable, bundle: AppConstants.sdkBundle, value: "", comment: "")
            row.name = paymentProductValue
            row.accountOnFileIdentifier = ""
            row.paymentProductIdentifier = paymentItem.identifier
            row.logo = paymentItem.displayHints.logoImage
            
            section.rows.append(row)
        }
        
        return section
    }
    
    static func localizationKey(with paymentItem: BasicPaymentItem) -> String {
        switch paymentItem {
        case is BasicPaymentProduct:
            return "gc.general.paymentProducts.\(paymentItem.identifier).name"

        default:
            return ""
        }
    }
}

