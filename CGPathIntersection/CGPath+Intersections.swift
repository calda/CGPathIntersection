//
//  CGPath+Intersections.swift
//  CGPathIntersection
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import CoreGraphics

extension CGPath {
    
    public func intersects(_ path: CGPath) -> Bool {
        return self.intersectionPoints(with: path).count > 0
    }
    
    public func intersectionPoints(with path: CGPath) -> [CGPoint] {
        let pathImage1 = CGPathImage(from: self)
        let pathImage2 = CGPathImage(from: path)
        
        return pathImage1.intersectionPoints(with: pathImage2)
    }
    
}
