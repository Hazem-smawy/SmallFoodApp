//
//  ContentView.swift
//  SmallFoodApp
//
//  Created by hazem smawy on 10/2/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       Home()
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
