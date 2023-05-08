//
//  Chat.swift
//  cowriter
//
//  Created by Aditya Cahyo on 26/04/23.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm: CowriterVM
    @Namespace private var bottomID
    @State private var isScrolled: Bool = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(vm.currentChat?.resultsArray ?? []) { result in
                    let isLastResult = result.wrappedId == vm.currentChat?.resultsArray.last?.wrappedId
                    
                    BubblePromptView(prompt: result.wrappedPrompt)
                    BubbleAnswerView(
                        answer: (isLastResult && vm.errorMessage.isEmpty && vm.isLoading) ?
                        vm.textToDisplay : result.wrappedAnswer
                    )
                    
                    if isLastResult {
                        Spacer().id(bottomID)
                    }
                }.animation(.linear, value: vm.currentChat?.resultsArray.count)
            }
            .gesture(DragGesture().onChanged{ value in
                isScrolled = true
            })
            .onChange(of: vm.textToDisplay) { newValue in
                if !isScrolled {
                    withAnimation {
                        scrollView.scrollTo(bottomID)
                    }
                }
            }
            .onChange(of: vm.isLoading, perform: { newValue in
                if isScrolled == true {
                    isScrolled = !newValue
                }
            })
            .onReceive(vm.$textToDisplay.throttle(for: 0.2, scheduler: DispatchQueue.main, latest: true)) { output in
                vm.textToDisplay = output
            }
        }
    }
}

struct BubblePromptView: View {
    var prompt: String
    var shape = CustomRoundedRectangle(topLeft: 12, topRight: 3, bottomLeft: 12, bottomRight: 12)
    
    var body: some View {
        HStack {
            Spacer(minLength: 50)
            Text(prompt)
                .textSelection(.enabled)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.white)
                .background(
                    shape.fill(LinearGradient(
                            gradient: Gradient(colors: [.black.opacity(0.8), .black.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
                .contentShape(.contextMenuPreview, shape)
                .contextMenu {
                    Button {
                        // Add this item to a list of favorites.
                    } label: {
                        Label("Add to Favorites", systemImage: "heart")
                    }
                    Button {
                        // Open Maps and center it on this item.
                    } label: {
                        Label("Show in Maps", systemImage: "mappin")
                    }
                }
            
        }
        .padding(.horizontal)
        .padding(.trailing)
        .transition(.move(edge: .bottom))
    }
}

struct BubbleAnswerView: View {
    var answer: String
    var shape = CustomRoundedRectangle(topLeft: 3, topRight: 12, bottomLeft: 12, bottomRight: 12)
    
    var body: some View {
        
        HStack {
            Text(answer)
                .textSelection(.enabled)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(
                    shape.fill(Color.answerBubble)
                )
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.darkGrayFont)
                .contentShape(.contextMenuPreview, shape)
                .contextMenu {
                    Button {
                        // Add this item to a list of favorites.
                    } label: {
                        Label("Add to Favorites", systemImage: "heart")
                    }
                    Button {
                        // Open Maps and center it on this item.
                    } label: {
                        Label("Show in Maps", systemImage: "mappin")
                    }
                }
            Spacer(minLength: 50)
        }
        .padding(.horizontal)
        .padding(.trailing)
        .animation(.linear, value: answer)
        .transition(.move(edge: .leading))
    }
}

struct BubbleChatViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BubblePromptView(prompt: "Hello")
            BubbleAnswerView(answer: "Hello")
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(vm: CowriterVM())
    }
}

struct CustomRoundedRectangle: Shape {
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let tl = CGSize(width: topLeft, height: topLeft)
        let tr = CGSize(width: topRight, height: topRight)
        let bl = CGSize(width: bottomLeft, height: bottomLeft)
        let br = CGSize(width: bottomRight, height: bottomRight)
        
        path.move(to: CGPoint(x: rect.minX + tl.width, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - tr.width, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - tr.width, y: rect.minY + tr.height),
                    radius: tr.width,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br.height))
        path.addArc(center: CGPoint(x: rect.maxX - br.width, y: rect.maxY - br.height),
                    radius: br.width,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + bl.width, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bl.width, y: rect.maxY - bl.height),
                    radius: bl.width,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl.height))
        path.addArc(center: CGPoint(x: rect.minX + tl.width, y: rect.minY + tl.height),
                    radius: tl.width,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        
        return path
    }
}
