//
//  ListViewModel.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import Foundation

protocol ListViewModelDelegate: AnyObject {
    func reloadCell(index: Int)
    func reloadList()
}
class ListViewModel {
    private(set) var listItems: [ListItem] = []
    weak var delegate: ListViewModelDelegate?
    
    func fetchInitialData() {
        listItems = loadJSONforPath(name: "List", type: [ListItem].self) ?? []
    }
    
    private func loadJSONforPath<T: Codable>(name: String, type: T.Type) -> T? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
            return nil
        }
        return Utils().parse(jsonData: jsonData, type: T.self)
    }
    
    func itemSeletced(rowIndex: Int, itemIndex: Int) {
        if listItems[rowIndex].dataMap.options.count > itemIndex {
            for index in 0..<listItems[rowIndex].dataMap.options.count {
                listItems[rowIndex].dataMap.options[index].isSelected = false
            }
            listItems[rowIndex].dataMap.options[itemIndex].isSelected = true
            delegate?.reloadCell(index: rowIndex)
        }
    }
    
    func commentCellSelected(rowIndex: Int, isRequire: Bool) {
        listItems[rowIndex].dataMap.isCommentRequire = isRequire
        delegate?.reloadList()
    }
    
    func updateCommect(rowIndex: Int, comemntString: String) {
        listItems[rowIndex].dataMap.comment = comemntString
    }
    
    func removePhoto(rowIndex: Int) {
        listItems[rowIndex].dataMap.imageData = nil
    }
    
    func addPhoto(rowIndex: Int, data: Data) {
        listItems[rowIndex].dataMap.imageData = data
        delegate?.reloadCell(index: rowIndex)
    }
    
    func getAllItemDetails() -> String {
        var outputString = ""
        for item in listItems {
            outputString += "\n\(item.id): "
            if item.type == .singleChoice {
                let selectedOption = item.dataMap.options.first { $0.isSelected }
                outputString += "\(selectedOption?.title ?? "no input")"
            } else if item.type == .comment {
                let output = item.dataMap.comment != "" ? item.dataMap.comment : "no input"
                outputString += output
            } else if item.type == .photo {
                let output = item.dataMap.imageData != nil ? "Image uploaded" : "no input"
                outputString += output
            }
        }
        return outputString
    }
}
