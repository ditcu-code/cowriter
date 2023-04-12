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
        self.modifier(CustomFontModifier(font: Font.custom("Gill Sans", size: 17, relativeTo: .body)))
    }
}

struct CustomFontModifier: ViewModifier {
    var font: Font
    
    func body(content: Content) -> some View {
        content
            .font(font)
    }
}
