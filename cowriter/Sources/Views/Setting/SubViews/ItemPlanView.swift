//
//  ItemPlanView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI
import StoreKit

struct ItemPlanView: View {
    @Binding var selectedProduct: Product?
    @State private var monthlyTotal: Decimal?
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    private let outerShape = RoundedRectangle(cornerRadius: 8)
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(purchaseManager.products) { product in
                let plan: PlanEnum = PlanEnum(rawValue: product.id) ?? PlanEnum.annual
                let isSelected = selectedProduct?.id == plan.rawValue
                let isMonthlyPlan = product.id == PlanEnum.monthly.rawValue
                
                VStack {
                    HStack {
                        Label("", systemImage: isSelected ? "record.circle.fill" : "circle")
                            .foregroundColor(isSelected ? .blue : .gray.opacity(0.5))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(plan.recurring.uppercased())
                                .tracking(2)
                                .customFont(14, .defaultFont)
                            HStack {
                                Text(isMonthlyPlan ? plan.title : product.displayPrice).bold()
                                if let disc = monthlyTotal, !isMonthlyPlan {
                                    Text(product.priceFormatStyle.format(disc))
                                        .font(.footnote)
                                        .strikethrough()
                                        .foregroundColor(.defaultFont)
                                }
                            }
                            Text("\(isMonthlyPlan ? product.displayPrice : product.priceFormatStyle.format(product.price / 12)) \(plan.desc)")
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
                    selectedProduct = product
                }
                .onAppear {
                    if isMonthlyPlan {
                        monthlyTotal = product.price * 12
                    } else {
                        selectedProduct = product
                    }
                }
            }
        }.padding(.horizontal)
    }
}

//struct ItemPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemPlanView()
//            .environmentObject(PurchaseManager(entitlementManager: EntitlementManager()))
//    }
//}
