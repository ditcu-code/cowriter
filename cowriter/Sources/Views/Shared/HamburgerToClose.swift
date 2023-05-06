//
//  HamburgerToClose.swift
//  cowriter
//
//  Created by Aditya Cahyo on 28/04/23.
//

import SwiftUI

struct HamburgerToClose: View {
    @Binding var isOpened: Bool
    
    var width: CGFloat = 22
    var height: CGFloat = 2
    var degrees: Double = 45
    
    var body: some View {
        VStack(spacing: 5.5) {
            RoundedRectangle(cornerRadius: 5) // top
                .frame(width: width, height: height)
                .rotationEffect(.degrees(isOpened ? degrees : 0), anchor: .leading)
            
            RoundedRectangle(cornerRadius: 5)  // middle
                .frame(width: width, height: height)
                .scaleEffect(isOpened ? 0.0001 : 1, anchor: isOpened ? .trailing: .leading)
                .opacity(isOpened ? 0 : 1)
            
            RoundedRectangle(cornerRadius: 5) // bottom
                .frame(width: width, height: height)
                .rotationEffect(.degrees(isOpened ? -degrees : 0), anchor: .leading)
        }
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 150, damping: 20)){
                isOpened.toggle()
            }
        }
        .padding(5)
    }
}

struct HamburgerToClose_Previews: PreviewProvider {
    static var previews: some View {
        HamburgerToClose(isOpened: .constant(true))
    }
}
