//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import Foundation
import OnlinePaymentsKit
import UIKit

class FormRowsConverter {

    func formRows(from inputData: PaymentProductInputData, confirmedPaymentProducts: Set<String>) -> [FormRow] {
        var rows: [FormRow] = []
        let paymentProductFields = inputData.paymentItem.fields.paymentProductFields

        for field in paymentProductFields {
            let isPartOfAccountOnFile = inputData.fieldIsPartOfAccountOnFile(paymentProductFieldId: field.identifier)
            let value: String
            let isEnabled: Bool

            if isPartOfAccountOnFile {
                let mask = field.displayHints.mask
                value = inputData.accountOnFile.maskedValue(forField: field.identifier, mask: mask)
                isEnabled = !inputData.fieldIsReadOnly(paymentProductFieldId: field.identifier)
            } else {
                value = inputData.maskedValue(forField: field.identifier)
                isEnabled = true
            }

            var row: FormRow = labelFormRow(from: field)
            rows.append(row)

            switch field.displayHints.formElement.type {
            case .listType:
                row = listFormRow(from: field, value: value, isEnabled: isEnabled)
            case .textType:
                row =
                    textFieldFormRow(
                        from: field,
                        paymentItem: inputData.paymentItem,
                        value: value,
                        isEnabled: isEnabled,
                        confirmedPaymentProducts: confirmedPaymentProducts
                    )
            case .currencyType:
                row = currencyFormRow(from: field, value: value, isEnabled: isEnabled)
            case .dateType:
                row = dateFormRow(from: field, value: value, isEnabled: isEnabled)
            case .boolType:
                rows.removeLast()
                row = switchFormRow(from: field, paymentItem: inputData.paymentItem, value: value, isEnabled: isEnabled)
            }

            rows.append(row)
        }

        return rows
    }

    static func errorMessage(for error: ValidationError, withCurrency: Bool) -> String {
        let errorClass = error.self
        let errorMessageFormat = "ValidationErrors.%@"
        var errorMessageKey: String
        var errorMessageValue: String
        var errorMessage: String
        if let lengthError = errorClass as? ValidationErrorLength {
            if lengthError.minLength == lengthError.maxLength {
                errorMessageKey = String(format: errorMessageFormat, "length.exact")
            } else if lengthError.minLength == 0 && lengthError.maxLength > 0 {
                errorMessageKey = String(format: errorMessageFormat, "length.max")
            } else if lengthError.minLength > 0 && lengthError.maxLength > 0 {
                errorMessageKey = String(format: errorMessageFormat, "length.between")
            } else {
                // this case never happens
                errorMessageKey = ""
            }

            let errorMessageValueWithPlaceholders =
                NSLocalizedString(
                    errorMessageKey,
                    tableName: AppConstants.kAppLocalizable,
                    bundle: AppConstants.appBundle,
                    value: "",
                    comment: ""
                )
            let errorMessageValueWithPlaceholder =
                errorMessageValueWithPlaceholders.replacingOccurrences(
                    of: "{maxLength}",
                    with: String(lengthError.maxLength)
                )
            errorMessage =
                errorMessageValueWithPlaceholder.replacingOccurrences(
                    of: "{minLength}",
                    with: String(lengthError.minLength)
                )
        } else if let rangeError = errorClass as? ValidationErrorRange {
            errorMessageKey = String(format: errorMessageFormat, "length.between")
            let errorMessageValueWithPlaceholders =
                NSLocalizedString(
                    errorMessageKey,
                    tableName: AppConstants.kAppLocalizable,
                    bundle: AppConstants.appBundle,
                    value: "",
                    comment: ""
                )
            var minString = ""
            var maxString = ""
            if withCurrency {
                minString = String(format: "%.2f", Double(rangeError.minValue) / 100)
                maxString = String(format: "%.2f", Double(rangeError.maxValue) / 100)
            } else {
                minString = "\(Int(rangeError.minValue))"
                maxString = "\(Int(rangeError.maxValue))"
            }
            let errorMessageValueWithPlaceholder =
                errorMessageValueWithPlaceholders.replacingOccurrences(of: "{maxValue}", with: String(maxString))
            errorMessage =
                errorMessageValueWithPlaceholder.replacingOccurrences(of: "{minValue}", with: String(minString))
        } else if !errorClass.errorMessage.isEmpty {
            errorMessageKey = String(format: errorMessageFormat, errorClass.errorMessage)
            errorMessageValue =
                NSLocalizedString(
                    errorMessageKey,
                    tableName: AppConstants.kAppLocalizable,
                    bundle: AppConstants.appBundle,
                    value: "",
                    comment: ""
                )
            errorMessage = errorMessageValue
        } else {
            errorMessage = ""
            NSException(
                name: NSExceptionName(rawValue: "Invalid validation error"),
                reason: "Validation error \(error) is invalid",
                userInfo: nil
            ).raise()
        }

        return errorMessage
    }

