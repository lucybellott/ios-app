//
//  SearchView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/20/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Enter city name...", text: $text, onCommit: onSearch)
                .padding(.vertical, 10)
                .padding(.horizontal, 25)
                .padding(.leading, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
               .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(7)
                    }
                )
                .padding(.horizontal, 10)
                .frame(height: 50)
        }
        .padding(.top, 10)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("Sample City"), onSearch: {
            print("Search initiated")
        })
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
