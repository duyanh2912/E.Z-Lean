//
//  BodyPartAnatomyViewController.swift
//  E.Z Lean
//
//  Created by Duy Anh on 3/12/17.
//  Copyright © 2017 E.Z Lean. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm
import RxCocoa
import RxSwiftExt

class BodyPartAnatomyViewController: UIViewController {
    var bodyPart: Variable<BodyPart?> = Variable(nil)
    var anatomyArr: Variable<[Anatomy]> = Variable([])
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.bounces = true
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        BodyPartAnatomyCell.registerFor(tableView: tableView)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cấu tạo", style: .plain, target: nil, action: nil)
        
        bodyPart.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .unwrap()
            .observeOn(MainScheduler.instance)
            .map {
                DatabaseManager.anatomy.getAnatomyOf(bodyPart: $0)
            }
            .flatMapLatest {
                Observable.array(from: $0)
            }
            .bindTo(anatomyArr)
            .addDisposableTo(disposeBag)
        
        anatomyArr.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.instance)
            .bindTo(tableView.rx
                .items(cellIdentifier: BodyPartAnatomyCell.identifier, cellType: BodyPartAnatomyCell.self)
            ) { row, ele, cell in
                cell.config(anatomy: ele)
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(Anatomy.self)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] anatomy in
                let vc = BodyPartAnatomyWebViewController(nibName: nil, bundle: nil)
                vc.anatomy = anatomy
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.setDarkStyle()
    }
    
    deinit {
        print("deinit-BodyPartAnatomyView")
    }
}

extension BodyPartAnatomyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if anatomyArr.value.count == 1 {
            return tableView.height
        }
        return tableView.width / 16 * 12
    }
}
