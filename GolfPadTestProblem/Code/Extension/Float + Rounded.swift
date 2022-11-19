//
//  Float + Rounded.swift
//  GolfPadTestProblem
//
//  Created by Ruslan Abbasov on 19.11.2022.
//

import Foundation

extension Float {
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow( 10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
