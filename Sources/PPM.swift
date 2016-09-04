// PPM.swift
// Created by Will Field-Thompson on 09/03/16

/// A canvas which can output to a PPM file.
/// - note:
/// This is `RGBA` even though PPM doesn't support alpha channel.
/// `RGBA` values will be blended into the background color
/// supplied in the initializer.
public class PPMImage: Canvas {
    public typealias Color = RGBA

    /// The backing buffer of RGB pixels. These will be output into
    /// the file on `.write(to:)`.
    private var buffer: [RGB]

    /// Width of the image.
    public let width: UInt32

    /// Height of the image.
    public let height: UInt32

    /// Write the contents of the image as a PPM file to the
    /// `TextOutputStream`.
    public func write<O: TextOutputStream>(to out: inout O) {
        // Max color is 255 (for UInt8)
        out.write("P3 \(width) \(height) 255\n")
        for pix in buffer {
            // If we use newlines, no line is ever longer than 70
            // characters.
            out.write("\(pix.red) \(pix.green) \(pix.blue)\n")
        }
    }

    /// Get the index into the buffer for the `Point`.
    private func index(for p: Point) -> Int {
        assert(0 <= p.x && p.x <= UInt32.max,
               "\(p) out of range.")
        assert(0 <= p.y && p.y <= UInt32.max,
               "\(p) out of range.")
        return Int(p.x) + (Int(width) * Int(p.y))
    }

    /// Blend the color into the buffer at the point.
    public func put(color: Color, at point: Point) {
        buffer[index(for: point)] += color
    }

    /// - parameter width: The width of the image.
    /// - parameter height: The height of the image.
    /// - parameter background: The background color of the image. The
    /// image will contain nothing but this color on initialization.
    /// Defaults to `.black`.
    public init(width: UInt32,
                height: UInt32,
                background: RGB = .black) {
        self.width = width
        self.height = height
        buffer = Array(repeating: background,
                       count: Int(width) * Int(height))
    }
}
