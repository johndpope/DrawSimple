// Color.swift
// Created by Will Field-Thompson on 09/03/16

/// Represents a color in RGBA format.
public struct RGBA {
    public let red: UInt8
    public let green: UInt8
    public let blue: UInt8
    public let alpha: Float

    /// RGBA(0, 0, 0, 1)
    public static var black: RGBA { return RGBA(solid: .black) }

    /// RGBA(255, 255, 255, 1)
    public static var white: RGBA { return RGBA(solid: .white) }
    
    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = Float(alpha) / 255
                                        
        assert(0 <= self.alpha && self.alpha < 256)
    }

    /// Copy the color and set the alpha channel to 1.
    public init(solid rgb: RGB) {
        self.init(red: rgb.red,
                  green: rgb.green,
                  blue: rgb.blue,
                  alpha: 255)
    }
}

/// Represents a color in RGB format.
public struct RGB {
    public let red: UInt8
    public let green: UInt8
    public let blue: UInt8
    
    public static var black: RGB { return RGB(red: 0, green: 0, blue: 0) }
    public static var white: RGB { return RGB(red: 255, green: 255, blue: 255) }
}

/// Blend an RGBA color into an RGB color, producing an RGB color.
public func +(lhs: RGB, rhs: RGBA) -> RGB {
    let lha = 1 - rhs.alpha
    let r = (Float(lhs.red) * lha) + (Float(rhs.red) * rhs.alpha)
    let g = (Float(lhs.green) * lha) + (Float(rhs.green) * rhs.alpha)
    let b = (Float(lhs.blue) * lha) + (Float(rhs.blue) * rhs.alpha)
    return RGB(red: UInt8(r), green: UInt8(g), blue: UInt8(b))
}

/// Blend an RGBA color into an RGB color, producing an RGB color.
public func +=(lhs: inout RGB, rhs: RGBA) {
    lhs = lhs + rhs
}
