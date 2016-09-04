// Canvas.swift
// Created by Will Field-Thompson on 09/03/16

public protocol Canvas {
    associatedtype Color
    func put(color: Color, at: Point)

    func strokeLine(from: Point, to: Point, color: Color)
    func strokePolygon(points: [Point], color: Color, complete: Bool)
    
    /* // Should get around to these things eventually
    func strokeEllipse(center: Point, radius: Float)
    func fillEllipse(center: Point, radius: Float)
   
    func fillPolygon(points: [Point])
    */
}

// Default implementations mean that only `put(color:at:)` is
// necessary to conform to `Canvas`, but more advanced algorithms
// are possible if you provide your own.
public extension Canvas {
    public func strokeLine(from: Point, to: Point, color: Color) {
        bresenham(from: from, to: to, color: color)
    }
    public func strokePolygon(points: [Point], color: Color) {
        strokePolygon(points: points, color: color, complete: true)
    }
    public func strokePolygon(points: [Point], color: Color, complete: Bool) {
        guard points.count > 1 else {
            print("Can't stroke polygon of \(points.count) points.")
            return
        }
        
        for i in 0 ..< points.count - 1 {
            strokeLine(from: points[i],
                       to: points[i+1],
                       color: color)
        }
        
        if complete {
            strokeLine(from: points.last!,
                       to: points.first!,
                       color: color)
        }

    }
}

// Borrowed from my high school graphics project -- Will

private func order(_ p1: inout Point, _ p2: inout Point) {
    if p2.x < p1.x {
        let swap = p1
        p1 = p2
        p2 = swap
    }
}

private func bstep(accumulator: inout Int,
                   majorCounter: inout UInt32,
                   minorCounter: inout UInt32,
                   majorDelta: Int,
                   minorDelta: Int,
                   majorStep: Bool,
                   minorStep: Bool) {
    accumulator -= minorDelta
    if accumulator < 0 {
        if minorStep { minorCounter += 1 }
        else { minorCounter -= 1 }
        accumulator += majorDelta
    }
    if majorStep { majorCounter += 1 }
    else { majorCounter -= 1 }
}

fileprivate extension Canvas {
    fileprivate func bresenham(from p1: Point, to p2: Point, color: Color) {
        var (greatP, littleP) = (p2, p1)
        order(&littleP, &greatP)
        let dx = Int(greatP.x - littleP.x)
        let dy = greatP.y > littleP.y ?
                 Int(greatP.y - littleP.y) :
                 Int(littleP.y - greatP.y)
        // y goes up if littleP.y is smaller than greatP.y, else it goes down
        let ystep = greatP.y > littleP.y
        var p = littleP
        if dx > dy {
            var acc = dx / 2
            while p.x <= greatP.x {
                put(color: color, at: p)
                bstep(accumulator: &acc,
                     majorCounter: &p.x,
                     minorCounter: &p.y,
                     majorDelta: dx,
                     minorDelta: dy,
                     majorStep: true,
                     minorStep: ystep)
            }
        } else {
            let count = max(dx, dy) + 1
            var acc = dy / 2
            for _ in 0 ..< count {
                put(color: color, at: p)
                bstep(accumulator: &acc,
                     majorCounter: &p.y,
                     minorCounter: &p.x,
                     majorDelta: dy,
                     minorDelta: dx,
                     majorStep: ystep,
                     minorStep: true)
            }
        }
    }
}
