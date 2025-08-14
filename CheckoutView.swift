//
//  CheckoutView.swift
//  cupcake
//
//  Created by Brian Greeson on 8/12/25.
//

import SwiftUI

struct CheckoutView: View {
    @Bindable var order: Order
    func submitOrder() async throws -> Data? {
        let orderURL: URL = URL(string: "https://reqres.in/api/cupcakes")!
        let body: Data = try JSONEncoder().encode(order)
        var request = URLRequest(url: orderURL)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.setValue("", forHTTPHeaderField: "x-api-key") 


        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: body)
            print(String(data: data, encoding: .utf8) ?? "No data")
            return data
        } catch {
            print("Checkout failed: \(error.localizedDescription)")
            return nil
        }

    }
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button {
                    Task {
                        print("Placing Order...")
                        if let data = try? await submitOrder() {
                            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
                            confirmationMessage =
                                "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                            print(confirmationMessage)
                            showingConfirmation = true
                        }
                    }
                } label: {
                    Text("Place Order")
                }
                .padding().alert("Thank you!", isPresented: $showingConfirmation) {
                    Button("OK") {}
                } message: {
                    Text(confirmationMessage)
                }
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    CheckoutView(order: Order())
}
