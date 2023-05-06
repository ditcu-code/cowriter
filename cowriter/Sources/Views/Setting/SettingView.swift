//
//  SettingView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/05/23.
//

import SwiftUI

struct SettingView: View {
    @State private var isShowSheet: Bool = false
    @State private var selectedPlan: PlanEnum = PlanEnum.annual
    
    var body: some View {
        List {
            Section("Subscription") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Free Plan").bold().tracking(0.5)
                        Text("Limited chats").font(.footnote)
                        Divider()
                        Button {
                            isShowSheet.toggle()
                        } label: {
                            Text("Upgrade to Pro")
                                .font(.footnote)
                                .foregroundColor(.orange)
                        }
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
            
            if #available(iOS 16.0, *) {
                SubscriptionView(isShowSheet: $isShowSheet)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            } else {
                VStack {
                    CowriterLogo(isPro: true).padding(.top, 100).padding(.bottom, 75)
                    SubscriptionView(isShowSheet: $isShowSheet)
                }
            }
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
