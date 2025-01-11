// -----------------------------------------------------------
// PurchaseMaster.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file demonstrates how in-app purchases (IAP) can be handled
// with StoreKit. Products are fetched, listed, and purchased.
// -----------------------------------------------------------

import StoreKit
import SwiftUI

/// IAPManager manages fetching products, making purchases, and handling transactions.
class IAPManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    
    @Published var products: [SKProduct] = []
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    /// This function sends a request to the App Store for the given product IDs.
    func fetchProducts(productIDs: [String]) {
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    /// This delegate method is called when product info returns from the App Store.
    /// The products array is updated here on the main thread.
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    /// A purchase is initiated for the specified product if it is valid and available.
    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    /// Transactions are monitored here, and each completed/failed/restored transaction is finished.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored, .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}

/// This SwiftUI view provides a simple interface for fetching and buying products.
struct IAPExampleView: View {
    @StateObject private var iapManager = IAPManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Purchase Master")
                .font(.title)
            
            // A button to fetch products from the App Store.
            Button("Fetch Products") {
                iapManager.fetchProducts(productIDs: ["com.yourapp.exampleitem"])
            }
            
            // A list displays the available products, each of which can be purchased by tapping.
            List(iapManager.products, id: \.productIdentifier) { product in
                HStack {
                    Text(product.localizedTitle)
                    Spacer()
                    
                    let priceString = "\(product.priceLocale.currencySymbol ?? "$")\(product.price)"
                    Text(priceString)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    iapManager.buy(product: product)
                }
            }
        }
        .padding()
    }
}
