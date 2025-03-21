//
//  Extensions.swift
//  WeatherApp
//
//  Created by Jyoti on 19/03/25.
//

import Foundation


import Foundation
import SwiftUI

// Extension for rounded Double to 0 decimals
extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

extension Color {
    static let navyBlue = Color(red: 0/255, green: 0/255, blue: 128/255) // #000080
    static let lightBlue = Color(red: 0/255, green: 119/255, blue: 182/255) // Equivalent to #0077B6

}
// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
