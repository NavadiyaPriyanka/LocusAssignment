//
//  PhotoTableViewCell.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import UIKit

protocol PhotoTableViewCellDelegate: AnyObject {
    func onPhotoSelected(indexPath: IndexPath?)
    func onClearSelected(indexPath: IndexPath?)
}

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearPhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var indexPath: IndexPath?
    var listItem: ListItem?
    weak var delegate: PhotoTableViewCellDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onPhotoClicked(_ sender: Any) {
        if listItem?.dataMap.imageData == nil {
            delegate?.onPhotoSelected(indexPath: indexPath)
        }
    }
    
    @IBAction func clearPhotoClicked(_ sender: Any) {
        delegate?.onClearSelected(indexPath: indexPath)
        listItem?.dataMap.imageData = nil
        setPhoto()
        setClearButtonStatus()
    }
    
    func load(item: ListItem) {
        self.listItem = item
        titleLabel.text = item.title
        setClearButtonStatus()
        setPhoto()
    }
    
    private func setClearButtonStatus() {
        if let item = self.listItem {
            let isImageUploaded = item.dataMap.imageData != nil ? true : false
            clearPhotoButton.isHidden = !isImageUploaded
        }
    }
    
    private func setPhoto() {
        if let item = self.listItem {
            let isImageUploaded = item.dataMap.imageData != nil ? true : false
            if isImageUploaded, let imgData = item.dataMap.imageData {
                photoImageView.image = UIImage(data: imgData)
            } else {
                photoImageView.image = UIImage(named: "placeholder")
            }
        }
    }
}
