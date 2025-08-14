//
//  AddressView.swift
//  cupcake
//
//  Created by Brian Greeson on 8/12/25.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.address)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }
                Section {
                    NavigationLink("Check out") {
                        CheckoutView(order: order)
                    }
                    .disabled(!order.hasValidAddress)
                }
            }
            .navigationTitle(Text("Address"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddressView(order: Order())
}
