//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 20/02/2023
// Copyright © 2023 Global Collect Services. All rights reserved.
// 

import Foundation
import OnlinePaymentsKit

extension ValidationError {
    @objc func errorMessageKey() -> String? {
        return nil
    }
}

extension ValidationErrorAllowed {
    @objc override func errorMessageKey() -> String? {
        return "allowedInContext"
    }
}

extension ValidationErrorEmailAddress {
    override func errorMessageKey() -> String? {
        return "emailAddress"
    }
}

extension ValidationErrorExpirationDate {
    override func errorMessageKey() -> String? {
        return "expirationDate"
    }
}

extension ValidationErrorFixedList {
    override func errorMessageKey() -> String? {
        return "fixedList"
    }
}

extension ValidationErrorInteger {
    override func errorMessageKey() -> String? {
        return "integer"
    }
}

extension ValidationErrorIsRequired {
    override func errorMessageKey() -> String? {
        return "required"
    }
}

extension ValidationErrorLuhn {
    override func errorMessageKey() -> String? {
        return "luhn"
    }
}

extension ValidationErrorNumericString {
    override func errorMessageKey() -> String? {
        return "numericString"
    }
}

extension ValidationErrorRegularExpression {
    override func errorMessageKey() -> String? {
        return "regularExpression"
    }
}

extension ValidationErrorTermsAndConditions {
    override func errorMessageKey() -> String? {
        return "termsAndConditions"
    }
}

extension ValidationErrorIBAN {
    override func errorMessageKey() -> String? {
        return "IBAN"
    }
}
