//
//  Encodable_Extension.swift
//  
//
//  Created by Luke Smith on 11/05/2020.
//  Copyright © 2020 Luke Smith. All rights reserved.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? { try? JSONEncoder().encode(self) }
    
    var printableJSON : String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8) ?? "** Cannot Decode **"
        } catch {
            
        }
        return "** Cannot Decode **"
    }
}
