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
        let combined = image1.combined(with: image2)
        guard let (widthCombined, pixelsCombined) = combined.pixelData else { return [] }
        
        var intersectionPixels = [CGPoint]()
        
        let rect = self.boundingBox.intersection(other.boundingBox)
        if rect.isEmpty { return [] }
        
        //iterate over intersection of bounding boxes
        for x in Int(rect.minX) ... Int(rect.maxX) {
            for y in Int(rect.minY) ... Int(rect.maxY) {
                
                let alphaCombined = pixelsCombined.alphaAt(x: x, y: y, imageWidth: widthCombined)
                
                //intersection if significantly darker than 0.5
                if alphaCombined > 0.6 {
                    intersectionPixels.append(CGPoint(x: x, y: y))
                }
            }
        }
        
        if intersectionPixels.count <= 1 { return intersectionPixels }
        return intersectionPixels.coalescePoints()
    }
    
}
