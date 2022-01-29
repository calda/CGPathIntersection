//
//  CGPathImage.swift
//  CGPathIntersection
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import CoreGraphics

public struct CGPathImage {
    
    
    //MARK: - Render image for path
    
    public let path: CGPath
    public let boundingBox: CGRect
    public let cgImage: CGImage?
    public let image: PlatformImage
    
    public init(from path: CGPath) {
        self.path = path
    
        // Perfectly-straight lines have a width or height of zero,
        // but to create a useful image we have to have at least one row/column of pixels.
        let absoluteBoundingBox = path.boundingBoxOfPath
        let boundingBox = CGRect(
          x: absoluteBoundingBox.origin.x,
          y: absoluteBoundingBox.origin.y,
          width: max(absoluteBoundingBox.size.width, 1),
          height: max(absoluteBoundingBox.size.height, 1))
        
        let image = PlatformImage.render(
            size: boundingBox.size,
            draw: { context in
                context.drawPath(path, in: boundingBox)
            })
        
        self.boundingBox = boundingBox
        self.image = image
        self.cgImage = image.cgImage
    }
    
    
    //MARK: - Calculate Intersections
    
    public func intersects(_ path: CGPathImage) -> Bool {
        return self.intersectionPoints(with: path).count > 0
    }
    
    
    public func intersectionPoints(with other: CGPathImage) -> [CGPoint] {
        
        //fetch raw pixel data
        guard
            let image1Raw = self.rawImage,
            let image2Raw = other.rawImage
        else { return [] }
        
        var intersectionPixels = [CGPoint]()
        
        let intersectionRect = self.boundingBox.intersection(other.boundingBox)
        if intersectionRect.isEmpty { return [] }
        
        //iterate over intersection of bounding boxes
        for x in Int(intersectionRect.minX) ..< Int(intersectionRect.maxX) {
            for y in Int(intersectionRect.minY) ..< Int(intersectionRect.maxY) {
                
                let color1 = image1Raw.colorAt(x: x, y: y)
                let color2 = image2Raw.colorAt(x: x, y: y)
                
                //intersection if significantly darker than 0.5
                if color1.alpha > 0.05 && color2.alpha > 0.05 {
                    intersectionPixels.append(CGPoint(x: x, y: y))
                }
            }
        }
        
        if intersectionPixels.count <= 1 { return intersectionPixels }
        return intersectionPixels.coalescePoints()
    }
    
    
    // MARK: - Debugging Helpers
    
    /// Renders an image displaying the two `CGPath`s,
    /// and highlighting their `intersectionPoints`
    func intersectionsImage(with other: CGPathImage) -> PlatformImage {
        let totalBoundingBox = self.boundingBox.union(other.boundingBox)
        
        return PlatformImage.render(
            size: totalBoundingBox.size,
            draw: { context in
                context.setAllowsAntialiasing(false)
                context.setShouldAntialias(false)
                
                func rectInImage(from rect: CGRect) -> CGRect {
                    return CGRect(
                        origin: CGPoint(
                            x: rect.origin.x - totalBoundingBox.minX,
                            y: rect.origin.y - totalBoundingBox.minY),
                        size: rect.size)
                }
                
                guard let image1 = self.cgImage, let image2 = other.cgImage else {
                    return
                }
                
                context.draw(image1, in: rectInImage(from: self.boundingBox))
                context.draw(image2, in: rectInImage(from: other.boundingBox))
                
                context.setFillColor(.rgba(1, 0, 0, 1))
                
                for intersection in self.intersectionPoints(with: other) {
                    context.beginPath()
                    context.addEllipse(in:
                        rectInImage(
                            from: CGRect(origin: intersection, size: .zero)
                            .insetBy(dx: -20, dy: -20)))
                    
                    context.closePath()
                    context.drawPath(using: .fill)
                }
            })
    }
    
    /// Renders an image by round-tripping each pixel through the `colorAt(x:y:)` method
    func rawPixelImage() -> PlatformImage {
        PlatformImage.render(size: boundingBox.size, draw: { context in
            guard let rawImage = rawImage else { return }
            
            let bounds = rawImage.options.bounds
            
            for x in Int(bounds.minX)...Int(bounds.maxY) {
                for y in Int(bounds.minY)...Int(bounds.maxY) {
                    let pixel = rawImage.colorAt(x: x, y: y)
                    let color = CGColor.rgba(pixel.red, pixel.green, pixel.blue, pixel.alpha)
                    context.setFillColor(color)
                    context.beginPath()
                    
                    context.addRect(CGRect(
                        x: x - Int(bounds.minY) - 5,
                        y: y - Int(bounds.minY) - 5,
                        width: 10,
                        height: 10))
                    
                    context.closePath()
                    context.drawPath(using: .fill)
                }
            }
        })
    }
}

extension CGContext {
    func drawPath(_ path: CGPath, in boundingBox: CGRect) {
        setStrokeColor(.rgba(0, 0, 0, 0.5))
        setLineWidth(2.0)
        setAllowsAntialiasing(false)
        setShouldAntialias(false)
        
        var translationToOrigin = CGAffineTransform(
            translationX: -boundingBox.minX,
            y: -boundingBox.minY)
        
        let pathAtOrigin = path.copy(using: &translationToOrigin) ?? path
        addPath(pathAtOrigin)
        drawPath(using: .stroke)
    }
}

extension CGColor {
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> CGColor {
        CGColor(
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            components: [r, g, b])!
            .copy(alpha: a)!
    }
}
