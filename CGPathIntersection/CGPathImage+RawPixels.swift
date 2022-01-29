//
//  CGPathImage+RawPixels.swift
//  CGPathIntersection
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import CoreGraphics

#if canImport(AppKit)
import AppKit
#endif

struct RawImage {
    #if !canImport(UIKit)
    /// On macOS we can just call `NSBitmapImageRep.colorAt(x:y)`
    let bitmapRep: NSBitmapImageRep
    #else
    // On iOS we have to access the pixel data manually by computing
    // the correct offset in the image data's buffer
    let pixels: UnsafePointer<UInt8>
    #endif
    let options: Options
    
    struct Options {
        let bounds: CGRect
        let bytesPerRow: Int
        let bitsPerComponent: Int
    }
}

extension CGPathImage {
    
    var rawImage: RawImage? {
        guard let cgImage = image.cgImage else { return nil}
        
        let boundingBox = CGRect(
            origin: CGPoint(x: Int(self.boundingBox.origin.x), y: Int(self.boundingBox.origin.y)),
            size: CGSize(width: cgImage.width, height: cgImage.height))
        
        let options = RawImage.Options(
            bounds: boundingBox,
            bytesPerRow: cgImage.bytesPerRow,
            bitsPerComponent: cgImage.bitsPerComponent)
        
        #if !canImport(UIKit)
        guard
            let tiffRep = image.tiffRepresentation,
            let bitmapRep = NSBitmapImageRep(data: tiffRep)
        else { return nil }
        
        return RawImage(bitmapRep: bitmapRep, options: options)
        #else
        guard
            let pixelData = cgImage.dataProvider?.data,
            let pixels = CFDataGetBytePtr(pixelData)
        else { return nil }
        
        return RawImage(pixels: pixels, options: options)
        #endif
    }
    
}

extension RawImage {
    #if !canImport(UIKit)
    func colorAt(x: Int, y: Int) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard
            let nsColor = bitmapRep.colorAt(
                x: x - Int(options.bounds.minX),
                y: Int(options.bounds.maxY) - y - 1)
        else { return (0, 0, 0, 0) }
        
        var (red, green, blue, alpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    #else
    func colorAt(x: Int, y: Int) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        // rows in memory are always powers of two, leaving empty bytes to pad as necessary.
        let rowWidth = Int(options.bytesPerRow / 4)
        let pixelPointer = ((rowWidth * (y - Int(options.bounds.minY))) + (x - Int(options.bounds.minX))) * 4
        
        // data[pixelInfo] is a pointer to the first in a series of four UInt8s (r, g, b, a)
        func byte(_ offset: Int) -> CGFloat {
            return CGFloat(pixels[pixelPointer + offset]) / 256.0
        }
        
        // buffer in BGRA format
        return (red: byte(2), green: byte(1), blue: byte(0), alpha: byte(3))
    }
    #endif
}