    func textFieldFormRow(
        from field: PaymentProductField,
        paymentItem: PaymentItem,
        value: String,
        isEnabled: Bool,
        confirmedPaymentProducts: Set<String>?
    ) -> FormRowTextField {
        // Set placeholder for field
        let placeholderValue = field.displayHints.placeholderLabel ?? "No placeholder found"

        let keyboardType: UIKeyboardType
        switch field.displayHints.preferredInputType {
        case .integerKeyboard:
            keyboardType = .numberPad

        case .emailAddressKeyboard:
            keyboardType = .emailAddress

        case .phoneNumberKeyboard:
            keyboardType = .phonePad

        case .stringKeyboard, .dateKeyboard:
            keyboardType = .default
        }

        let formField =
            FormRowField(
                text: value,
                placeholder: placeholderValue,
                keyboardType: keyboardType,
                isSecure: field.displayHints.obfuscate
            )
        let row = FormRowTextField(paymentProductField: field, field: formField)
        row.isEnabled = isEnabled

        if field.identifier == "cardNumber" {
            if let confirmedPaymentProducts = confirmedPaymentProducts,
               confirmedPaymentProducts.contains(paymentItem.identifier) {
                row.logo = paymentItem.displayHints.first?.logoImage ?? nil
            } else {
                row.logo = nil
            }
        }

        setTooltipForFormRow(row, with: field)

        return row
    }

    func currencyFormRow(from field: PaymentProductField, value: String, isEnabled: Bool) -> FormRowCurrency {
        // Set placeholder for field (response only returns empty placeholder labels)
        let placeholderValue = field.displayHints.placeholderLabel ?? "No placeholder found"

        let keyboardType: UIKeyboardType
        switch field.displayHints.preferredInputType {
        case .integerKeyboard:
            keyboardType = .numberPad
        case .emailAddressKeyboard:
            keyboardType = .emailAddress
        case .phoneNumberKeyboard:
            keyboardType = .phonePad
        case .stringKeyboard, .dateKeyboard:
            keyboardType = .default
        }

        let integerPart = Int((Double(value) ?? 0) / 100)
        let fractionalPart = Int(llabs((Int64(value) ?? 0) % 100))

        let integerField =
            FormRowField(
                text: "\(integerPart)",
                placeholder: placeholderValue,
                keyboardType: keyboardType,
                isSecure: field.displayHints.obfuscate
            )
        let fractionalField =
            FormRowField(
                text: String(format: "%02d", fractionalPart),
                placeholder: "",
                keyboardType: keyboardType,
                isSecure: field.displayHints.obfuscate
            )

        let row =
            FormRowCurrency(paymentProductField: field, integerField: integerField, fractionalField: fractionalField)

        row.integerField = integerField
        row.fractionalField = fractionalField
        row.isEnabled = isEnabled

        setTooltipForFormRow(row, with: field)

        return row
    }

    func switchFormRow(
        from field: PaymentProductField,
        paymentItem: PaymentItem,
        value: String,
        isEnabled: Bool
    ) -> FormRowSwitch {

        let descriptionKey =
            String(
                format: "PaymentProductFields.%@.label",
                field.identifier
            )
        let descriptionValue =
            NSLocalizedString(
                descriptionKey,
                tableName: AppConstants.kAppLocalizable,
                bundle: AppConstants.appBundle,
                value: "",
                comment: ""
            )
        
        let attrString = NSMutableAttributedString(string: descriptionValue)

        let row =
            FormRowSwitch(
                title: attrString,
                isOn: value == "true",
                target: nil,
                action: nil,
                paymentProductField: field
            )
        row.isEnabled = isEnabled

        return row
    }

    func dateFormRow(from field: PaymentProductField, value: String, isEnabled: Bool) -> FormRowDate {
        let row = FormRowDate(paymentProductField: field, value: value)
        row.isEnabled = isEnabled

        return row
    }

    func setTooltipForFormRow(_ row: FormRowWithInfoButton, with field: PaymentProductField) {
        // Only create a tooltip when the label is not empty
        if let tooltipLabel = field.displayHints.tooltip?.label,
               !tooltipLabel.isEmpty {
            let tooltip = FormRowTooltip()
            tooltip.text = field.displayHints.tooltip?.label
            row.tooltip = tooltip
        }
    }

    func listFormRow(from field: PaymentProductField, value: String, isEnabled: Bool) -> FormRowList {
        let row = FormRowList(paymentProductField: field)

        row.selectedRow = 0
        row.isEnabled = isEnabled

        return row
    }

    func labelFormRow(from field: PaymentProductField) -> FormRowLabel {
        let labelValue = field.displayHints.label ?? "No label found"

        return FormRowLabel(text: labelValue)
    }
}
