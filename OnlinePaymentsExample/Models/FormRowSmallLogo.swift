//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit

class FormRowSmallLogo: FormRowImage {
    enum AnchorSide {
        case left
        case right
    }
    var anchorSide: AnchorSide
    override init(image: UIImage) {
        anchorSide = .left
        
        super.init(image: image)
    }
}
