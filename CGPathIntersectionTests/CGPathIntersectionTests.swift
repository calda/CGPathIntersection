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
    
    func testNoIntersectionFromParallelDiagonalLines() {
        let path1 = CGPath.line(from: CGPoint(x: 50, y: 10), to: CGPoint(x: 170, y: 120))
        let path2 = CGPath.line(from: CGPoint(x: 10, y: 10), to: CGPoint(x: 120, y: 120))
        
        XCTAssertFalse(path1.intersects(path: path2))
        XCTAssertEqual(path1.intersectionPoints(with: path2).count, 0)
    }
    
    func testWithLinesWhereBoundingBoxesDontIntersect() {
        let path1 = CGPath.line(from: CGPoint(x: 50, y: 10), to: CGPoint(x: 60, y: 100))
        let path2 = CGPath.line(from: CGPoint(x: 130, y: 10), to: CGPoint(x: 140, y: 120))
        
        XCTAssertFalse(path1.intersects(path: path2))
        XCTAssertEqual(path1.intersectionPoints(with: path2).count, 0)
    }
    
    func testOneIntersectionFromPerpendicularLines() {
        let path1 = CGPath.line(from: CGPoint(x: 20, y: 20), to: CGPoint(x: 180, y: 180))
        let path2 = CGPath.line(from: CGPoint(x: 180, y: 20), to: CGPoint(x: 20, y: 180))
        
        XCTAssertTrue(path1.intersects(path: path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first!
        XCTAssertEqualWithAccuracy(intersectionPoint.x, 100.0, accuracy: 1.0)
        XCTAssertEqualWithAccuracy(intersectionPoint.y, 100.0, accuracy: 1.0)
    }
    
    func testOneIntersectionFromArbitraryLines() {
        let path1 = CGPath.line(from: CGPoint(x: 123.2, y: 145.5), to: CGPoint(x: 32.87, y: 67.1))
        let path2 = CGPath.line(from: CGPoint(x: 104.7, y: 153.3), to: CGPoint(x: 20.0, y: 10.0))
        
        XCTAssertTrue(path1.intersects(path: path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first!
        XCTAssertEqualWithAccuracy(intersectionPoint.x, 76.0, accuracy: 1.0)
        XCTAssertEqualWithAccuracy(intersectionPoint.y, 104.0, accuracy: 1.0)
    }
    
    func testZeroIntersectionFromCircleAndLine() {
        let path1 = CGPath.line(from: CGPoint(x: 180, y: 20), to: CGPoint(x: 180, y: 180))
        let path2 = CGPath.circle(at: CGPoint(x: 100, y: 20), withRadius: 20.0)
        
        XCTAssertFalse(path1.intersects(path: path2))
        XCTAssertEqual(path1.intersectionPoints(with: path2).count, 0)
    }
    
    func testTwoIntersectionFromCircleAndLine() {
        let path1 = CGPath.line(from: CGPoint(x: 20, y: 20), to: CGPoint(x: 180, y: 180))
        let path2 = CGPath.circle(at: CGPoint(x: 100, y: 100), withRadius: 40.0)
        
        XCTAssertTrue(path1.intersects(path: path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 2)
        
        let intersectionPoint1 = intersectionPoints[0]
        XCTAssertEqualWithAccuracy(intersectionPoint1.x, 72.0, accuracy: 1.0)
        XCTAssertEqualWithAccuracy(intersectionPoint1.y, 72.0, accuracy: 1.0)
        
        let intersectionPoint2 = intersectionPoints[1]
        XCTAssertEqualWithAccuracy(intersectionPoint2.x, 128.0, accuracy: 1.0)
        XCTAssertEqualWithAccuracy(intersectionPoint2.y, 128.0, accuracy: 1.0)
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
    
    static func circle(at center: CGPoint, withRadius radius: CGFloat) -> CGPath {
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true)
        return bezierPath.cgPath
    }
    
}
