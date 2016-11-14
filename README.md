# CGPathIntersection
A CoreGraphics library to identify points where two CGPaths intersect.

##Installation
You can use `CGPathIntersection` in your own projects through [Carthage](https://github.com/Carthage/Carthage).

Add `github "calda/CGPathIntersection"` to your Cartfile and run `carthage update`.

##Usage

`import CGPathIntersection`

CGPathIntersection uses a global CGSize to be more efficient when performing many calculations. You must include the following line in your project setup:

```swift
CGPathImage.size = CGSize(...)
```

Once configured, you can perform a quick calculation:
```swift
let path1 = CGPath(...)
let path2 = CGPath(...)
        
path1.intersects(path: path2) //returns a boolean
path1.intersectionPoints(with: path2) //returns an array of points
```

If performing many calculations, you can increase performance by creating a `CGPathImage`. Any calculations performed on a pre-existing `CGPathImage` will run faster than the same calculation performed on a raw `CGPath`.
```swift
let pathImage = CGPathImage(from: CGPath(...))
let otherPathImages: [CGPathImage] = [...]

let intersectsAny = otherPathImages.filter{ path.intersects(path: $0) }.count > 0

```
