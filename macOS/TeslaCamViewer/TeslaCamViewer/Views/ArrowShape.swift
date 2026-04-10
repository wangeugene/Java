//
//  ArrowShape.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/10/26.
//


import SwiftUI

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Arrowhead
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.midY - rect.height * 0.1))
        
        // Shaft
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY - rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + rect.height * 0.1))
        
        // Other side of shaft
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.midY + rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.maxY))
        
        path.closeSubpath()
        
        return path
    }
}

struct ContentView1: View {
    var body: some View {
        ArrowShape()
            .fill(Color.blue)
            .frame(width: 200, height: 100)
            .shadow(radius: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
