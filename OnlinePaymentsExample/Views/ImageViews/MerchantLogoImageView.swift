//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import UIKit

class MerchantLogoImageView: UIImageView {

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let logo = UIImage(named: "MerchantLogo")
        contentMode = .scaleAspectFit
        image = logo
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
