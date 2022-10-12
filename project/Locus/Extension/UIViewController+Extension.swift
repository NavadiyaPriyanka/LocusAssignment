//
//  UIViewController+Extension.swift
//  Locus
//
//  Created by Priyanka Navadiya on 11/10/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String? = "", msg: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
