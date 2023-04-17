//
//  CircularLoading.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/04/23.
//

import SwiftUI

struct CircularLoading: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }
}

struct CircularLoading_Previews: PreviewProvider {
    static var previews: some View {
        CircularLoading()
    }
}
