//
//  String+.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import UIKit

extension String {

    var convertToDateTime: String {
        let stringFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        formatter.locale = Locale(identifier: "ko")
        guard let tempDate = formatter.date(from: self) else {
            return ""
        }
        formatter.dateFormat = "yyyy. MM. dd"
        
        return formatter.string(from: tempDate)
    }
    
    var convertCSVStringToArray:[Double] {
            let components = self
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: ",")
            
            let array = components.compactMap { component -> Double? in
                return Double(component.trimmingCharacters(in: .whitespaces))
            }
            
            return array
    }
}
