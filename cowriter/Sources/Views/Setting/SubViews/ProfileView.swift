//
//  ProfileView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 14/05/23.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: SettingVM
    @FocusState private var nameFocus
    
    var body: some View {
        let joinDate = vm.profileManager.user?.joinDate ?? Date()
        
        HStack() {
            Image(systemName: "person").padding(.horizontal, 5)
            VStack(alignment: .leading, spacing: 0) {
                TextField("Your name", text: $vm.profileManager.name)
                    .onSubmit {
                        vm.profileManager.changeName()
                    }
                    .focused($nameFocus)
                Text("Joined \(joinDate.toMonthYearString())")
                    .font(.footnote)
                    .foregroundColor(.defaultFont)
            }
            Spacer()
        }
        .onChange(of: vm.profileManager.isProfileTap, perform: { newValue in
            nameFocus = newValue
        })
        .onTapGesture {
            vm.profileManager.isProfileTap.toggle()
        }
        .padding(.vertical, 5)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ProfileView(vm: SettingVM())
        }
    }
}
