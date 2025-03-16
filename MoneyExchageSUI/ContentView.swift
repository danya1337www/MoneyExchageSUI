//
//  ContentView.swift
//  MoneyExchageSUI
//
//  Created by Danil Chekantsev on 14.03.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedOption = "SELECT"
    @State private var resultOption = "SELECT"
    @State private var textField = ""
    @State private var resultField = ""
    @State private var lightTheme = true

    private let options = ["SELECT", "RUB", "USD", "EUR", "4", "5"]

    var body: some View {
        ZStack {
            backgroundTheme(isLight: lightTheme)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                
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

                    Picker("", selection: $selectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.trailing, 10)
                }
                .padding(.horizontal)

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

                    Picker("", selection: $resultOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.trailing, 10)
                }
                .padding(.horizontal)
            }
            
        }
    }

    private func backgroundTheme(isLight: Bool) -> LinearGradient {
        let colors = isLight
            ? [Color.pink.opacity(0.5), Color.blue.opacity(0.8)]
            : [Color.indigo.opacity(0.9), Color.cyan.opacity(0.6)]

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

#Preview {
    ContentView()
}
