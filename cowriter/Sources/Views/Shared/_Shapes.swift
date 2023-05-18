//
//  Shapes.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        
        return path
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
