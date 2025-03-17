//
//  Currency.swift
//  MoneyExchageSUI
//
//  Created by Danil Chekantsev on 17.03.2025.
//

import SwiftUI

struct CurrencyResponse: Decodable {
    var date: String
    var usd: [String:Double]
}
