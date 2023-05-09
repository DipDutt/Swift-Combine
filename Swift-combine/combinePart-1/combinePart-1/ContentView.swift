//
//  ContentView.swift
//  combinePart-1
//
//  Created by Dip Dutt on 28/2/23.
//

import SwiftUI

struct ContentView: View {
    
    var timer = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .common).autoconnect()
    @State var currentdate:Date = Date()
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.white, Color.mint]), center: .center, startRadius: 5, endRadius: 500)
                .ignoresSafeArea()
            
            Text(currentdate.description)
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .foregroundColor(.blue)
                .lineLimit(1)
                .minimumScaleFactor(1.0)
            
                .onReceive(timer) { timevalue in
                     currentdate = timevalue
                }
            
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
