//import SwiftUI
//
//struct FavoriteCitiesView: View {
//    @Binding var favoriteCities: [String] // Pass favorite cities list
//    var onSelectCity: (String) -> Void    // Closure to handle city selection
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(favoriteCities, id: \.self) { city in
//                    Button(action: {
//                        onSelectCity(city)
//                    }) {
//                        Text(city)
//                            .underline()
//                            .foregroundColor(.blue)
//                    }
//                }
//                .onDelete(perform: removeCity)
//            }
//            .navigationTitle("Favorite Cities")
//        }
//    }
//
//    // Remove city from favorites
//    func removeCity(at offsets: IndexSet) {
//        favoriteCities.remove(atOffsets: offsets)
//    }
//}


import SwiftUI

struct FavoriteCitiesView: View {
    @Binding var favoriteCities: [String]
    var onSelectCity: (String) -> Void

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
                .onDelete { indexSet in
                    favoriteCities.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Favorite Cities")
        }
    }
}

#Preview {
    // Provide a mock array of favorites and a mock onSelectCity closure for the preview
    StatefulPreviewWrapper(["New York", "Paris", "Tokyo"]) { binding in
        FavoriteCitiesView(favoriteCities: binding, onSelectCity: { selectedCity in
            print("Selected city: \(selectedCity)")
        })
    }
}

// Helper struct to create a stateful preview
struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    let content: (Binding<Value>) -> AnyView

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> AnyView) {
        _value = State(initialValue: initialValue)
        self.content = content
    }

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> some View) {
        _value = State(initialValue: initialValue)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}
