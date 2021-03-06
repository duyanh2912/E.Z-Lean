//
//  BaseTableViewCell.swift
//  E.Z Lean
//
//  Created by Duy Anh on 3/2/17.
//  Copyright © 2017 E.Z Lean. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTableViewCell: UITableViewCell, CellIdentifiable {
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    var contentWidth: CGFloat! {
        didSet {
            self.contentView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        }
    }
    
    class var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    class var identifier: String { return nibName }
}

extension CellIdentifiable where Self: BaseTableViewCell {
    
    static func registerFor(tableView: UITableView) {
        let nib = UINib(nibName: Self.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Self.identifier)
    }
    
    static var fromNib: Self {
        let cell = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)![0]
        return cell as! Self
    }
}

