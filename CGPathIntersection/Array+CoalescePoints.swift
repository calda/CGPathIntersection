//
//  Array+CoalescePoints.swift
//  CGPathIntersection
//
//  Created by Cal Stephens on 11/13/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import CoreGraphics
import Foundation

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
            
            var addedToGroup = false
            
            //search for a nearby group to join
            for i in 0 ..< groups.count {
                let distances = groups[i].map{ $0.distance(to: point) }
                let miniumDistanceToGroup = distances.sorted().first
                
                if let minimumDistance = miniumDistanceToGroup, minimumDistance < 6.0 {
                    groups[i].append(point)
                    addedToGroup = true
                    break
                }
            }
            
            if !addedToGroup {
                groups.append([point])
            }
        }
        
        //map groups to average values
        return groups.map { group in
            let xSum = group.reduce(0) { $0 + $1.x }
            let ySum = group.reduce(0) { $0 + $1.y }
            
            return CGPoint(x: Int(round(xSum / CGFloat(group.count))),
                           y: Int(round(ySum / CGFloat(group.count))))
        }
    }
    
}

extension Point {
    
    func distance(to point: Point) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
    
}
