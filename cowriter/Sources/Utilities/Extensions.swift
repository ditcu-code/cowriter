//
//  Extensions.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import Foundation
import SwiftUI

extension View {
    func customFont() -> some View {
        self.modifier(CustomFontModifier(font: Font.custom("Georgia", size: 17, relativeTo: .body)))
    }
}

extension Color {
    static let font = Color("Font")
    
}

struct CustomFontModifier: ViewModifier {
    var font: Font
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(Color.font)
    }
}
