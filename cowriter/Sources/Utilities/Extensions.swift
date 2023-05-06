//
//  Extensions.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import Foundation
import SwiftUI

extension View {
    func customFont(_ size: CGFloat = 17, _ color: Color = Color.darkGrayFont) -> some View {
        self.modifier(FontModifier(font: Font.custom("Gill Sans", size: size, relativeTo: .body), color: color))
        //        self.modifier(FontModifier(font: Font.system(size: size), color: color))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
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
