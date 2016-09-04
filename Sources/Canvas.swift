// Canvas.swift
// Created by Will Field-Thompson on 09/03/16

/// Conforming types can be drawn upon.
/// - note:
/// Default implementations mean that only `put(color:at:)` is
/// necessary to conform to `Canvas`, but more advanced algorithms
/// are possible if you provide your own.
public protocol Canvas {
    /// Color is the type used to represent colors on this Canvas.
    /// `RGB` and `RGBA` are convenient types to use here, but there's
    /// no reason to restrict it.
    associatedtype Color

    /// Draw a pixel of `color` at the point.
    func put(color: Color, at: Point)

    /// Draw a single line of `color` from one point to the next.
    func stroke(_ line: Line, color: Color)

    /// Draw lines connecting these points of `color`.
    func stroke(_ polygon: Polygon, color: Color)

    // TODO: Ellipses and filling
    /*
    func strokeEllipse(center: Point, radius: Float)
    func fillEllipse(center: Point, radius: Float)
    func fillPolygon(points: [Point])
    */
}

public extension Canvas {
    public func stroke(_ line: Line, color: Color) {
        bresenham(from: line.from, to: line.to, color: color)
    }
    
    public func stroke(_ poly: Polygon, color: Color) {
        let points = poly.verticies
        
        guard points.count > 1 else {
            print("Can't stroke polygon of \(points.count) points.")
            return
        }
        
        for i in 0 ..< points.count - 1 {
            let line = Line(from: points[i], to: points[i+1])
            stroke(line, color: color)
        }
    }
}

// - MARK: Bresenham / Default Canvas implementations

// The following is borrowed almost straight from my high school graphics
// project. It should be readable enough, but I haven't had the time to
// properly comment it yet. -- Will

/// Order points by `x`.
private func order(_ p1: inout Point, _ p2: inout Point) {
    if p2.x < p1.x {
        let swap = p1
        p1 = p2
        p2 = swap
    }
}

/// Perform a single bresenham step.
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
    /// Stroke a line using the bresenham algorithm.
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
