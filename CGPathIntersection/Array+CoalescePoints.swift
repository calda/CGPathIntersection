//
//  Array+CoalescePoints.swift
//  CGPathIntersection
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import CoreGraphics


protocol Point {
    var x: CGFloat { get set }
    var y: CGFloat { get set }
}

extension CGPoint : Point { }


extension Array where Element : Point {
    
    func coalescePoints() -> [CGPoint] {
        var groups = [[Element]]()
        
        //build groups of nearby pixels
        for point in self {
            //start a new group if there are none
            if groups.count == 0 {
                groups.append([point])
                continue
            }
            
            for i in 0 ..< groups.count {
                //if all lines are two pixels wide, 6.0 is plenty for an individual cluster
                let maximumDistance: CGFloat = 6.0
                let distance = groups[i].first?.distance(to: point)
                
                if let distanceToGroup = distance, distanceToGroup < maximumDistance {
                    groups[i].append(point)
                    continue
                }
            }
        }
        
        //map groups to average values
        return groups.map { group in
            let xSum = group.reduce(0) { $0 + $1.x }
            let ySum = group.reduce(0) { $0 + $1.y }
            
            return CGPoint(x: Int(xSum / CGFloat(group.count)),
                           y: Int(ySum / CGFloat(group.count)))
        }
    }
    
}

extension Point {
    
    func distance(to point: Point) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
    
}
