//
//  CGPathIntersectionTests.swift
//  CGPathIntersectionTests
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import XCTest
@testable import CGPathIntersection

//lines and circls with intersection positions verified by Wolfram Alpha
class CGPathIntersectionTests: XCTestCase {
    
    func testWithLinesWhereBoundingBoxesDontIntersect() {
        let path1 = CGPath.line(from: CGPoint(x: 50, y: 10), to: CGPoint(x: 60, y: 100))
        let path2 = CGPath.line(from: CGPoint(x: 130, y: 10), to: CGPoint(x: 140, y: 120))
        
        XCTAssertFalse(path1.intersects(path2))
        XCTAssertEqual(path1.intersectionPoints(with: path2).count, 0)
    }
    
    func testNoIntersectionFromParallelDiagonalLines() {
        let path1 = CGPath.line(from: CGPoint(x: 50, y: 10), to: CGPoint(x: 170, y: 120))
        let path2 = CGPath.line(from: CGPoint(x: 10, y: 10), to: CGPoint(x: 120, y: 120))
        
        XCTAssertFalse(path1.intersects(path2))
        XCTAssertEqual(path1.intersectionPoints(with: path2).count, 0)
    }
    
    func testOneIntersectionFromPerpendicularLines() {
        let path1 = CGPath.line(from: CGPoint(x: 20, y: 20), to: CGPoint(x: 180, y: 180))
        let path2 = CGPath.line(from: CGPoint(x: 180, y: 20), to: CGPoint(x: 20, y: 180))
        
        XCTAssertTrue(path1.intersects(path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first ?? .zero
        XCTAssertEqual(intersectionPoint.x, 100.0, accuracy: 1.0)
        XCTAssertEqual(intersectionPoint.y, 100.0, accuracy: 1.0)
    }
    
    func testOneIntersectionFromArbitraryLines() {
        let path1 = CGPath.line(from: CGPoint(x: 123.2, y: 145.5), to: CGPoint(x: 32.87, y: 67.1))
        let path2 = CGPath.line(from: CGPoint(x: 104.7, y: 153.3), to: CGPoint(x: 20.0, y: 10.0))
        
        XCTAssertTrue(path1.intersects(path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first ?? .zero
        XCTAssertEqual(intersectionPoint.x, 76.0, accuracy: 1.0)
        XCTAssertEqual(intersectionPoint.y, 104.0, accuracy: 1.0)
    }
    
    func testZeroIntersectionFromCircleAndLine() {
        let path1 = CGPath.line(from: CGPoint(x: 180, y: 20), to: CGPoint(x: 180, y: 180))
        let path2 = CGPath.circle(at: CGPoint(x: 100, y: 20), withRadius: 20.0)
        
        XCTAssertFalse(path1.intersects(path2))
        XCTAssertEqual(path1.intersectionPoints(with: path2).count, 0)
    }
    
    func testTwoIntersectionFromCircleAndLine() {
        let path1 = CGPath.line(from: CGPoint(x: 20, y: 20), to: CGPoint(x: 180, y: 180))
        let path2 = CGPath.circle(at: CGPoint(x: 100, y: 100), withRadius: 40.0)
        
        XCTAssertTrue(path1.intersects(path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 2)
        
        let intersectionPoint1 = intersectionPoints[0]
        XCTAssertEqual(intersectionPoint1.x, 72.0, accuracy: 1.0)
        XCTAssertEqual(intersectionPoint1.y, 72.0, accuracy: 1.0)
        
        let intersectionPoint2 = intersectionPoints[1]
        XCTAssertEqual(intersectionPoint2.x, 128.0, accuracy: 1.0)
        XCTAssertEqual(intersectionPoint2.y, 128.0, accuracy: 1.0)
    }
    
    func testRealLifeExample() {
        let path1 = CGPath.line(from: CGPoint(x: 403, y: 1167), to: CGPoint(x: 324, y: 462))
        let path2 = CGPath.line(from: CGPoint(x: 101, y: 835), to: CGPoint(x: 649, y: 659))
        
        XCTAssertTrue(path1.intersects(path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first ?? .zero
        XCTAssertEqual(intersectionPoint.x, 357.0, accuracy: 1.0)
        XCTAssertEqual(intersectionPoint.y, 753.0, accuracy: 1.0)
    }
    
    func testNegativeOrigin1() {
        let path1 = CGPath.line(from: .zero, to: CGPoint(x: 1000, y: 1000))
        let path2 = CGPath(rect: CGRect(x: -1000, y: -1000, width: 2000, height: 2000), transform: nil)
        
        XCTAssertTrue(path1.intersects(path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first ?? .zero
        XCTAssertEqual(intersectionPoint.x, 1000, accuracy: 2.0)
        XCTAssertEqual(intersectionPoint.y, 1000, accuracy: 2.0)
    }
    
    func testNegativeOrigin2() {
        let path1 = CGPath.line(from: .zero, to: CGPoint(x: -1000, y: 1000))
        let path2 = CGPath(rect: CGRect(x: -1000, y: -1000, width: 2000, height: 2000), transform: nil)
        
        XCTAssertTrue(path1.intersects(path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first ?? .zero
        XCTAssertEqual(intersectionPoint.x, -1000, accuracy: 2.0)
        XCTAssertEqual(intersectionPoint.y, 1000, accuracy: 2.0)
    }
    
    func testNegativeOrigin3() {
        let path1 = CGPath.line(from: .zero, to: CGPoint(x: 1000, y: -1000))
        let path2 = CGPath(rect: CGRect(x: -1000, y: -1000, width: 2000, height: 2000), transform: nil)
        
        XCTAssertTrue(path1.intersects(path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first ?? .zero
        XCTAssertEqual(intersectionPoint.x, 1000, accuracy: 2.0)
        XCTAssertEqual(intersectionPoint.y, -1000, accuracy: 2.0)
    }
    
    func testNegativeOrigin4() {
        let path1 = CGPath.line(from: .zero, to: CGPoint(x: -1000, y: -1000))
        let path2 = CGPath(rect: CGRect(x: -1000, y: -1000, width: 2000, height: 2000), transform: nil)
        
        XCTAssertTrue(path1.intersects(path2))
        
        let intersectionPoints = path1.intersectionPoints(with: path2)
        XCTAssertEqual(intersectionPoints.count, 1)
        
        let intersectionPoint = intersectionPoints.first ?? .zero
        XCTAssertEqual(intersectionPoint.x, -1000, accuracy: 2.0)
        XCTAssertEqual(intersectionPoint.y, -1000, accuracy: 2.0)
    }
  
    func testIntersectionGithubIssue2() {
        let path0 = CGMutablePath()
        path0.move(to: CGPoint(x: 798.6, y: 575.5))
        path0.addLine(to: CGPoint(x: 798.6, y: 573.5))
        path0.addLine(to: CGPoint(x: 794.4, y: 573.5))
        path0.addLine(to: CGPoint(x: 794.4, y: 575.5))
        path0.move(to: CGPoint(x: 798.6, y: 573.5))
        path0.addLine(to: CGPoint(x: 798.6, y: 569.5))
        path0.addLine(to: CGPoint(x: 794.4, y: 569.5))
        path0.addLine(to: CGPoint(x: 794.4, y: 573.5))
        path0.move(to: CGPoint(x: 798.6, y: 569.5))
        path0.addLine(to: CGPoint(x: 798.6, y: 562.5))
        path0.addLine(to: CGPoint(x: 794.4, y: 562.5))
        path0.addLine(to: CGPoint(x: 794.4, y: 569.5))
        path0.move(to: CGPoint(x: 798.6, y: 562.5))
        path0.addLine(to: CGPoint(x: 798.59, y: 537.798))
        path0.addLine(to: CGPoint(x: 794.41, y: 538.202))
        path0.addLine(to: CGPoint(x: 794.4, y: 562.5))
        path0.move(to: CGPoint(x: 798.59, y: 537.798))
        path0.addLine(to: CGPoint(x: 793.035, y: 504.98))
        path0.addLine(to: CGPoint(x: 788.965, y: 506.02))
        path0.addLine(to: CGPoint(x: 794.41, y: 538.202))
        path0.move(to: CGPoint(x: 793.035, y: 504.98))
        path0.addLine(to: CGPoint(x: 780.489, y: 466.827))
        path0.addLine(to: CGPoint(x: 776.511, y: 468.173))
        path0.addLine(to: CGPoint(x: 788.965, y: 506.02))
        path0.move(to: CGPoint(x: 780.489, y: 466.827))
        path0.addLine(to: CGPoint(x: 770.461, y: 438.249))
        path0.addLine(to: CGPoint(x: 766.539, y: 439.751))
        path0.addLine(to: CGPoint(x: 776.511, y: 468.173))
        path0.move(to: CGPoint(x: 770.461, y: 438.249))
        path0.addLine(to: CGPoint(x: 762.422, y: 419.654))
        path0.addLine(to: CGPoint(x: 758.578, y: 421.346))
        path0.addLine(to: CGPoint(x: 766.539, y: 439.751))
        path0.move(to: CGPoint(x: 762.422, y: 419.654))
        path0.addLine(to: CGPoint(x: 759.393, y: 413.091))
        path0.addLine(to: CGPoint(x: 755.607, y: 414.909))
        path0.addLine(to: CGPoint(x: 758.578, y: 421.346))
        path0.move(to: CGPoint(x: 759.393, y: 413.091))
        path0.addLine(to: CGPoint(x: 756.438, y: 407.192))
        path0.addLine(to: CGPoint(x: 752.562, y: 408.808))
        path0.addLine(to: CGPoint(x: 755.607, y: 414.909))
        path0.move(to: CGPoint(x: 756.438, y: 407.192))
        path0.addLine(to: CGPoint(x: 754.474, y: 401.282))
        path0.addLine(to: CGPoint(x: 750.526, y: 402.718))
        path0.addLine(to: CGPoint(x: 752.562, y: 408.808))
        path0.move(to: CGPoint(x: 754.474, y: 401.282))
        path0.addLine(to: CGPoint(x: 752.492, y: 396.336))
        path0.addLine(to: CGPoint(x: 748.508, y: 397.664))
        path0.addLine(to: CGPoint(x: 750.526, y: 402.718))
        path0.move(to: CGPoint(x: 752.492, y: 396.336))
        path0.addLine(to: CGPoint(x: 751.519, y: 392.423))
        path0.addLine(to: CGPoint(x: 747.481, y: 393.577))
        path0.addLine(to: CGPoint(x: 748.508, y: 397.664))
        path0.move(to: CGPoint(x: 751.519, y: 392.423))
        path0.addLine(to: CGPoint(x: 750.46, y: 389.246))
        path0.addLine(to: CGPoint(x: 746.54, y: 390.754))
        path0.addLine(to: CGPoint(x: 747.481, y: 393.577))
        path0.move(to: CGPoint(x: 750.46, y: 389.246))
        path0.addLine(to: CGPoint(x: 749.037, y: 385.991))
        path0.addLine(to: CGPoint(x: 744.963, y: 387.009))
        path0.addLine(to: CGPoint(x: 746.54, y: 390.754))
        path0.move(to: CGPoint(x: 749.037, y: 385.991))
        path0.addLine(to: CGPoint(x: 749.1, y: 384))
        path0.addLine(to: CGPoint(x: 744.9, y: 384))
        path0.addLine(to: CGPoint(x: 744.963, y: 387.009))
        path0.move(to: CGPoint(x: 749.1, y: 384))
        path0.addLine(to: CGPoint(x: 748.95, y: 381.72))
        path0.addLine(to: CGPoint(x: 745.05, y: 383.28))
        path0.addLine(to: CGPoint(x: 744.9, y: 384))
        path0.move(to: CGPoint(x: 748.95, y: 381.72))
        path0.addLine(to: CGPoint(x: 747.747, y: 380.335))
        path0.addLine(to: CGPoint(x: 744.253, y: 382.665))
        path0.addLine(to: CGPoint(x: 745.05, y: 383.28))
        path0.move(to: CGPoint(x: 747.747, y: 380.335))
        path0.addLine(to: CGPoint(x: 747.037, y: 378.991))
        path0.addLine(to: CGPoint(x: 742.963, y: 380.009))
        path0.addLine(to: CGPoint(x: 744.253, y: 382.665))
        path0.move(to: CGPoint(x: 747.037, y: 378.991))
        path0.addLine(to: CGPoint(x: 746.519, y: 374.923))
        path0.addLine(to: CGPoint(x: 742.481, y: 376.077))
        path0.addLine(to: CGPoint(x: 742.963, y: 380.009))
        path0.move(to: CGPoint(x: 746.519, y: 374.923))
        path0.addLine(to: CGPoint(x: 745.007, y: 371.882))
        path0.addLine(to: CGPoint(x: 740.993, y: 373.118))
        path0.addLine(to: CGPoint(x: 742.481, y: 376.077))
        path0.move(to: CGPoint(x: 745.007, y: 371.882))
        path0.addLine(to: CGPoint(x: 744.595, y: 368.86))
        path0.addLine(to: CGPoint(x: 740.405, y: 369.14))
        path0.addLine(to: CGPoint(x: 740.993, y: 373.118))
        path0.move(to: CGPoint(x: 744.595, y: 368.86))
        path0.addLine(to: CGPoint(x: 744.571, y: 364.655))
        path0.addLine(to: CGPoint(x: 740.429, y: 365.345))
        path0.addLine(to: CGPoint(x: 740.405, y: 369.14))
        path0.move(to: CGPoint(x: 744.571, y: 364.655))
        path0.addLine(to: CGPoint(x: 743.526, y: 362.447))
        path0.addLine(to: CGPoint(x: 739.474, y: 363.553))
        path0.addLine(to: CGPoint(x: 740.429, y: 365.345))
        path0.move(to: CGPoint(x: 743.526, y: 362.447))
        path0.addLine(to: CGPoint(x: 743.076, y: 359.181))
        path0.addLine(to: CGPoint(x: 738.924, y: 359.819))
        path0.addLine(to: CGPoint(x: 739.474, y: 363.553))
        path0.move(to: CGPoint(x: 743.076, y: 359.181))
        path0.addLine(to: CGPoint(x: 742.588, y: 356.28))
        path0.addLine(to: CGPoint(x: 738.412, y: 356.72))
        path0.addLine(to: CGPoint(x: 738.924, y: 359.819))
        path0.move(to: CGPoint(x: 742.588, y: 356.28))
        path0.addLine(to: CGPoint(x: 742.098, y: 349.9))
        path0.addLine(to: CGPoint(x: 737.902, y: 350.1))
        path0.addLine(to: CGPoint(x: 738.412, y: 356.72))
        path0.move(to: CGPoint(x: 742.098, y: 349.9))
        path0.addLine(to: CGPoint(x: 742.1, y: 346))
        path0.addLine(to: CGPoint(x: 737.9, y: 346))
        path0.addLine(to: CGPoint(x: 737.902, y: 350.1))
        path0.move(to: CGPoint(x: 742.1, y: 346))
        path0.addLine(to: CGPoint(x: 742.1, y: 343.5))
        path0.addLine(to: CGPoint(x: 737.9, y: 343.5))
        path0.addLine(to: CGPoint(x: 737.9, y: 346))
        path0.move(to: CGPoint(x: 742.1, y: 343.5))
        path0.addLine(to: CGPoint(x: 742.1, y: 342))
        path0.addLine(to: CGPoint(x: 737.9, y: 342))
        path0.addLine(to: CGPoint(x: 737.9, y: 343.5))
        path0.move(to: CGPoint(x: 742.1, y: 342))
        path0.addLine(to: CGPoint(x: 742.1, y: 340))
        path0.addLine(to: CGPoint(x: 737.9, y: 340))
        path0.addLine(to: CGPoint(x: 737.9, y: 342))
        path0.move(to: CGPoint(x: 742.1, y: 340))
        path0.addLine(to: CGPoint(x: 742.087, y: 338.732))
        path0.addLine(to: CGPoint(x: 737.913, y: 338.268))
        path0.addLine(to: CGPoint(x: 737.9, y: 340))
        path0.move(to: CGPoint(x: 742.087, y: 338.732))
        path0.addLine(to: CGPoint(x: 743.561, y: 326.901))
        path0.addLine(to: CGPoint(x: 739.439, y: 326.099))
        path0.addLine(to: CGPoint(x: 737.913, y: 338.268))
        path0.move(to: CGPoint(x: 743.561, y: 326.901))
        path0.addLine(to: CGPoint(x: 745.45, y: 321.28))
        path0.addLine(to: CGPoint(x: 741.55, y: 319.72))
        path0.addLine(to: CGPoint(x: 739.439, y: 326.099))
        path0.move(to: CGPoint(x: 745.45, y: 321.28))
        path0.addLine(to: CGPoint(x: 747.421, y: 317.349))
        path0.addLine(to: CGPoint(x: 743.579, y: 315.651))
        path0.addLine(to: CGPoint(x: 741.55, y: 319.72))
        path0.move(to: CGPoint(x: 747.421, y: 317.349))
        path0.addLine(to: CGPoint(x: 764.412, y: 278.369))
        path0.addLine(to: CGPoint(x: 760.588, y: 276.631))
        path0.addLine(to: CGPoint(x: 743.579, y: 315.651))
        path0.move(to: CGPoint(x: 764.412, y: 278.369))
        path0.addLine(to: CGPoint(x: 769.902, y: 267.89))
        path0.addLine(to: CGPoint(x: 766.098, y: 266.11))
        path0.addLine(to: CGPoint(x: 760.588, y: 276.631))
        path0.move(to: CGPoint(x: 769.902, y: 267.89))
        path0.addLine(to: CGPoint(x: 775.408, y: 254.877))
        path0.addLine(to: CGPoint(x: 771.592, y: 253.123))
        path0.addLine(to: CGPoint(x: 766.098, y: 266.11))
        path0.move(to: CGPoint(x: 775.408, y: 254.877))
        path0.addLine(to: CGPoint(x: 778.378, y: 249.439))
        path0.addLine(to: CGPoint(x: 774.622, y: 247.561))
        path0.addLine(to: CGPoint(x: 771.592, y: 253.123))
        path0.move(to: CGPoint(x: 778.378, y: 249.439))
        path0.addLine(to: CGPoint(x: 781.856, y: 241.983))
        path0.addLine(to: CGPoint(x: 778.144, y: 240.017))
        path0.addLine(to: CGPoint(x: 774.622, y: 247.561))
        path0.move(to: CGPoint(x: 781.856, y: 241.983))
        path0.addLine(to: CGPoint(x: 787.295, y: 232.59))
        path0.addLine(to: CGPoint(x: 783.705, y: 230.41))
        path0.addLine(to: CGPoint(x: 778.144, y: 240.017))
        path0.move(to: CGPoint(x: 787.295, y: 232.59))
        path0.addLine(to: CGPoint(x: 790.323, y: 228.042))
        path0.addLine(to: CGPoint(x: 786.677, y: 225.958))
        path0.addLine(to: CGPoint(x: 783.705, y: 230.41))
        path0.move(to: CGPoint(x: 790.323, y: 228.042))
        path0.addLine(to: CGPoint(x: 793.216, y: 222.211))
        path0.addLine(to: CGPoint(x: 789.784, y: 219.789))
        path0.addLine(to: CGPoint(x: 786.677, y: 225.958))
        path0.move(to: CGPoint(x: 793.216, y: 222.211))
        path0.addLine(to: CGPoint(x: 796.054, y: 219.913))
        path0.addLine(to: CGPoint(x: 792.946, y: 217.087))
        path0.addLine(to: CGPoint(x: 789.784, y: 219.789))
        path0.move(to: CGPoint(x: 796.054, y: 219.913))
        path0.addLine(to: CGPoint(x: 798.227, y: 216.695))
        path0.addLine(to: CGPoint(x: 794.773, y: 214.305))
        path0.addLine(to: CGPoint(x: 792.946, y: 217.087))
        path0.move(to: CGPoint(x: 798.227, y: 216.695))
        path0.addLine(to: CGPoint(x: 800.558, y: 213.408))
        path0.addLine(to: CGPoint(x: 797.442, y: 210.592))
        path0.addLine(to: CGPoint(x: 794.773, y: 214.305))
        path0.move(to: CGPoint(x: 800.558, y: 213.408))
        path0.addLine(to: CGPoint(x: 811.958, y: 201.512))
        path0.addLine(to: CGPoint(x: 809.042, y: 198.488))
        path0.addLine(to: CGPoint(x: 797.442, y: 210.592))
        path0.move(to: CGPoint(x: 811.958, y: 201.512))
        path0.addLine(to: CGPoint(x: 814.101, y: 200.288))
        path0.addLine(to: CGPoint(x: 811.899, y: 196.712))
        path0.addLine(to: CGPoint(x: 809.042, y: 198.488))
        path0.move(to: CGPoint(x: 814.101, y: 200.288))
        path0.addLine(to: CGPoint(x: 817.996, y: 197.849))
        path0.addLine(to: CGPoint(x: 816.004, y: 194.151))
        path0.addLine(to: CGPoint(x: 811.899, y: 196.712))
        path0.move(to: CGPoint(x: 817.996, y: 197.849))
        path0.addLine(to: CGPoint(x: 820.353, y: 196.919))
        path0.addLine(to: CGPoint(x: 818.647, y: 193.081))
        path0.addLine(to: CGPoint(x: 816.004, y: 194.151))
        path0.move(to: CGPoint(x: 820.353, y: 196.919))
        path0.addLine(to: CGPoint(x: 822.404, y: 195.896))
        path0.addLine(to: CGPoint(x: 820.596, y: 192.104))
        path0.addLine(to: CGPoint(x: 818.647, y: 193.081))
        path0.move(to: CGPoint(x: 822.404, y: 195.896))
        path0.addLine(to: CGPoint(x: 824.894, y: 194.754))
        path0.addLine(to: CGPoint(x: 823.143, y: 190.936))
        path0.addLine(to: CGPoint(x: 820.596, y: 192.104))
        
        let path1 = CGMutablePath()
        path1.move(to: CGPoint(x: 1049, y: 215.4))
        path1.addLine(to: CGPoint(x: 1005, y: 215.4))
        path1.addLine(to: CGPoint(x: 1005, y: 219.6))
        path1.addLine(to: CGPoint(x: 1049, y: 219.6))
        path1.move(to: CGPoint(x: 1005, y: 215.4))
        path1.addLine(to: CGPoint(x: 962.829, y: 215.407))
        path1.addLine(to: CGPoint(x: 963.171, y: 219.593))
        path1.addLine(to: CGPoint(x: 1005, y: 219.6))
        path1.move(to: CGPoint(x: 962.829, y: 215.407))
        path1.addLine(to: CGPoint(x: 900.634, y: 223.932))
        path1.addLine(to: CGPoint(x: 901.366, y: 228.068))
        path1.addLine(to: CGPoint(x: 963.171, y: 219.593))
        path1.move(to: CGPoint(x: 900.634, y: 223.932))
        path1.addLine(to: CGPoint(x: 866.398, y: 232.488))
        path1.addLine(to: CGPoint(x: 867.602, y: 236.512))
        path1.addLine(to: CGPoint(x: 901.366, y: 228.068))
        path1.move(to: CGPoint(x: 866.398, y: 232.488))
        path1.addLine(to: CGPoint(x: 851.413, y: 238.703))
        path1.addLine(to: CGPoint(x: 853.587, y: 242.297))
        path1.addLine(to: CGPoint(x: 867.602, y: 236.512))
        path1.move(to: CGPoint(x: 851.413, y: 238.703))
        path1.addLine(to: CGPoint(x: 843.666, y: 246.478))
        path1.addLine(to: CGPoint(x: 847.334, y: 248.522))
        path1.addLine(to: CGPoint(x: 853.587, y: 242.297))
        path1.move(to: CGPoint(x: 843.666, y: 246.478))
        path1.addLine(to: CGPoint(x: 833.607, y: 270.091))
        path1.addLine(to: CGPoint(x: 837.393, y: 271.909))
        path1.addLine(to: CGPoint(x: 847.334, y: 248.522))
        path1.move(to: CGPoint(x: 833.607, y: 270.091))
        path1.addLine(to: CGPoint(x: 824.782, y: 285.83))
        path1.addLine(to: CGPoint(x: 828.446, y: 287.883))
        path1.addLine(to: CGPoint(x: 837.393, y: 271.909))
        
        XCTAssertFalse(path0.intersects(path1))
    }

}


//MARK: - Convenience Helpers

extension CGPath {
    
    static func line(from start: CGPoint, to end: CGPoint) -> CGPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: start)
        bezierPath.addLine(to: end)
        bezierPath.close()
        
        return bezierPath.cgPath
    }
    
    static func circle(at center: CGPoint, withRadius radius: CGFloat) -> CGPath {
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        return bezierPath.cgPath
    }
    
}
