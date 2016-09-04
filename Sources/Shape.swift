// Shape.swift
// Created by Will Field-Thompson on 09/03/16

public typealias Point = (x: UInt32, y: UInt32)

public struct Line {
    let from: Point
    let to: Point
}

public protocol Polygon {
    var points: [Point] { get }
}

public extension Polygon {
    var lines: AnySequence<Line> {
        let points = self.points
        var i = 0
        return AnySequence {
            return AnyIterator {
                guard i < points.count - 1 else { return nil }
                defer { i += 1 }
                return Line(from: points[i], to: points[i+1])
            }
        }
    }
}
