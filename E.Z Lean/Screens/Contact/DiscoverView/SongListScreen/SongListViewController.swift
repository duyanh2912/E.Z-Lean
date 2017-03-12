//
//  SongListViewController.swift
//  Lab01
//
//  Created by Duy Anh on 2/19/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxSwiftExt

class SongListViewController: UIViewController, ImageTransitionAnimatable {
    var playlist: Variable<Playlist?> = Variable(nil)
    
    var dataSource: SongDataSource!
    var disposeBag = DisposeBag()
    
    typealias cellClass = SongListTableViewCell
    let cellType = cellClass.self
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var imageViewForTransition: UIImageView!
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTransition()
        bindCategory()
        configDataSource()
        configSelectingCell()
        
        Status.reachable
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                if $0 {
                    self.bottomConstraint.constant = 0
                } else {
                    self.bottomConstraint.constant = Status.snackBar.height
                }
            })
            .addDisposableTo(disposeBag)
        
        AudioController.instance
            .isPlaying
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                if $0 {
                    self.tableView.contentInset.bottom = 50
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func configSelectingCell() {
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                if let cell = self.tableView.cellForRow(at: indexPath) as? cellClass {
                    cell.isSelected = true
                }
            })
            .addDisposableTo(disposeBag)
        tableView.rx
            .itemDeselected
            .subscribe(onNext: { [unowned self] indexPath in
                if let cell = self.tableView.cellForRow(at: indexPath) as? cellClass {
                    cell.isSelected = false
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func configDataSource() {
        cellType.registerFor(tableView: tableView)
        dataSource = SongListDataSource(tableView: tableView)
        dataSource.cellType = cellType
        dataSource.playlist = playlist
        dataSource.config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNavigation()
    }
    
    func configNavigation() {
        categoryContainer.rx
            .tapGesture()
            .subscribe(onNext: { [unowned self] gesture in
                guard gesture.state == .ended else { return }
                _ = self.navigationController?.popViewController(animated: true)
            })
            .addDisposableTo(disposeBag)
    }
    
    func configTransition() {
        imageViewForTransition = categoryImageView
    }
    
    func bindCategory() {
        playlist.asObservable()
            .unwrap()
            .subscribe(onNext: { [unowned self] playlist in
                self.title = playlist.name
                self.categoryNameLabel.text = ""
                self.categoryImageView.sd_setImage(with: URL(string: playlist.imageLink))
            })
            .addDisposableTo(disposeBag)
    }
    
    deinit {
        print("Deinit-SongListViewController")
    }
}
