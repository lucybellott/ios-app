
import SwiftUI

struct NavigationTitleView: View {
    var body: some View {
        HStack {
            Text("Woof Weather")
                .font(.headline)
                .foregroundColor(.white)
            
            Image(systemName: "pawprint") 
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}
