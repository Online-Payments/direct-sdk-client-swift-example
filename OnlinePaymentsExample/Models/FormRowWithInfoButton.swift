//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import UIKit

class FormRowWithInfoButton: FormRow {
    var showInfoButton: Bool {
        return tooltip != nil
    }
    var tooltip: FormRowTooltip?
    
}
