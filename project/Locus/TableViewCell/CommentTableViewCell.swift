//
//  CommentTableViewCell.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import UIKit

protocol CommentTableViewCellDelegate: AnyObject {
    func commentSwitchStateChanged(indexPath: IndexPath?, state: Bool)
    func startEditingComment(indexPath: IndexPath?)
    func commentTextUpdated(indexPath: IndexPath?, comment: String)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var heightOfCommentTetViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.layer.borderColor = UIColor.gray.cgColor
            textView.layer.borderWidth = 1.0
            textView.delegate = self
        }
    }
    
    weak var delegate: CommentTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.addDoneButtonOnKeyboard()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchClicked(_ sender: Any) {
        let status = commentSwitch.isOn
        delegate?.commentSwitchStateChanged(indexPath: indexPath, state: status)
    }
    
    func load(item: ListItem) {
        titleLabel.text = item.title
        let switchStatus = item.dataMap.isCommentRequire
        commentSwitch.setOn(switchStatus, animated: true)
        heightOfCommentTetViewConstraint.constant = switchStatus ? 100 : 0
        textView.text = item.dataMap.comment
    }
}

extension CommentTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.commentTextUpdated(indexPath: indexPath, comment: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.startEditingComment(indexPath: indexPath)
    }
}

extension UITextView {
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
