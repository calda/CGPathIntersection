# CGPathIntersection

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcalda%2FCGPathIntersection%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/calda/CGPathIntersection) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcalda%2FCGPathIntersection%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/calda/CGPathIntersection)

**CGPathIntersection** is a library for iOS, macOS, and tvOS that identifies points where two `CGPath`s intersect.

Surprisingly, this is not provided out-of-the-box by `CoreGraphics`. Intersections can be calculated analytically for simple geometric shapes (especially straight lines), but that method becomes rather challenging when considering a `CGPath` can be arbitrarily complex. `CGPathIntersection` solves this problem by rendering each path into an image and then finding the exact pixels where they intersect.

## Installation
#### [Swift Package Manager](https://www.swift.org/package-manager/)
Add the following dependency to your package definition:

```swift
.package(
  name: "CGPathIntersection",
  url: "https://github.com/calda/CGPathIntersection.git",
  from: "4.0")
```

#### [Carthage](https://github.com/Carthage/Carthage)
Add `github "calda/CGPathIntersection"` to your Cartfile

#### [CocoaPods](https://github.com/cocoapods/cocoapods)
Add `pod 'CGPathIntersection'` to your Podfile

## Usage

```swift
import CGPathIntersection

let path1 = CGPath(...)
let path2 = CGPath(...)
        
path1.intersects(path2) // returns a boolean
path1.intersectionPoints(with: path2) // returns an array of points
```

If performing many calculations, you can increase performance by creating a `CGPathImage`. Any calculations performed on a pre-existing `CGPathImage` will run faster than the same calculation performed on a raw `CGPath`.

```swift
import CGPathIntersection

let pathImage = CGPathImage(from: CGPath(...))
let otherPathImages: [CGPathImage] = [...]

let intersectingPaths = otherPathImages.filter { pathImage.intersects($0) }
```

## Example

CGPathIntersection was created as a component of **[Streets](http://github.com/calda/Streets)**, a prototype SpriteKit game that simulates managing a network of streets. Streets uses CGPathIntersection to connect individual roads together with physical intersections. When a car reaches an intersection, it makes a random turn onto one of the other connected roads.

<p align="center">
    <img src="images/streets.gif" width=250px> <img src="images/streets 2.gif" width=250px>
</p>

Streets also has some support for more complex paths, like roundabouts:

<p align="center">
    <img src="images/roundabout.jpg" width=250px>
</p>
