//
//  SubscriptionView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct SubscriptionView: View {
    @Binding var isShowSheet: Bool
    @State private var selectedPlan: PlanEnum = PlanEnum.annual
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Upgrade to Pro")
                    .bold()
                    .font(.title)
                    .padding(.top, 5)
                Text("Unlimited chats")
                    .font(.footnote)
                    .foregroundColor(.grayFont)
            }.padding()
            
            VStack(spacing: 10) {
                ItemPlanView(plan: PlanEnum.annual, selectedPlan: $selectedPlan)
                ItemPlanView(plan: PlanEnum.monthly, selectedPlan: $selectedPlan)
            }.padding(.horizontal)
            
            VStack(spacing: 0) {
                
                Button {
                    print("continue")
                } label: {
                    Spacer()
                    Text("Continue").bold()
                        .padding(.vertical, 5)
                    Spacer()
                }.buttonStyle(.borderedProminent).tint(.orange)
                
                Button {
                    print("restore")
                } label: {
                    Text("Restore purchase")
                        .font(.footnote)
                        .bold().padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                .tint(.darkGrayFont)
                
                Text("Your monthly or annual subscription will automatically renew until you choose to cancel it. Cancel any time in the App Store at no additional cost; your subscription will then cease at the end of the current term.")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.defaultFont)
                
            }.padding()
            
            Spacer()
        }.dynamicTypeSize(.medium)
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(isShowSheet: .constant(true))
    }
}