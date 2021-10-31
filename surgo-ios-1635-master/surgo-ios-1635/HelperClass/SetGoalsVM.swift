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
class SetGoalsVM: NSObject {
    
    //MARK:- Variables
    var arrGoalsModel = [GoalsModel]()
    var arrSelection = NSMutableArray()
    var golasType = Int()
    
    func getGoals(_ completion:@escaping() -> Void){
        DataBaseHelper.shared.getCollectionData(firebaseCollectionKeys.goals) { arr in
            for i in arr.documents {
                let objGoalsModel = GoalsModel(val: i.documentID)
                self.arrGoalsModel.append(objGoalsModel)
            }
            completion()
        }
    }
    
    func addGoals(_ completion:@escaping() -> Void){
        let uid = Auth.auth().currentUser!.uid
      fireStoreRef.collection(firebaseCollectionKeys.users).document(uid).updateData([
            "goals" :arrSelection,
            "profileSetup":3,
            "goalsType":golasType
            
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
extension SetGoalsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        objSetGoalsVM.arrGoalsModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalsCVC.className, for: indexPath) as! GoalsCVC
        let dict = objSetGoalsVM.arrGoalsModel[indexPath.row]
        cell.lblTitle.text = objSetGoalsVM.arrGoalsModel[indexPath.row].title
        cell.lblTitle.textColor = objSetGoalsVM.arrSelection.contains(dict.title ?? "") ? .white : .black
        cell.btnCross.isHidden = !objSetGoalsVM.arrSelection.contains(dict.title ?? "")
        cell.vwBackground.startColor = objSetGoalsVM.arrSelection.contains(dict.title ?? "") ?#colorLiteral(red: 0.9294117647, green: 0.4666666667, blue: 0.4980392157, alpha: 1)  : #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.vwBackground.endColor = objSetGoalsVM.arrSelection.contains(dict.title ?? "") ? #colorLiteral(red: 0.9490196078, green: 0.6470588235, blue: 0.5333333333, alpha: 1) : #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(actionDelete), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/3 - 10, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = objSetGoalsVM.arrGoalsModel[indexPath.row]
        if !objSetGoalsVM.arrSelection.contains(dict.title ?? "") {
            objSetGoalsVM.arrSelection.add(dict.title ?? "")
            let cellRef = collectionView.cellForItem(at: indexPath) as! GoalsCVC
            cellRef.vwBackground.startColor = #colorLiteral(red: 0.9294117647, green: 0.4666666667, blue: 0.4980392157, alpha: 1)
            cellRef.vwBackground.endColor =  #colorLiteral(red: 0.9490196078, green: 0.6470588235, blue: 0.5333333333, alpha: 1)
            cellRef.lblTitle.textColor =  .white
            cellRef.btnCross.isHidden = false
           // collectionView.reloadData()
        }
    }
    
    @objc func actionDelete(_ sender:UIButton){
        let dict = objSetGoalsVM.arrGoalsModel[sender.tag]
        objSetGoalsVM.arrSelection.remove(dict.title ?? "")
        let cellRef = collVwGoals.cellForItem(at: IndexPath(item: sender.tag, section: .zero)) as! GoalsCVC
        cellRef.vwBackground.startColor = #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cellRef.vwBackground.endColor =  #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cellRef.lblTitle.textColor =  .black
        cellRef.btnCross.isHidden = true
       // self.collVwGoals.reloadData()
    }
    
}
