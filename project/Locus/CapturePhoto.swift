//
//  CapturePhoto.swift
//  Locus
//
//  Created by Priyanka Navadiya on 11/10/22.
//

import Foundation
import UIKit
import AVKit

class CapturePhoto: NSObject {
    
    private var completionHandler: ((Data?) -> Void)?
    weak var viewController: UIViewController?
    
    init(vc: UIViewController?) {
        viewController = vc
    }
    
    func isCameraPermissionAllowed() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized && UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func openCamera(completion: @escaping(Data?) -> Void) {
        self.completionHandler = completion
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        viewController?.present(vc, animated: true)
    }

}

extension CapturePhoto: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage, let imgData = image.pngData() else {
            print("No image found")
            return
        }
        completionHandler?(imgData)
    }
}
