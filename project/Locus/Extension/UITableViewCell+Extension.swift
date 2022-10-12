//
//  UITableViewCell+Extension.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
