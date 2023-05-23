//
//  ThreeDotsLoading.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct ThreeDotsLoading: View {
    @State var loading = false
    
    var body: some View {
        HStack(spacing: 20) {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 10, height: 10)
                .scaleEffect(loading ? 1.5 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: loading)
            Circle()
                .fill(Color.accentColor)
                .frame(width: 10, height: 10)
                .scaleEffect(loading ? 1.5 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.2), value: loading)
            Circle()
                .fill(Color.accentColor)
                .frame(width: 10, height: 10)
                .scaleEffect(loading ? 1.5 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.4), value: loading)
        }
        .onAppear() {
            self.loading = true
        }
    }
}

struct ThreeDotsLoading_Previews: PreviewProvider {
    static var previews: some View {
        ThreeDotsLoading()
    }
}
