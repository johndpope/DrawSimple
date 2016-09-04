public class PPMImage: Canvas {
    public typealias Color = RGBA
    private var buffer: [RGB]
    
    public let width: UInt32
    public let height: UInt32

    public func write<O: TextOutputStream>(to out: inout O) {
        // Max color is 255 (for UInt8)
        out.write("P3 \(width) \(height) 255\n")
        for pix in buffer {
            // If we use newlines, no line is ever longer than 70
            // characters.
            out.write("\(pix.red) \(pix.green) \(pix.blue)\n")
        }
    }

    private func index(for p: Point) -> Int {
        return Int(p.x) + (Int(width) * Int(p.y))
    }
    
    public func put(color: Color, at point: Point) {
        buffer[index(for: point)] += color
    }
 
    public init(width: UInt32,
                height: UInt32,
                background: RGB = .black) {
        self.width = width
        self.height = height
        buffer = Array(repeating: background,
                       count: Int(width) * Int(height))
    }
}
