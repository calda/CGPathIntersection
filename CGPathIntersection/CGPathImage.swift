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
    
    
    //MARK: - Render image for path
    
    public let path: CGPath
    public let boundingBox: CGRect
    public let image: UIImage?
    
    public init(from path: CGPath) {
        self.path = path
        self.boundingBox = path.boundingBoxOfPath
        
        UIGraphicsBeginImageContextWithOptions(boundingBox.size, false, 1.0)
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
        
        var translationToOrigin = CGAffineTransform(
            translationX: -boundingBox.minX,
            y: -boundingBox.minY)
        
        let pathAtOrigin = path.copy(using: &translationToOrigin) ?? path
        context.addPath(pathAtOrigin)
        context.closePath()
        context.drawPath(using: .stroke)
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    //MARK: - Calculate Intersections
    
    public func intersects(_ path: CGPathImage) -> Bool {
        return self.intersectionPoints(with: path).count > 0
    }
    
    
    public func intersectionPoints(with other: CGPathImage) -> [CGPoint] {
        
        //fetch raw pixel data
        guard let image1Raw = self.rawImage else { return [] }
        guard let image2Raw = other.rawImage else { return [] }
        
        var intersectionPixels = [CGPoint]()
        
        let intersectionRect = self.boundingBox.intersection(other.boundingBox)
        if intersectionRect.isEmpty { return [] }
        
        //iterate over intersection of bounding boxes
        for x in Int(intersectionRect.minX) ..< Int(intersectionRect.maxX) {
            for y in Int(intersectionRect.minY) ..< Int(intersectionRect.maxY) {
                
                let color1 = image1Raw.pixels.colorAt(x: x, y: y, options: image1Raw.options)
                let color2 = image2Raw.pixels.colorAt(x: x, y: y, options: image2Raw.options)
                
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
    
    func intersectionsImage(with other: CGPathImage) -> UIImage {
        let totalBoundingBox = self.boundingBox.union(other.boundingBox)
        
        UIGraphicsBeginImageContextWithOptions(totalBoundingBox.size, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext(),
            let image1 = self.image,
            let image2 = other.image else
        {
            fatalError()
        }
        
        context.setAllowsAntialiasing(false)
        context.setShouldAntialias(false)
        
        func rectInImage(from rect: CGRect) -> CGRect {
            return CGRect(
                origin: CGPoint(
                    x: rect.origin.x - totalBoundingBox.minX,
                    y: rect.origin.y - totalBoundingBox.minY),
                size: rect.size)
        }
        
        image1.draw(at: rectInImage(from: self.boundingBox).origin)
        image2.draw(at: rectInImage(from: other.boundingBox).origin)
        
        context.setFillColor(UIColor.red.cgColor)
        
        for intersection in self.intersectionPoints(with: other) {
            context.beginPath()
            context.addEllipse(in:
                rectInImage(
                    from: CGRect(origin: intersection, size: .zero)
                    .insetBy(dx: -20, dy: -20)))
            
            context.closePath()
            context.drawPath(using: .fill)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
}
