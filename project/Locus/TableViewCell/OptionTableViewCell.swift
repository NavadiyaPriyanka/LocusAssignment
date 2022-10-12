//
//  OptionTableViewCell.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(option: Option?) {
        guard let option = option else { return }
        titleLabel.text = option.title
        let image = option.isSelected ? "radio_on" : "radio_off"
        statusImageView.image = UIImage(named: image)
    }
}
