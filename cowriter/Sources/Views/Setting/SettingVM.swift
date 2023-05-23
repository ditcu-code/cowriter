//
//  SettingVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 19/05/23.
//

import SwiftUI

class SettingVM: ObservableObject {
    @Published var showSupportSheet = false
    @Published var showSubscriptionSheet = false
    
    @Published var subject: String = ""
    @Published var email: String = ""
    @Published var content: String = "Write something here..."
    
    @Published var profileManager = ProfileManager()
    
    private let cloudKitData = PublicCloudKitService()
    
    func sendSupportMessage() async {
        if let user = profileManager.user {
            await cloudKitData.sendSupportMessage(
                CustSupport(subject: subject, email: email, content: content, user: user)
            )
        }
    }
    
    func openLinkTermsAndCondition() {
        guard let url = URL(string: "https://bit.ly/swiftaichat-termsandcondition") else { return }
        UIApplication.shared.open(url)
    }
    
    func openLinkPrivacyPolicy() {
        guard let url = URL(string: "https://bit.ly/swiftaichat-privacy-policy") else { return }
        UIApplication.shared.open(url)
    }
    
}
