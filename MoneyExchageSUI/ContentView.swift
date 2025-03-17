//
//  ContentView.swift
//  MoneyExchageSUI
//
//  Created by Danil Chekantsev on 14.03.2025.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @State private var results = [String: Double]()
    @State private var selectCurrencyOption = "USD"
    @State private var resultCurrencyOption = "EUR"
    @State private var textField = ""
    @State private var resultField = ""
    @State private var lightTheme = true
    
    private let options = ["RUB", "USD", "EUR"]
    
    var body: some View {
        ZStack {
            backgroundTheme(isLight: lightTheme)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                headerView
                inputView
                resultView
                resultButton
            }
        }
        .task {
            if let rates = await loadCurrency() {
                results = rates
            }
        }
    }
    
    private var headerView: some View {
        ZStack {
            Text("EXCHANGE")
                .bold()
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation {
                            lightTheme.toggle()
                        }
                    } label: {
                        Image(systemName: "star")
                            .foregroundColor(.black)
                            .font(.title3)
                    }
                    .padding(.trailing, 20)
                }
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    private var inputView: some View {
        HStack {
            TextField("", text: $textField, prompt: Text("ENTER VALUE").foregroundColor(.black.opacity(0.4)))
                .padding()
                .background(lightTheme ? Color.black.opacity(0.2) : Color.cyan.opacity(0.3))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            
            Picker("", selection: $selectCurrencyOption) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .padding(.trailing, 10)
        }
        .padding(.horizontal)
    }
    
    private var resultView: some View {
        HStack {
            TextField("", text: $resultField, prompt: Text("RESULT").foregroundColor(.black.opacity(0.4)))
                .padding()
                .background(lightTheme ? Color.black.opacity(0.2) : Color.cyan.opacity(0.3))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            
            Picker("", selection: $resultCurrencyOption) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .padding(.trailing, 10)
        }
        .padding(.horizontal)
    }
    
    private var resultButton: some View {
        HStack {
            Button("Convert") {
                guard
                    let amount = Double(textField),
                        let convertedAmount = convertCurrency(
                            amount: amount,
                            from: selectCurrencyOption,
                            to: resultCurrencyOption,
                            rates: results
                        )
                else {
                    resultField = "error"
                    return
                }
                resultField = String(format: "%.2f", convertedAmount)
                
            }
        }
    }

    
    private func backgroundTheme(isLight: Bool) -> LinearGradient {
        LinearGradient(
            colors: isLight ? [Color.pink.opacity(0.5), Color.blue.opacity(0.8)] : [Color.indigo.opacity(0.9), Color.cyan.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func loadCurrency() async -> [String: Double]? {
        guard let url = URL(string: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json") else {
            print("Invalid URL")
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(CurrencyResponse.self, from: data)
            return decodedResponse.usd
        } catch {
            print("Decoding failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func convertCurrency(amount: Double, from: String, to: String, rates: [String: Double]) -> Double? {
        guard let fromRate = rates[from.lowercased()], let toRate = rates[to.lowercased()] else {
            return nil
        }
        
        let usdAmount = amount / fromRate
        let convertedAmount = usdAmount * toRate
        
        return convertedAmount
    }
}


#Preview {
    ContentView()
}
