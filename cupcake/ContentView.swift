//
//  ContentView.swift
//  cupcake
//
//  Created by Brian Greeson on 8/11/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}
struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}


struct ContentView: View {
    @State private var currentOrder: Order = Order()
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Cupcake Type:", selection: $currentOrder.type, ) {
                        ForEach(Order.types.indices, id: \.self) { type in
                            Text(Order.types[type])
                                .autocapitalization(.words)
                        }
                    }
                    Stepper("Quantity: \(currentOrder.quantity)", value: $currentOrder.quantity, in: (3...10))
                }
                Section {
                    Toggle("Special Requests?", isOn: $currentOrder.specialRequestEnabled)
                    if currentOrder.specialRequestEnabled {
                        Toggle("Extra Frosting?", isOn: $currentOrder.extraFrosting)
                        Toggle("Add Sprinkles?", isOn: $currentOrder.addSprinkles)
                    }
                }
                Section{
                    NavigationLink("Shipping Address", destination: AddressView(order: currentOrder))
                }
            }.navigationTitle("Cupcake Corner")

            VStack {
                Text("Your Order:")
                Text("\(currentOrder.quantity) \(Order.types[currentOrder.type]) cupcakes")
            }
        }
    }
}

#Preview {
    ContentView()
}
