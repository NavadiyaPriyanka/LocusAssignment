//
//  Utils.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import Foundation

class Utils {
    
    func parse<T:Codable>(jsonData: Data, type: T.Type) -> T? {
        do  {
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch(let error) {
            print("decoded error \(error)")
            return nil
        }
    }
}
