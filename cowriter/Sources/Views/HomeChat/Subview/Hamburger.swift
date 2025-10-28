//
//  HamburgerToClose.swift
//  cowriter
//
//  Created by Aditya Cahyo on 28/04/23.
//

import SwiftUI

struct Hamburger: View {
	@ObservedObject var vm: HomeVM

	private let width: CGFloat = 22
	private let height: CGFloat = 1.5
	private let degrees: Double = 45
	private let corner: CGFloat = 2

	var body: some View {
		Button {
			withAnimation(.interpolatingSpring(stiffness: 150, damping: 20)) {
				vm.showSideBar.toggle()
			}
		} label: {
			VStack(spacing: 6) {
				RoundedRectangle(cornerRadius: corner)  // top
					.frame(
						width: vm.showSideBar ? width + 3.25 : width,
						height: height
					)
					.rotationEffect(
						.degrees(vm.showSideBar ? degrees : 0),
						anchor: .center
					)
					.offset(y: vm.showSideBar ? 7.5 : 0)

				RoundedRectangle(cornerRadius: corner)  // middle
					.frame(width: width, height: height)
					.scaleEffect(
						vm.showSideBar ? 0.0001 : 1,
						anchor: vm.showSideBar ? .trailing : .leading
					)
					.opacity(vm.showSideBar ? 0 : 1)

				RoundedRectangle(cornerRadius: corner)  // bottom
					.frame(
						width: vm.showSideBar ? width + 3.25 : width,
						height: height
					)
					.rotationEffect(
						.degrees(vm.showSideBar ? -degrees : 0),
						anchor: .center
					)
					.offset(y: vm.showSideBar ? -7.5 : 0)
			}
			.foregroundColor(.accentColor)
			.padding(5)
		}
		.buttonStyle(.plain)
		.accessibilityLabel("Toggle sidebar")
	}
}

struct Hamburger_Previews: PreviewProvider {
	static var previews: some View {
		Hamburger(vm: HomeVM())
	}
}
