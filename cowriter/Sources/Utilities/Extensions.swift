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
            return self.modifier(FontModifier(font: Font.custom("Gill Sans", size: size, relativeTo: .body), color: color))
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
    static let answerBubble = Color("AnswerBubble")
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
    
    static var upAndLeft: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .trailing)
        )
    }
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

extension String {
    func removeNewLines(_ delimiter: String = "") -> String {
        self.replacingOccurrences(of: "\n", with: delimiter)
    }
}
