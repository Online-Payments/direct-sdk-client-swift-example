//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import Foundation
import OnlinePaymentsKit

class TableSectionConverter {
    static func paymentProductsTableSectionFromAccounts(
        onFile accountsOnFile: [AccountOnFile],
        paymentItems: PaymentItems
    ) -> PaymentProductsTableSection {

        let section = PaymentProductsTableSection()
        section.type = .gcAccountOnFileType

        for accountOnFile in accountsOnFile.sorted(by: { (accountOnFileOne, accountOnFileTwo) -> Bool in
            let displayOrderA =
                paymentItems.paymentItem(
                    withIdentifier: accountOnFileOne.paymentProductIdentifier
                )?.displayHintsList[0].displayOrder ?? Int.max
            let displayOrderB =
                paymentItems.paymentItem(
                    withIdentifier: accountOnFileTwo.paymentProductIdentifier
                )?.displayHintsList[0].displayOrder ?? Int.max
            return displayOrderA < displayOrderB
        }) {
            if let product = paymentItems.paymentItem(withIdentifier: accountOnFile.paymentProductIdentifier) {
                let row = PaymentProductsTableRow()
                let displayName = accountOnFile.label
                row.name = displayName
                row.accountOnFileIdentifier = accountOnFile.identifier
                row.paymentProductIdentifier = accountOnFile.paymentProductIdentifier
                if let displayHints = product.displayHintsList.first {
                    row.logo = displayHints.logoImage
                } else {
                    row.logo = nil
                }

                section.rows.append(row)
            }
        }

        return section
    }

    static func paymentProductsTableSection(from paymentItems: PaymentItems) -> PaymentProductsTableSection {
        let section = PaymentProductsTableSection()

        for paymentItem in paymentItems.paymentItems.sorted(by: { (paymentItemOne, paymentItemTwo) -> Bool in
            if paymentItemOne.displayHintsList.isEmpty == false && paymentItemTwo.displayHintsList.isEmpty == false {
                return
                    paymentItemOne.displayHintsList[0].displayOrder <
                        paymentItemTwo.displayHintsList[0].displayOrder
            }
            return paymentItemOne.identifier < paymentItemTwo.identifier
        }) {
            section.type = .gcPaymentProductType

            let row = PaymentProductsTableRow()
            let paymentProductKey = localizationKey(with: paymentItem)
            let paymentProductValue =
                NSLocalizedString(
                    paymentProductKey,
                    tableName: AppConstants.kAppLocalizable,
                    bundle: AppConstants.appBundle,
                    value: "",
                    comment: ""
                )
            row.name = paymentProductValue
            row.accountOnFileIdentifier = ""
            row.paymentProductIdentifier = paymentItem.identifier
            if let displayHints = paymentItem.displayHintsList.first {
                row.logo = displayHints.logoImage
            } else {
                row.logo = nil
            }

            section.rows.append(row)
        }

        return section
    }

    static func localizationKey(with paymentItem: BasicPaymentItem) -> String {
        switch paymentItem {
        case is BasicPaymentProduct:
            guard let displayHints = paymentItem.displayHintsList.first else {
                return "Display hints not found"
            }
            return displayHints.label ?? "No label found"
        default:
            return ""
        }
    }
}
