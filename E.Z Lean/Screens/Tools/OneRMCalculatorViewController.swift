//
//  1RMCalculatorViewController.swift
//  E.Z Lean
//
//  Created by LuanNX on 2/5/17.
//  Copyright © 2017 E.Z Lean. All rights reserved.
//

import UIKit
import RxSwift

class OneRMCalculatorViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var reps: UITextField!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var result: UILabel!
     @IBOutlet weak var repsLabel: UILabel!
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
   
    let percentRepMaxs = [1.0,0.95,0.93,0.9,0.87,0.85,0.83,0.8,0.77,0.75]
    var repMaxResults = [Double]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationCenter(disposeBag: disposeBag, scrollView: scrollView)
        setUp()
        componentsDidEdited()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    func componentsDidEdited(){
        reps.addTarget(self, action: #selector(calculate), for: .editingChanged)
        weight.addTarget(self, action: #selector(calculate), for: .editingChanged)
    }
    func setUp(){
        collectionView.layer.cornerRadius = 4
        result.isHidden = true
        addDoneButton(textFields:[weight,reps])
    }
    func calculate(){
        guard let weightTxt = weight.text,
            let repsTxt = reps.text else {
                return
        }
        guard let myWeight = Int(weightTxt),
            let myReps = Double(repsTxt) else {
                return
        }
        if myReps <= 0 || myReps > 10{
            if myReps <= 0 {
                repsLabel.text = "Số lần cần > 0"
            } else {
                repsLabel.text = "Số lần cần <= 10"
            }
            
            repsLabel.textColor = UIColor(hexString: "#FF2200")
            calRepMax(result: 0.0)
            
            result.isHidden = true
            
        } else {
            repsLabel.text = "Số lần nâng tạ"
            repsLabel.textColor = UIColor(hexString: "#000000")
            let myResult = Double(myWeight)/(1.0278 - 0.0278*myReps)
            result.isHidden = false
            result.text = "\(Int(myResult))"
            calRepMax(result: myResult)
            
        }
        collectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label1 = cell.contentView.viewWithTag(101) as! UILabel
        let label2 = cell.contentView.viewWithTag(102) as! UILabel
        if index%2 == 1 {
            print(index)
            cell.backgroundColor = UIColor(hexString: "#F2F3F4")
        } else {
            cell.backgroundColor = UIColor(hexString: "#FFFFFF")
        }
        label1.text = "\(index+1)RM"
        if  !repMaxResults.isEmpty {
            label2.text = "\(Int(self.repMaxResults[index]))"
        } else {
            label2.text = ""
        }
        
        
        return cell
    }
    func calRepMax(result: Double){
        if result == 0.0 {
            repMaxResults.removeAll()
        } else {
            repMaxResults.removeAll()
            for i in 0...9 {
                repMaxResults.append(result*percentRepMaxs[i])
            }
        }
    }
    @IBAction func popToRootVc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   



}
