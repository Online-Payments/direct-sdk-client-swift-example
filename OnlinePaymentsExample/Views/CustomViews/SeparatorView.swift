//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import UIKit

class SeparatorView : UIView {
    
    var separatorString: NSString?
    
    override func draw(_ rect: CGRect) {
        let textBufferSpace = (separatorString != nil) ? 20.0 as CGFloat : 0 as CGFloat
        let drawSize = (separatorString != nil) ? separatorString!.size(withAttributes: [:]) : CGSize(width: 0, height: 0)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath()
        let endX = (self.bounds.width/2 - drawSize.width/2) - textBufferSpace
        let firstEndPoint = CGPoint(x: endX, y: self.bounds.midY)
        let firstStartPoint = CGPoint(x: 0, y: self.bounds.midY)
        let secondStartPoint = CGPoint(x: self.bounds.width - endX, y: self.bounds.midY)
        let secondEndPoint = CGPoint(x: self.bounds.width, y: self.bounds.midY)
        
        path.move(to: firstStartPoint)
        path.addLine(to: firstEndPoint)
        path.move(to: secondStartPoint)
        path.addLine(to: secondEndPoint)
        context?.setStrokeColor(UIColor.darkGray.cgColor)
        path.stroke()
        
        if let nsstr = separatorString {
            let drawRect = CGRect(x: firstEndPoint.x + textBufferSpace, y: self.bounds.midY - drawSize.height/2, width: drawSize.width, height: drawSize.height)
            nsstr.draw(in:drawRect , withAttributes: [NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        }
    }
}
