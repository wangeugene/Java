//
//  ContentView.swift
//  introduction
//
//  Created by euwang on 11/28/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Knock,knock!")
                .padding()
                .background(Color.yellow,in: RoundedRectangle(cornerRadius:8))
            Text("Who's there?")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
