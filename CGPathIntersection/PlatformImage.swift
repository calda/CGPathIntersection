//
//  CGImageContext.swift
//  CGImageContext
//
//  Created by Cal Stephens on 1/22/22.
//  Copyright © 2022 Cal Stephens. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

extension PlatformImage {
    // Renders an image of the given size, using the created `CGContext`
    static func render(
        size: CGSize,
        draw: (CGContext) -> Void)
        -> PlatformImage
    {
        #if canImport(UIKit)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()!
        
        draw(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
        #elseif canImport(AppKit)
        let imageRepresentation = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0)!
        
        let context = NSGraphicsContext(bitmapImageRep: imageRepresentation)!
        
        draw(context.cgContext)
        
        let image = NSImage(size: size)
        image.addRepresentation(imageRepresentation)
        return image
        #endif
    }
}

#if !canImport(UIKit)
extension PlatformImage {
    var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
#endif
