/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class SetGoalsVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var imgVwTerms: [UIImageView]!
    @IBOutlet var btnTerms: [UIButton]!
    @IBOutlet weak var collVwGoals: UICollectionView!
    @IBOutlet var lblTitle: [UILabel]!
    @IBOutlet weak var cnstHeightCollVw: NSLayoutConstraint!
    @IBOutlet var vwSelection: [UIView]!
    @IBOutlet weak var btnBack: UIButton!
    
    
    //MARK:- Variables
    var objSetGoalsVM = SetGoalsVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.isHidden = self.title == TitleMessage.fromSplash
        Proxy.shared.registerCollViewNib(collVwGoals, identifierCell: GoalsCVC.className)
        actionSelection(btnTerms.first!)
        objSetGoalsVM.getGoals {
            self.collVwGoals.reloadData()
            self.setCollvwHeight(self.objSetGoalsVM.arrGoalsModel)
        }
        
        
    }
    func setCollvwHeight(_ arr: [GoalsModel]){
        if arr.isEmpty {
            cnstHeightCollVw.constant = .zero
        } else {
            if arr.count.isMultiple(of: 3) {
                cnstHeightCollVw.constant = CGFloat((arr.count/3) * 55)
            } else {
                cnstHeightCollVw.constant = CGFloat((Int(arr.count/3) + 1) * 55)
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func actionSelection(_ sender: UIButton) {
        imgVwTerms.forEach { img in
            img.image = sender.tag == img.tag ? #imageLiteral(resourceName: "ic_selected") : #imageLiteral(resourceName: "ic_unselected")
        }
        self.objSetGoalsVM.golasType = sender.tag
    }
    @IBAction func ActionSubmit(_ sender: UIButton) {
        if self.objSetGoalsVM.arrSelection.count == .zero {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.selectGoals)
        } else {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable(){
                self.objSetGoalsVM.addGoals {
                    self.moveToNext(SetPassionVC.className)
                }
            }
        }
    }
    
    @IBAction func actionback(_ sender: UIButton) {
        popToBack()
    }
    
}
