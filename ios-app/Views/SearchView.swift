//
//  SearchView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/20/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Enter city name...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
               .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.top, 10)
    }
}
