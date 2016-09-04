public struct RGBA {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    let alpha: Float

    static var black: RGBA { return RGBA(solid: .black) }
    static var white: RGBA { return RGBA(solid: .white) }
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = Float(alpha) / 255
                                        
        assert(0 <= self.alpha && self.alpha < 256)
    }

    init(solid rgb: RGB) {
        self.init(red: rgb.red,
                  green: rgb.green,
                  blue: rgb.blue,
                  alpha: 255)
    }
}

public struct RGB {
    let red: UInt8
    let green: UInt8
    let blue: UInt8

    static var black: RGB { return RGB(red: 0, green: 0, blue: 0) }
    static var white: RGB { return RGB(red: 255, green: 255, blue: 255) }
}

func +(lhs: RGB, rhs: RGBA) -> RGB {
    let lha = 1 - rhs.alpha
    let r = (Float(lhs.red) * lha) + (Float(rhs.red) * rhs.alpha)
    let g = (Float(lhs.green) * lha) + (Float(rhs.green) * rhs.alpha)
    let b = (Float(lhs.blue) * lha) + (Float(rhs.blue) * rhs.alpha)
    return RGB(red: UInt8(r), green: UInt8(g), blue: UInt8(b))
}

func +=(lhs: inout RGB, rhs: RGBA) {
    lhs = lhs + rhs
}
