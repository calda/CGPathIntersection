//
//  UIImage+Combine.swift
//  CGPathIntersection
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import UIKit
import CoreGraphics

public extension UIImage {
    
    public func combined(with other: UIImage) -> UIImage {
        let largestWidth = max(self.size.width, other.size.width)
        let largestHeight = max(self.size.height, other.size.height)
        let size = CGSize(width: largestWidth, height: largestHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        let context = UIGraphicsGetCurrentContext()!
        context.setBlendMode(.hardLight)
        
        self.draw(at: .zero)
        other.draw(at: .zero)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    public func pixels(withAlphaDarkerThan: CGFloat) -> [CGPoint] {
        
        //fetch raw pixel data
        guard let pixelData = self.cgImage?.dataProvider?.data else { return [] }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        //check each pixel
        var pointsOfColor = [CGPoint]()
        
        for x in 0 ..< Int(self.size.width) {
            for y in 0 ..< Int(self.size.height) {
                
                let pixelInfo: Int = ((Int(self.size.width) * Int(y)) + Int(x)) * 4
                
                //get color information
                //let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                //let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                //let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                let colorAlpha = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
                
                //add to array if alpha matches
                if colorAlpha > withAlphaDarkerThan {
                    pointsOfColor.append(CGPoint(x: x, y: y))
                }
                
            }
        }
        
        return pointsOfColor
    }
    
}

