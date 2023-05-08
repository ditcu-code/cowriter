//
//  ItemPlanView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct ItemPlanView: View {
    var plan: PlanEnum
    @Binding var selectedPlan: PlanEnum
    
    
    var body: some View {
        let isSelected = selectedPlan == plan
        let outerShape = RoundedRectangle(cornerRadius: 8)
        
        VStack {
            HStack {
                Label("", systemImage: isSelected ? "record.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray.opacity(0.5))
                VStack(alignment: .leading, spacing: 5) {
                    Text(plan.rawValue.uppercased())
                        .tracking(2)
                        .customFont(14, .defaultFont)
                    HStack {
                        Text(plan.title).bold()
                        if let disc = plan.discount {
                            Text(disc).font(.footnote).strikethrough()
                                .foregroundColor(.defaultFont)
                        }
                    }
                    Text(plan.desc)
                        .customFont(14, .grayFont)
                }
                Spacer()
            }
        }
        .padding()
        .contentShape(outerShape)
        .background(
            VStack {
                HStack {
                    Spacer()
                    if plan.discount != nil {
                        Triangle()
                            .fill(isSelected ? .blue : .gray.opacity(0.5))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Label("", systemImage: "percent")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .offset(x: 12, y: -12)
                            )
                    }
                }
                Spacer()
            }.clipShape(outerShape)
        )
        .overlay(
            outerShape
                .stroke(isSelected ? .blue : .gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .onTapGesture {
            selectedPlan = plan
        }
    }
}

struct ItemPlanView_Previews: PreviewProvider {
    static var previews: some View {
        ItemPlanView(plan: PlanEnum.monthly, selectedPlan: .constant(PlanEnum.monthly))
    }
}
