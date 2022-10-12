//
//  ListItem.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import Foundation

struct ListItem: Codable {
    let type: ListCategoryType
    let id: String
    let title: String
    var dataMap: DataMap
}

struct DataMap: Codable {
    var options: [Option] = []
    var imageData: Data?
    var comment: String = ""
    var isCommentRequire = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dataMap = try? container.decode([String: [String]].self), let object = dataMap["options"] {
                options = object.map { Option(title: $0) }
                return
        }
        options = []
    }
        
}

struct Option: Codable {
    let title: String
    var isSelected: Bool = false
}

enum ListCategoryType: String, Codable {
    case photo = "PHOTO"
    case singleChoice = "SINGLE_CHOICE"
    case comment = "COMMENT"
}
