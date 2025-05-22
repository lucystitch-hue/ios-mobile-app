//
//  DeleteMultipleView.swift
//  IMT-iOS
//
//  Created on 02/04/2024.
//
    

import UIKit

protocol DeleteMultipleViewDelegate {
    func numberOfItems(view: DeleteMultipleView) -> Int
    func numberOfItemsSelected(view: DeleteMultipleView) -> Int
    func selectAll(view: DeleteMultipleView)
    func removeAll(view: DeleteMultipleView)
    func cancel(view: DeleteMultipleView)
}

class DeleteMultipleView: UIView {
    
    @IBOutlet private weak var cancelButton: UIView!
    @IBOutlet private weak var lbSelectedAll: UILabel!
    @IBOutlet private weak var spacing: UIView!
    @IBOutlet private weak var lbCancel: UILabel!
    @IBOutlet private weak var imgCancel: UIImageView!
    
    var expaned: IMTBox<Bool> = IMTBox(false)
    
    var delegate: DeleteMultipleViewDelegate?
    
    var cancelTitle: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        expaned.bind(self, clearPreviousBinds: false) { [weak self] value in
            self?.cancelButton.isHidden = !value
            self?.spacing.isHidden = value
            self?.lbSelectedAll.text = value ? "Select All" : "Deselect"
            self?.lbCancel.text = "Back to List"

            self?.imgCancel.isHidden = true
        }
    }
    
    @IBAction func actionSelectedAll() {
        if (expaned.value) {
            guard let delegate = delegate else { return }
            if (delegate.numberOfItems(view: self) != delegate.numberOfItemsSelected(view: self)) {
                delegate.selectAll(view: self)
            } else {
                delegate.removeAll(view: self)
            }
        } else {
            expaned.value = true
        }
    }
    
    @IBAction func actionCancel() {
        guard let delegate = delegate else {
            expaned.value = false
            return
        }
        if (delegate.numberOfItemsSelected(view: self) != 0) {
            delegate.cancel(view: self)
        } else {
            expaned.value = false
        }
    }
    
    func bind() {
        if (expaned.value) {
            guard let delegate = delegate else { return }
            let isSelectedAll = delegate.numberOfItems(view: self) > 0 && delegate.numberOfItems(view: self) == delegate.numberOfItemsSelected(view: self)
            let isSelectedItemsEmpty = delegate.numberOfItemsSelected(view: self) == 0
            lbSelectedAll.text = isSelectedAll ? "Deselect All" : "Select All"
            lbCancel.text = isSelectedItemsEmpty ? "Back to List" : cancelTitle
            imgCancel.isHidden = isSelectedItemsEmpty
        }
    }
}
