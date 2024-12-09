import SwiftUI

struct FavoriteCitiesView: View {
    @Binding var favoriteCities: [String] // Pass favorite cities list
    var onSelectCity: (String) -> Void    // Closure to handle city selection

    var body: some View {
        NavigationView {
            List {
                ForEach(favoriteCities, id: \.self) { city in
                    Button(action: {
                        onSelectCity(city)
                    }) {
                        Text(city)
                            .underline()
                            .foregroundColor(.blue)
                    }
                }
                .onDelete(perform: removeCity)
            }
            .navigationTitle("Favorite Cities")
        }
    }

    // Remove city from favorites
    func removeCity(at offsets: IndexSet) {
        favoriteCities.remove(atOffsets: offsets)
    }
}

