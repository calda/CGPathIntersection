# CGPathIntersection
A CoreGraphics library to identify points where two CGPaths intersect.

## Installation
You can use `CGPathIntersection` in your own projects through [Carthage](https://github.com/Carthage/Carthage).

Add `github "calda/CGPathIntersection"` to your Cartfile and run `carthage update`.

## Usage

```swift
import CGPathIntersection

let path1 = CGPath(...)
let path2 = CGPath(...)
        
path1.intersects(path: path2) //returns a boolean
path1.intersectionPoints(with: path2) //returns an array of points
```

If performing many calculations, you can increase performance by creating a `CGPathImage`. Any calculations performed on a pre-existing `CGPathImage` will run faster than the same calculation performed on a raw `CGPath`.
```swift
import CGPathIntersection

let pathImage = CGPathImage(from: CGPath(...))
let otherPathImages: [CGPathImage] = [...]

let intersectingPaths = otherPathImages.filter{ path.intersects(path: $0) }.map{ $0.path }

```
