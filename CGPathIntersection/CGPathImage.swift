//
//  CGPathBitmap.swift
//  CGPathIntersection
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import UIKit
import CoreGraphics

public struct CGPathImage {
    
    ///Set globally on start up
    public static var size: CGSize!
    
    
    //MARK: - Draw individual image
    
    public let image: UIImage?
    
    public init(from path: CGPath) {
        
        UIGraphicsBeginImageContextWithOptions(CGPathImage.size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            self.image = nil
            return
        }
        
        let transparentBlack = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        context.setStrokeColor(transparentBlack)
        context.setLineWidth(2.0)
        context.setAllowsAntialiasing(false)
        context.setShouldAntialias(false)
        
        context.beginPath()
        context.addPath(path)
        context.closePath()
        context.drawPath(using: .stroke)
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    public func intersects(path: CGPathImage) -> Bool {
        return self.intersectionPoints(with: path).count > 0
    }
    
    public func intersectionPoints(with path: CGPathImage) -> [CGPoint] {
        return []
    }
    
}
