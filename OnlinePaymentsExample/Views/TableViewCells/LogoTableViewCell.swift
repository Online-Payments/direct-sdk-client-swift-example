//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit

class LogoTableViewCell: ImageTableViewCell {
    override class var reuseIdentifier: String { return "logo-cell" }

    private static let imageWidth: CGFloat = 140
    
    static func cellSize(width: CGFloat, for row: FormRowSmallLogo) -> CGSize {
        return CGSize(width: LogoTableViewCell.imageWidth, height:size(transformedFrom: row.image.size, targetWidth: LogoTableViewCell.imageWidth).height)
    }
    
    override func layoutSubviews() {
        let width = LogoTableViewCell.imageWidth as CGFloat
        let leftMargin = self.frame.midX - width/2
        let height = LogoTableViewCell.size(transformedFrom: (displayImage?.size)!, targetWidth: LogoTableViewCell.imageWidth).height
            
        displayImageView.frame = CGRect(x: leftMargin, y: 0, width:width , height: height)
    }
}
