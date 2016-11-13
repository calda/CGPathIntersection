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
    
    ///Set globally on start up
    public static var size: CGSize!
    
    
    //MARK: - Draw individual image
    
    let image: UIImage?
    let boundingBox: CGRect
    
    public init(from path: CGPath) {
        self.boundingBox = path.boundingBoxOfPath
        
        UIGraphicsBeginImageContextWithOptions(CGPathImage.size, false, 1.0)
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
    
    
    public func intersects(path: CGPathImage) -> Bool {
        return self.intersectionPoints(with: path).count > 0
    }
    
    
    public func intersectionPoints(with other: CGPathImage) -> [CGPoint] {
        
        //fetch raw pixel data
        guard let (width1, pixels1) = self.image?.pixelData else { return [] }
        guard let (width2, pixels2) = other.image?.pixelData else { return [] }
        
        var intersectionPixels = [CGPoint]()
        
        let rect = self.boundingBox.intersection(other.boundingBox)
        
        //iterate over intersection of bounding boxes
        for x in Int(rect.origin.x) ... Int(rect.origin.x + rect.size.width) {
            for y in Int(rect.origin.y) ..< Int(rect.origin.y + rect.size.height) {
                
                let alpha1 = pixels1.alphaAt(x: CGFloat(x), y: CGFloat(y), imageWidth: width1)
                let alpha2 = pixels2.alphaAt(x: CGFloat(x), y: CGFloat(y), imageWidth: width2)
                
                //if intersection
                if alpha1 > 0.05 && alpha2 > 0.05 {
                    intersectionPixels.append(CGPoint(x: x, y: y))
                }
            }
        }
        
        return intersectionPixels.coalescePoints()
    }
    
}






