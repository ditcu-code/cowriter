//
//  Extensions.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import Foundation
import SwiftUI

extension View {
    func customFont(_ size: CGFloat = 17, _ color: Color = Color.defaultFont) -> some View {
        self.modifier(FontModifier(font: Font.custom("Gill Sans", size: size), color: color))
    }
}

extension Color {
    static let defaultFont = Color("DefaultFont")
    static let darkGrayFont = Color("DarkGrayFont")
    static let grayFont = Color("GrayFont")
    
}

struct FontModifier: ViewModifier {
    var font: Font
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}
