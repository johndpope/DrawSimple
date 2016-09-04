// Shape.swift
// Created by Will Field-Thompson on 09/03/16

/// A single point on a `Canvas`.
public typealias Point = (x: UInt32, y: UInt32)

/// A line on a `Canvas`.
public struct Line {
    let from: Point
    let to: Point
}

/// An open polygon, drawable as a series of lines
public protocol Polygon {
    var verticies: [Point] { get }
}
