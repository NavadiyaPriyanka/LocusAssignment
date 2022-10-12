//
//  ListViewController.swift
//  Locus
//
//  Created by Priyanka Navadiya on 10/10/22.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            loadCell()
        }
    }
    
    let listVM: ListViewModel = ListViewModel()
    
    lazy var capturePhoto: CapturePhoto = {
        return CapturePhoto(vc: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listVM.delegate = self
        listVM.fetchInitialData()
        // Do any additional setup after loading the view.
    }
    
    private func loadCell() {
        listTableView.register(UINib(nibName: PhotoTableViewCell.nibIdentifier, bundle: nil), forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        listTableView.register(UINib(nibName: SingleChoiseTableViewCell.nibIdentifier, bundle: nil), forCellReuseIdentifier: SingleChoiseTableViewCell.reuseIdentifier)
        listTableView.register(UINib(nibName: CommentTableViewCell.nibIdentifier, bundle: nil), forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier)
    }
    
    private func capturePhotoFromCamera(selectedIndex: Int) {
        if capturePhoto.isCameraPermissionAllowed() {
            capturePhoto.openCamera { [weak self] imageData in
                guard let data = imageData else { return }
                self?.listVM.addPhoto(rowIndex: selectedIndex, data: data)
            }
        } else {
            showAlert(msg: "Camera permission is not given...")
        }
    }
   
    
    @IBAction func submitClicked(_ sender: Any) {
        print("Item Details:\n\(listVM.getAllItemDetails())")
    }
    
}

extension ListViewController: UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVM.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listVM.listItems[indexPath.row]
        if item.type == .singleChoice, let cell = tableView.dequeueReusableCell(withIdentifier: SingleChoiseTableViewCell.reuseIdentifier, for: indexPath) as? SingleChoiseTableViewCell {
            cell.indexPath = indexPath
            cell.load(item: item)
            cell.frame = tableView.bounds
            cell.delegate = self
            cell.layoutIfNeeded()
            cell.heightOfOptionListViewConstraint.constant = cell.optionTableView.contentSize.height
            cell.selectionStyle = .none
            return cell
        } else if item.type == .comment, let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.reuseIdentifier, for: indexPath) as? CommentTableViewCell {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.load(item: item)
            cell.frame = tableView.bounds
            cell.selectionStyle = .none
            return cell
        } else if item.type == .photo, let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseIdentifier, for: indexPath) as? PhotoTableViewCell {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.load(item: item)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
}

extension ListViewController: SingleChoiseTableViewCellDelegate {
    func optionSelected(indexPath: IndexPath?, itemIndex: Int) {
        guard let rowIndex = indexPath?.row else { return }
        listVM.itemSeletced(rowIndex: rowIndex, itemIndex: itemIndex)
    }
    
}

extension ListViewController: CommentTableViewCellDelegate {
    func startEditingComment(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        listTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func commentTextUpdated(indexPath: IndexPath?, comment: String) {
        guard let rowIndex = indexPath?.row else { return }
        listVM.updateCommect(rowIndex: rowIndex, comemntString: comment)
    }
    
    func commentSwitchStateChanged(indexPath: IndexPath?, state: Bool) {
        guard let rowIndex = indexPath?.row else { return }
        listVM.commentCellSelected(rowIndex: rowIndex, isRequire: state)
    }
}

extension ListViewController: PhotoTableViewCellDelegate {
    func onPhotoSelected(indexPath: IndexPath?) {
        guard let rowIndex = indexPath?.row else { return }
        capturePhotoFromCamera(selectedIndex: rowIndex)
    }
    
    func onClearSelected(indexPath: IndexPath?) {
        guard let rowIndex = indexPath?.row else { return }
        listVM.removePhoto(rowIndex: rowIndex)
    }
}

extension ListViewController: ListViewModelDelegate {
    func reloadCell(index: Int) {
        if let cell = listTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SingleChoiseTableViewCell {
            cell.load(item: listVM.listItems[index])
        } else if let cell = listTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PhotoTableViewCell {
            cell.load(item: listVM.listItems[index])
        }
    }
    
    func reloadList() {
        listTableView.reloadData()
    }
    
}
