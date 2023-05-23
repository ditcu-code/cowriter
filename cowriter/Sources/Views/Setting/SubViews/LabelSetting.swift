//
//  LabelSetting.swift
//  cowriter
//
//  Created by Aditya Cahyo on 19/05/23.
//

import SwiftUI

struct LabelSetting: View {
    var icon: String
    var color: Color
    var label: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit().padding(7)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.opacity(0.9))
                )
                .padding(.trailing, 5)
            Text(label).font(.subheadline).foregroundColor(.darkGrayFont)
        }
    }
}

struct LabelSetting_Previews: PreviewProvider {
    static var previews: some View {
        LabelSetting(icon: "sun", color: .accentColor, label: "Hello")
    }
}
