//
//  CGPathIntersectionTests.swift
//  CGPathIntersectionTests
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import XCTest
import CGPathIntersection

class CGPathIntersectionTests: XCTestCase {
    
    override func setUp() {
        CGPathImage.size = CGSize(width: 200, height: 200)
    }
    
    func testCreatesImageFromPath() {
        let path = CGPath.line(from: CGPoint(x: 20, y: 20), to: CGPoint(x: 180, y: 180))
        let pathImage = CGPathImage(from: path)
        
        XCTAssertNotNil(pathImage.image)
    }
    
    func testCombinesImage() {
        let path1 = CGPath.line(from: CGPoint(x: 20, y: 20), to: CGPoint(x: 180, y: 180))
        let pathImage1 = CGPathImage(from: path1)
        
        let path2 = CGPath.line(from: CGPoint(x: 180, y: 20), to: CGPoint(x: 20, y: 180))
        let pathImage2 = CGPathImage(from: path2)
        
        let combinedImage = pathImage1.image!.combined(with: pathImage2.image!)
        XCTAssertNotNil(combinedImage)
        
        let intersectionPixels = combinedImage.pixels(withAlphaDarkerThan: 0.6)
        XCTAssert(intersectionPixels.count > 0)
    }
    
}

extension CGPath {
    
    static func line(from start: CGPoint, to end: CGPoint) -> CGPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: start)
        bezierPath.addLine(to: end)
        bezierPath.close()
        
        return bezierPath.cgPath
    }
    
}
