//
//  SingleChoiseTableViewCell.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import UIKit

protocol SingleChoiseTableViewCellDelegate: AnyObject {
    func optionSelected(indexPath: IndexPath?, itemIndex: Int)
}

class SingleChoiseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var heightOfOptionListViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionTableView: UITableView!
    
    weak var delegate: SingleChoiseTableViewCellDelegate?
    var listItem: ListItem?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionTableView.dataSource = self
        optionTableView.delegate = self
        optionTableView.estimatedRowHeight = 40
        optionTableView.rowHeight = UITableView.automaticDimension
        loadCell()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func loadCell() {
        optionTableView.register(UINib(nibName: OptionTableViewCell.nibIdentifier, bundle: nil), forCellReuseIdentifier: OptionTableViewCell.reuseIdentifier)
    }

    func load(item: ListItem) {
        titleLabel.text = item.title
        self.listItem = item
        optionTableView.reloadData()
    }
    
}

extension SingleChoiseTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem?.dataMap.options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.reuseIdentifier, for: indexPath) as? OptionTableViewCell else {
            return UITableViewCell()
        }
        cell.load(option: listItem?.dataMap.options[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.optionSelected(indexPath: self.indexPath, itemIndex: indexPath.row)
    }
}
