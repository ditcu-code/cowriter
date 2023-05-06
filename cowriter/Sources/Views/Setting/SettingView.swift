//
//  SettingView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/05/23.
//

import SwiftUI

struct SettingView: View {
    @State private var isShowSheet: Bool = true
    @State private var selectedPlan: PlanEnum = PlanEnum.annual
    
    var body: some View {
        List {
            Section("Subscription") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Free Plan").bold().tracking(0.5)
                        Text("Limited messages").font(.footnote)
                    }
                    .padding(.vertical, 5)
                    .foregroundColor(.darkGrayFont)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isShowSheet.toggle()
                }
            }
            .navigationTitle("Setting")
        }
        
        .sheet(isPresented: $isShowSheet) {
            
            SubscriptionView(isShowSheet: $isShowSheet)
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
