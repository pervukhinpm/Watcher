//
//  LogTimeDescriptionCell2.swift
//  Watcher
//
//  Created by Петр Первухин on 20/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

protocol LogTimeDescriptionCellDelegate: class {
    func textViewDidChange(newText: String?)
    func updateTableViewWith(_ height: CGFloat)
    func startAddingDescription()
}

final class LogTimeDescriptionCell: UITableViewCell {

    // MARK: - Constants

    static let identifier = "LogTimeDescriptionCellID"
    
    
    // MARK: - IBOutlet

    weak var delegate: LogTimeDescriptionCellDelegate?

    
    // MARK: - IBOutlet

    @IBOutlet weak var descriptionTextView: UITextView!

    
    // MARK: - Private Properties

    //Начальная высота ячейки
    private var currentHeight: CGFloat = 200
    //Высота constraint
    private var constraintInset: CGFloat = 60
    
    
    // MARK: - awakeFromNib

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.clipsToBounds = true
        descriptionTextView.delegate = self
        descriptionTextView.text = ls("add_description")
        descriptionTextView.textColor = .orangeyRed
        descriptionTextView.backgroundColor = ColorThemeManager.shared.current.textViewBackgroundColor
        descriptionTextView.font = UIFont.b1Font
    }
}


// MARK: - UITextViewDelegate

extension LogTimeDescriptionCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .orangeyRed {
            textView.text = nil
            textView.textColor = ColorThemeManager.shared.current.mainTextColor
            textView.font = UIFont.t2Font
        }
        delegate?.startAddingDescription()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        //когда начинается печать вызывается метод делегата в котором идет проверка  
        //содержит ли textView.text текст.В зависимости от этого addButton включена или выключена
        delegate?.textViewDidChange(newText: textView.text)
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        
        //при печати идет изменение высоты textView и соответственно изменение высоты ячейки.
        //Здесь идет проверка если высота textView изменилась то вызывается метод делегата
        //где идет обновление tableView
        if newFrame.height + constraintInset != currentHeight {
            currentHeight = newSize.height + constraintInset
            delegate?.updateTableViewWith(currentHeight)
        }
        
    }
    
    func textView(_ textView: UITextView, 
                  shouldChangeTextIn range: NSRange, 
                  replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ls("add_description")
            textView.textColor = .orangeyRed
            textView.font = UIFont.b1Font
        }
    }
}
