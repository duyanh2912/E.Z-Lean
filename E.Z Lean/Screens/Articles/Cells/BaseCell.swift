//
//  BaseArticleCell.swift
//  E.Z Lean
//
//  Created by Duy Anh on 2/18/17.
//  Copyright © 2017 E.Z Lean. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
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

protocol CellIdentifiable: class {
    static func registerFor(collectionView: UICollectionView)
    
    associatedtype cellType
    static var fromNib: cellType { get }
}

extension CellIdentifiable where Self: BaseCell {
    
    static func registerFor(collectionView: UICollectionView) {
        print(nibName)
        let nib = UINib(nibName: Self.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Self.identifier)
    }
    
    static var fromNib: Self {
        print(nibName)
        let cell = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)![0]
        return cell as! Self
    }
}
