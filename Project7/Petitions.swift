//
//  Petitions.swift
//  Project7
//
//  Created by Azat Kaiumov on 24.05.2021.
//

import Foundation

struct Petitions: Codable {
    var results: [Petition]
}

extension Petitions {
    init?(json: Data) {
        let decoder = JSONDecoder()
        
        guard let parsedData = try? decoder.decode(Petitions.self, from: json) else {
            return nil
        }
        
        self = parsedData
    }
}
