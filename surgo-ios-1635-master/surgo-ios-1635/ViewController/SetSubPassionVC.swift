/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class SetSubPassionVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var collVwGoals: UICollectionView!
    @IBOutlet weak var cnstHeightCollVw: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    //MARK:- variables
    var objSetSubPassionVM = SetSubPassionVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.isHidden = self.title == TitleMessage.fromSplash
        Proxy.shared.registerCollViewNib(collVwGoals, identifierCell: GoalsCVC.className)
        objSetSubPassionVM.getSubPassions {
            self.collVwGoals.reloadData()
            self.setCollvwHeight(self.objSetSubPassionVM.arrSubPassionModel)
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
    @IBAction func ActionSubmit(_ sender: UIButton) {
        if  objSetSubPassionVM.arrSelection.count == .zero {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.selectSubPassion)
        } else {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable(){
                self.objSetSubPassionVM.addSubPasssion {
                    self.rootWithoutDrawer(MainTBC.className)
                }
            }
        }
    }
    @IBAction func actionback(_ sender: UIButton) {
        popToBack()
    }
}
