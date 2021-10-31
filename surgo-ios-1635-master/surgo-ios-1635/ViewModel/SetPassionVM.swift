/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FirebaseAuth
import FirebaseFirestore
class SetPassionVM: NSObject {
    //MARK:- Variables
    var arrPassionModel = [GoalsModel]()
    var selectedIndex = -1
    
    func getPassions(_ completion:@escaping() -> Void){
        DataBaseHelper.shared.getCollectionData(firebaseCollectionKeys.passions) { arr in
            for i in arr.documents {
                let objGoalsModel = GoalsModel(val: i.documentID)
                self.arrPassionModel.append(objGoalsModel)
            }
            completion()
        }
    }
    
    func addPassion(_ selectedPassion:String, completion:@escaping() -> Void){
        let uid = Auth.auth().currentUser!.uid
        fireStoreRef.collection(firebaseCollectionKeys.users).document(uid).updateData([
            "passion" :selectedPassion,
            "profileSetup":4
            
        ]) { (err) in
            
            if err != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(err!.localizedDescription)
                return
            }
            DataBaseHelper.shared.getDocument(firebaseCollectionKeys.users, uid: uid) { dict in
                objUserDetails.handelData(dict)
                Proxy.shared.hideActivityIndicator()
                completion()
            }
        }
    }

}
extension SetPassionVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        objSetPassionVM.arrPassionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalsCVC.className, for: indexPath) as! GoalsCVC
        cell.lblTitle.text = objSetPassionVM.arrPassionModel[indexPath.row].title
        cell.lblTitle.textColor = objSetPassionVM.selectedIndex == indexPath.row ? .white : .black
        cell.btnCross.isHidden = objSetPassionVM.selectedIndex != indexPath.row
        cell.vwBackground.startColor = objSetPassionVM.selectedIndex == indexPath.row ?#colorLiteral(red: 0.9294117647, green: 0.4666666667, blue: 0.4980392157, alpha: 1)  : #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.vwBackground.endColor = objSetPassionVM.selectedIndex == indexPath.row ? #colorLiteral(red: 0.9490196078, green: 0.6470588235, blue: 0.5333333333, alpha: 1) : #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(actionDelete), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/3 - 10, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if objSetPassionVM.selectedIndex != -1 {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.selectPassionOnlyOne)
        } else if objSetPassionVM.selectedIndex != indexPath.row {
            objSetPassionVM.selectedIndex = indexPath.row
            let cell = collectionView.cellForItem(at: indexPath) as! GoalsCVC
            cell.vwBackground.startColor = #colorLiteral(red: 0.9294117647, green: 0.4666666667, blue: 0.4980392157, alpha: 1)
            cell.vwBackground.endColor = #colorLiteral(red: 0.9490196078, green: 0.6470588235, blue: 0.5333333333, alpha: 1)
            cell.lblTitle.textColor = .white
            cell.btnCross.isHidden = false
        }
    }
    
    @objc func actionDelete(_ sender:UIButton){
        objSetPassionVM.selectedIndex = -1
        let cell = self.collVwGoals.cellForItem(at: IndexPath(item: sender.tag, section: .zero)) as! GoalsCVC
        cell.vwBackground.startColor = #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.vwBackground.endColor = #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.lblTitle.textColor = .black
        cell.btnCross.isHidden = true
    }
    
}
