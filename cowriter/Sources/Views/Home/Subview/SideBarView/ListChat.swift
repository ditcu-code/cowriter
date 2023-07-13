//
//  ListChat.swift
//  cowriter
//
//  Created by Aditya Cahyo on 13/07/23.
//

import SwiftUI

struct ListChat: View {
    @ObservedObject var vm: HomeVM
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    @State private var editMode: EditMode = .inactive
    @State private var isEditing: Bool = false
    
    var body: some View {
        let hasReachedLimit = vm.allChats.count >= 3
        let isPro = entitlementManager.hasPro
        
        VStack(alignment: .leading) {
            if !vm.allChats.isEmpty {
                HStack {
                    Text("chats").bold()
                    Spacer()
                    Button("edit") {
                        isEditing.toggle()
                    }
                }
            } else {
                EmptyChatView()
            }
            List {
                ForEach(vm.allChats, id: \.self) { item in
                    let isActiveChat = vm.currentChat == item
                    HStack {
                        Text(item.wrappedTitle)
                            .lineLimit(1)
                            .foregroundColor(.grayFont)
                            .font(Font.system(.body, design: .serif))
                        Spacer()
                        if isActiveChat {
                            Circle()
                                .frame(width: 9, height: 9)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        vm.currentChat = item
                        vm.closeSideBar()
                    }
                }.onDelete(perform: editMode == .active ? vm.removeChat : nil)
            }
            .listStyle(.plain)
            .id(editMode.isEditing.description)
            .environment(\.editMode, $editMode)
            .onChange(of: isEditing, perform: { isEditing in
                editMode = isEditing ? .active : .inactive
            })
            
            Spacer()
            NewChatButton {
                if hasReachedLimit && !isPro {
                    vm.prompterHasFocus = false
                    vm.showSubscriptionSheet.toggle()
                } else {
                    vm.currentChat = nil
                    vm.closeSideBar()
                    vm.errorMessage = nil
                    vm.favoriteFilterIsOn = false
                }
            }
        }.padding()
    }
}

fileprivate struct EmptyChatView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "tray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75)
                Text("no_chats_yet").font(.headline)
                Spacer()
            }.foregroundColor(.gray.opacity(0.7))
            Spacer()
        }
    }
}

fileprivate struct NewChatButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Spacer()
            Label("new_chat", systemImage: "plus").font(.headline)
            Spacer()
        }.buttonStyle(.bordered)
    }
}

struct ListChat_Previews: PreviewProvider {
    static var previews: some View {
        ListChat(vm: HomeVM())
    }
}
