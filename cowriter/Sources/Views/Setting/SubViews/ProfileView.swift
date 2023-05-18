//
//  ProfileView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 14/05/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var vm: ProfileManager = ProfileManager()
    @FocusState private var nameFocus
    
    var body: some View {
        let joinDate = vm.user?.joinDate ?? Date()
        HStack() {
            Image(systemName: "person").padding(.horizontal, 5)
            VStack(alignment: .leading, spacing: 0) {
                TextField("Your name", text: $vm.name)
                    .onSubmit {
                        vm.changeName()
                    }
                    .focused($nameFocus)
                Text("Joined \(joinDate.toMonthYearString())")
                    .font(.footnote)
                    .foregroundColor(.defaultFont)
            }
            Spacer()
        }
        .onChange(of: vm.isProfileTap, perform: { newValue in
            nameFocus = newValue
        })
        .onTapGesture {
            vm.isProfileTap.toggle()
        }
        .padding(.vertical, 5)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ProfileView()
        }
    }
}
