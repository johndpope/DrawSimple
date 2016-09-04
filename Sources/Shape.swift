// Shape.swift
// Created by Will Field-Thompson on 09/03/16

/// A single point on a `Canvas`.
public typealias Point = (x: UInt32, y: UInt32)

/// A line on a `Canvas`.
public struct Line {
    public let from: Point
    public let to: Point
    public init(from: Point, to: Point) {
        self.from = from
        self.to = to
    }
}

/// An open polygon, drawable as a series of lines
public protocol Polygon {
    var verticies: [Point] { get }
}
