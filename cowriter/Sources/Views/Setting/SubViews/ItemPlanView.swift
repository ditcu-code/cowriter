//
//  ItemPlanView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct ItemPlanView: View {
    @Binding var selectedPackage: PaywallPackage?
    @EnvironmentObject private var revenueCatService: RevenueCatService
    
    @State private var monthlyTotal: Decimal?
    
    private let outerShape = RoundedRectangle(cornerRadius: 8)
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(revenueCatService.packages) { pkg in
                let plan: PlanEnum = PlanEnum(rawValue: pkg.id) ?? PlanEnum.annual
                let isSelected = selectedPackage?.id == plan.rawValue
                let isMonthlyPlan = pkg.id == PlanEnum.monthly.rawValue
                
                VStack {
                    HStack {
                        Label("", systemImage: isSelected ? "record.circle.fill" : "circle")
                            .foregroundColor(isSelected ? .accentColor : .gray.opacity(0.5))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(NSLocalizedString(isMonthlyPlan ? "_monthly" : "_annual", comment: ""))
                                .tracking(2)
                                .font(.footnote)
                                .foregroundColor(.defaultFont)
                            HStack {
                                Text(pkg.displayPrice)
                                    .font(.headline)
                                    .scaleEffect(1.1)
                                if let disc = monthlyTotal, !isMonthlyPlan {
                                    Text(formatCurrency(disc, code: pkg.currencyCode))
                                        .font(.footnote)
                                        .strikethrough()
                                        .foregroundColor(.defaultFont)
                                }
                            }
                            Text("\(isMonthlyPlan ? pkg.displayPrice : formatCurrency(pkg.price / Decimal(12), code: pkg.currencyCode)) \(NSLocalizedString(plan.desc, comment: ""))")
                                .font(.subheadline)
                                .foregroundColor(.grayFont)
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
                            if !isMonthlyPlan {
                                Triangle()
                                    .fill(isSelected ? Color.accentColor : .gray.opacity(0.5))
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
                        .stroke(isSelected ? Color.accentColor : .gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                )
                .onTapGesture {
                    selectedPackage = pkg
                }
                .onAppear {
                    if isMonthlyPlan {
                        monthlyTotal = pkg.price * Decimal(12)
                    } else {
                        selectedPackage = pkg
                    }
                }
            }
        }.padding(.horizontal)
    }

    private func formatCurrency(_ value: Decimal, code: String?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let code = code { formatter.currencyCode = code }
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "\(value)"
    }
}

struct ItemPlanView_Previews: PreviewProvider {
    static var previews: some View {
        ItemPlanView(selectedPackage: .constant(nil))
            .environmentObject(RevenueCatService(entitlementManager: EntitlementManager()))
    }
}
