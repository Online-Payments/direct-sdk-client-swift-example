//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import Foundation
import UIKit

class FormRowButton: FormRow {
    var title: String
    var target: Any
    var action: Selector
    var buttonType: ExampleButtonType = .primary

    init(title: String, target: Any, action: Selector) {
        self.title = title
        self.target = target
        self.action = action
    }
}
