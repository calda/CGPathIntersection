//
//  UIImage+RawPixels.swift
//  CGPathIntersection
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public typealias PixelData = (width: CGFloat, pixels: UnsafePointer<UInt8>)

public extension UIImage {
    
    var pixelData: PixelData? {
        guard let pixelData = self.cgImage?.dataProvider?.data else { return nil }
        guard let pixels = CFDataGetBytePtr(pixelData) else { return nil }
        return (self.size.width, pixels)
    }
    
}

//extension PixelData
extension UnsafePointer {
    
    func alphaAt(x: CGFloat, y: CGFloat, imageWidth: CGFloat) -> CGFloat {
        let pixelPointer: Int = ((Int(imageWidth) * Int(y)) + Int(x)) * 4
        
        //data[pixelInfo] is a pointer to the first in a series of four UInt8s (r, g, b, a)
        
        let pointedValue = (self[pixelPointer + 3] as? UInt8) ?? 0
        let colorAlpha = CGFloat(pointedValue) / CGFloat(255.0)
        
        return colorAlpha
    }
    
}
