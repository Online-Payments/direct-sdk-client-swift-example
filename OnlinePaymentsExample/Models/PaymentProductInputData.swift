//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import Foundation
import OnlinePaymentsKit

class PaymentProductInputData {
    var paymentItem: PaymentItem!
    var accountOnFile: AccountOnFile!
    var tokenize = false
    var errors = NSMutableArray()
    var fieldValues = Dictionary<String, String>()
    var formatter = StringFormatter()
    
    func paymentRequest() -> PaymentRequest {
        guard let paymentItem = paymentItem as? PaymentProduct else {
            fatalError("Invalid paymentItem")
        }
        
        let paymentRequest = PaymentRequest(paymentProduct: paymentItem, accountOnFile: accountOnFile, tokenize: self.tokenize)
        
        let keys = Array(fieldValues.keys)
        
        for key: String in keys {
            if let value = fieldValues[key] {
                paymentRequest.setValue(forField: key, value: value)
            }
        }
        
        return paymentRequest
    }
    
    func setValue(value: String, forField paymentProductFieldId: String) {
        fieldValues[paymentProductFieldId] = value
    }
    
    func value(forField paymentProductFieldId: String) -> String {
        guard let value = fieldValues[paymentProductFieldId] else {
            return ""
        }
        
        return value
    }
    
    func maskedValue(forField paymentProductFieldId: String) -> String {
        var cursorPosition = 0
        return maskedValue(forField: paymentProductFieldId, cursorPosition: &cursorPosition)
    }
    
    func maskedValue(forField paymentProductFieldId: String, cursorPosition: inout Int) -> String {
        let value = self.value(forField: paymentProductFieldId)
        guard let maskValue = mask(forField: paymentProductFieldId) else {
            return value
        }
        
        return formatter.formatString(string: value, mask: maskValue, cursorPosition: &cursorPosition)
    }
    
    func unmaskedValue(forField paymentProductFieldId: String) -> String {
        let value = self.value(forField: paymentProductFieldId)
        guard let maskValue = mask(forField: paymentProductFieldId) else {
            return value
        }
        
        return formatter.unformatString(string: value , mask: maskValue)
        
    }
    
    func fieldIsPartOfAccountOnFile(paymentProductFieldId: String) -> Bool {
        return accountOnFile?.hasValue(forField: paymentProductFieldId) ?? false
    }
    
    func fieldIsReadOnly(paymentProductFieldId: String) -> Bool {
        if !fieldIsPartOfAccountOnFile(paymentProductFieldId: paymentProductFieldId) {
            return false
        }
        else {
            return accountOnFile.isReadOnly(field: paymentProductFieldId)
        }
    }
    
    func mask(forField paymentProductFieldId: String) -> String? {
        let field = self.paymentItem.paymentProductField(withId: paymentProductFieldId )
        
        return field?.displayHints.mask
    }
    
    func unmaskedFieldValues() -> [AnyHashable: Any] {
        var unmaskedFieldValues: [AnyHashable: Any] = [:]
        let paymentProductFields = paymentItem.fields.paymentProductFields
        for field in paymentProductFields {
            let fieldId = field.identifier
            if !fieldIsReadOnly(paymentProductFieldId: fieldId) {
                let unmaskedValue = self.unmaskedValue(forField: fieldId)
                unmaskedFieldValues[fieldId] = unmaskedValue
            }
        }
        return unmaskedFieldValues
    }
    func validateExcept(fieldNames exceptFieldNames: Set<String>) {
        errors.removeAllObjects()
        
        let request = self.paymentRequest();
        let paymentProductFields = paymentItem.fields.paymentProductFields
        for field in paymentProductFields {
            if !fieldIsPartOfAccountOnFile(paymentProductFieldId: field.identifier) {
                if self.unmaskedValue(forField: field.identifier) == "" {
                    let validators = field.dataRestrictions.validators.validators
                    var hasFixedValidator = false
                    for validator in validators {
                        if let fixedListValidator = validator as? ValidatorFixedList {
                            hasFixedValidator = true
                            let value = fixedListValidator.allowedValues[0]
                            setValue(value: value, forField: field.identifier)
                        }
                    }
                    // It's not possible to choose an empty string with a date picker
                    // If not set, we assume the first is chosen
                    if !hasFixedValidator && field.type == .dateString {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyMMdd"
                        setValue(value: formatter.string(from: Date()), forField: field.identifier)
                    }
                    
                    // It's not possible to choose an empty boolean with a switch
                    // If not set, we assume false is chosen
                    if !hasFixedValidator && field.type == .boolString {
                        setValue(value: "false", forField: field.identifier)
                    }
                }
                
                if exceptFieldNames.contains(field.identifier) {
                    continue
                }
                let fieldValue = self.unmaskedValue(forField: field.identifier )
                field.validateValue(value: fieldValue, for: request)
                errors.addObjects(from: field.errors)
            }
        }
    }
    
    func validate() {
        self.validateExcept(fieldNames: Set())
    }
}
