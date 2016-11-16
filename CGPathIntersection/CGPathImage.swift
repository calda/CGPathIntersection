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
        
        //create image that contains the origin & the path's entire bounding box
        let boundingBoxWithOrigin = CGRect(x: 0, y: 0,
                                           width: self.boundingBox.maxX + 20,
                                           height: self.boundingBox.maxY + 20)
        
        UIGraphicsBeginImageContextWithOptions(boundingBoxWithOrigin.size, false, 1.0)
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
    
    
    //MARK: - Calculate Intersections
    
    public func intersects(path: CGPathImage) -> Bool {
        return self.intersectionPoints(with: path).count > 0
    }
    
    
    public func intersectionPoints(with other: CGPathImage) -> [CGPoint] {
        guard let image1 = self.image, let image2 = other.image else { return [] }
        
        //fetch raw pixel data
        guard let image1Raw = image1.rawImage else { return [] }
        guard let image2Raw = image2.rawImage else { return [] }
        
        var intersectionPixels = [CGPoint]()
        
        let intersectionRect = self.boundingBox.intersection(other.boundingBox)
        if intersectionRect.isEmpty { return [] }
        
        //iterate over intersection of bounding boxes
        for x in Int(intersectionRect.minX) ... Int(intersectionRect.maxX) {
            for y in Int(intersectionRect.minY) ... Int(intersectionRect.maxY) {
                
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
    
}
