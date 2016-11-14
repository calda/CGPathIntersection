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
    
    public func combined(with other: UIImage) -> UIImage {
        let size = CGSize(width: max(self.size.width, other.size.width),
                          height: max(self.size.height, other.size.height))
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(at: .zero)
        other.draw(at: .zero)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
}

//extension PixelData
extension UnsafePointer {
    
    func alphaAt(x: Int, y: Int, imageWidth: CGFloat) -> CGFloat {
        let pixelPointer: Int = ((Int(imageWidth) * y) + x) * 4
        
        //data[pixelInfo] is a pointer to the first in a series of four UInt8s (r, g, b, a)
        let pointedValue = (self[pixelPointer + 3] as? UInt8) ?? 0
        let colorAlpha = CGFloat(pointedValue) / CGFloat(255.0)
        
        return colorAlpha
    }
    
}
