//
//  ContentView.swift
//  MAPINEDIII
//
//  Created by Nikolas Arthur Herawan on 22/05/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            SearchView()
                .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


