//
//  ViewControllerUtils.swift
//  E.Z Lean
//
//  Created by LuanNX on 3/6/17.
//  Copyright © 2017 E.Z Lean. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import IBAnimatable

extension UIViewController {
    func addDoneButton(textFields : [UITextField]){
        let toolBar = BorderedToolBar()
        toolBar.isOpaque = true
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        doneButton.tintColor = .black
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        for tf in textFields {
            tf.tintColor = .black
            tf.inputAccessoryView = toolBar
        }
        
        
    }
    func addDoneButtonForAnimatableTF(textFields : [AnimatableTextField]){
        addDoneButton(textFields: textFields)
    }
    
    func doneClicked() {
        self.view.endEditing(true)
    }
    func configNavigationCenter(disposeBag: DisposeBag,scrollView: UIScrollView) {
        NotificationCenter.default
            .rx
            .notification(Notification.Name.UIKeyboardWillChangeFrame)
            .concat(NotificationCenter
                .default
                .rx
                .notification(Notification.Name.UIKeyboardWillHide)
            )
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInteractive))
            .subscribe(onNext: { [unowned self] in
                self.adjustForKeyboard(notification: $0,scrollView: scrollView)
            })
            .addDisposableTo(disposeBag)
    }
    
    func adjustForKeyboard(notification: Notification,scrollView : UIScrollView) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = self.view.convert(keyboardScreenEndFrame, from: self.view.window)
        let intersection = keyboardViewEndFrame.intersection(scrollView.frame)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset.bottom = 0
        } else {
            scrollView.contentInset.bottom = intersection.height
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
}

class BorderedToolBar: UIToolbar, BorderDesignable {
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            configureBorder()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = CGFloat.nan {
        didSet {
            configureBorder()
        }
    }
    
    open var borderSides: BorderSides  = .AllSides {
        didSet {
            configureBorder()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureBorder()
    }
}

