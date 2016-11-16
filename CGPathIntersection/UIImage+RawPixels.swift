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

typealias RawImage = (options: ImageOptions, pixels: UnsafePointer<UInt8>)
typealias ImageOptions = (size: CGSize, bytesPerRow: Int, bitsPerComponent: Int)

extension UIImage {
    
    var rawImage: RawImage? {
        guard let cgImage = self.cgImage else { return nil }
        guard let pixelData = cgImage.dataProvider?.data else { return nil }
        guard let pixels = CFDataGetBytePtr(pixelData) else { return nil }
        
        return ((self.size, cgImage.bytesPerRow, cgImage.bitsPerComponent), pixels)
    }
    
}

extension UnsafePointer {
    
    func colorAt(x: Int, y: Int, options: ImageOptions) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        //rows in memory are always powers of two, leaving empty bytes to pad as necessary.
        let rowWidth = Int(options.bytesPerRow / 4)
        let pixelPointer: Int = ((rowWidth * y) + x) * 4
        
        //data[pixelInfo] is a pointer to the first in a series of four UInt8s (r, g, b, a)
        func byte(_ offset: Int) -> CGFloat {
            return CGFloat(self[pixelPointer + offset] as? UInt8 ?? 0) / 255.0
        }
        
        //buffer in BGRA format
        return (red: byte(2), green: byte(1), blue: byte(0), alpha: byte(3))
    }
    
}
