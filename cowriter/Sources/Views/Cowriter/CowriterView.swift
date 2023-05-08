//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @ObservedObject var vm: CowriterVM = CowriterVM()
    private var sideBarWidth: CGFloat = UIScreen.screenWidth - 100
    @FocusState var isFocusOnPrompt: Bool
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "Gill Sans", size: 18)!,
            .foregroundColor: UIColor.systemGray
        ]
    }
    
    var body: some View {
        let isActive = vm.currentChat == nil
        
        NavigationView {
            ZStack {
                HStack {
                    if vm.showSideBar {
                        SideBarView(vm: vm, width: sideBarWidth)
                    }
                    VStack {
                        Spacer()
                        
                        if isActive {
                            GreetingView().padding(.horizontal).border(.blue)
                            //                            CowriterLogo().padding(.top, 100)
                        } else {
                            ChatView(vm: vm)
                        }
                        
                        if !vm.errorMessage.isEmpty {
                            ErrorMessageView(message: vm.errorMessage)
                        }
                        Spacer()
                        
                        Prompter(vm: vm, isActive: isActive, isFocused: _isFocusOnPrompt)
                        
                        //                        if isActive {
                        //                            PromptHint(vm: vm)
                        //                        }
                        
                    }
                    .border(.red)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if vm.showSideBar {
                            vm.closeSideBar()
                        }
                        if isFocusOnPrompt {
                            isFocusOnPrompt = false
                        }
                    }
                    .onChange(of: isActive, perform: { newValue in
                        if isFocusOnPrompt {
                            isFocusOnPrompt = false
                        }
                    })
                    .frame(width: vm.showSideBar ? UIScreen.screenWidth : nil)
                    .offset(x: vm.showSideBar ? sideBarWidth / 2 : 0)
                }
                
            }
            .background(.linearGradient(
                colors: [.gray.opacity(0.15), .gray.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            ))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(vm.showSideBar ? "" : vm.currentChat?.wrappedTitle ?? "")
            .toolbar {
                CowriterToolbarView(vm: vm, width: sideBarWidth)
            }
            .animation(.linear, value: isActive)
        }
    }
}

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        CowriterView()
    }
}

struct GreetingView: View {
    @State private var text1: String? = nil
    @State private var text2: String? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                if let unwrappedText: String = text1 {
                    Text(unwrappedText).bold()
                        .transition(.moveAndFade)
                        .font(Font.system(.title3, design: .serif))
                        .foregroundColor(.grayFont)
                }
                
                if let unwrappedText: String = text2 {
                    Text(unwrappedText).bold()
                        .transition(.moveAndFade)
                        .font(Font.system(.title2, design: .serif))
                        .foregroundColor(.darkGrayFont)
                }
            }
            Spacer()
        }
        .padding()
        .animation(.interpolatingSpring(stiffness: 50, damping: 15), value: [text1, text2])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                text1 = "Hello!"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                text2 = "How can I assist you with your writing today?"
            }
        }
    }
}

struct CowriterToolbarView: ToolbarContent {
    @StateObject var vm: CowriterVM
    var width: CGFloat
    
    @State private var toolbarShow: Bool = false
    
    var body: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingView()
                } label: {
                    if toolbarShow {
                        Label("Setting", systemImage: "gearshape")
                            .offset(x: vm.showSideBar ? width / 2 : 0)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .animation(
                    .interpolatingSpring(stiffness: 30, damping: 15),
                    value: toolbarShow
                )
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack {
                    if toolbarShow {
                        HamburgerToClose(isOpened: $vm.showSideBar)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
                .animation(
                    .interpolatingSpring(stiffness: 30, damping: 15),
                    value: toolbarShow
                )
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        print(DispatchTime.now())
                        toolbarShow.toggle()
                    }
                }
            }
        }
    }
}

