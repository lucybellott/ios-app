//
//  NavigationTitleView.swift
//  WoofWeather
//
//  Created by Lucy Bellott on 9/10/24.
//

import SwiftUI

struct NavigationTitleView: View {
    var body: some View {
        HStack {
            Text("Woof Weather")
                .font(.headline)
                .foregroundColor(.white)
            
            Image(systemName: "pawprint") // Use your preferred SF Symbol
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}
