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
class SetSubPassionVM: NSObject {
    
    //MARK:- Variables
    var arrSubPassionModel = [GoalsModel]()
    var arrSelection = NSMutableArray()
    
    func getSubPassions(_ completion:@escaping() -> Void){
        DataBaseHelper.shared.getSubPassions(firebaseCollectionKeys.passions, collectionKey: firebaseCollectionKeys.subPassions, selectedpassion: objUserDetails.passion!, completion: {
            arr in
            for i in arr {
                let objGoalsModel = GoalsModel(val: "\(i)")
                self.arrSubPassionModel.append(objGoalsModel)
            }
            completion()
        })
    }
    
    func addSubPasssion(_ completion:@escaping() -> Void){
        let uid = Auth.auth().currentUser!.uid
        fireStoreRef.collection(firebaseCollectionKeys.users).document(uid).updateData([
            "subPassions" :arrSelection,
            "profileSetup":5
            
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
extension SetSubPassionVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        objSetSubPassionVM.arrSubPassionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalsCVC.className, for: indexPath) as! GoalsCVC
        let dict = objSetSubPassionVM.arrSubPassionModel[indexPath.row]
        cell.lblTitle.text = dict.title
        cell.lblTitle.textColor = objSetSubPassionVM.arrSelection.contains(dict.title ?? "") ? .white : .black
        cell.btnCross.isHidden = !objSetSubPassionVM.arrSelection.contains(dict.title ?? "")
        cell.vwBackground.startColor = objSetSubPassionVM.arrSelection.contains(dict.title ?? "") ?#colorLiteral(red: 0.9294117647, green: 0.4666666667, blue: 0.4980392157, alpha: 1)  : #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.vwBackground.endColor = objSetSubPassionVM.arrSelection.contains(dict.title ?? "") ? #colorLiteral(red: 0.9490196078, green: 0.6470588235, blue: 0.5333333333, alpha: 1) : #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(actionDelete), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/3 - 10, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = objSetSubPassionVM.arrSubPassionModel[indexPath.row]
        if !objSetSubPassionVM.arrSelection.contains(dict.title ?? "") {
            objSetSubPassionVM.arrSelection.add(dict.title ?? "")
            let cell = collectionView.cellForItem(at: indexPath) as! GoalsCVC
            cell.vwBackground.startColor = #colorLiteral(red: 0.9294117647, green: 0.4666666667, blue: 0.4980392157, alpha: 1)
            cell.vwBackground.endColor =  #colorLiteral(red: 0.9490196078, green: 0.6470588235, blue: 0.5333333333, alpha: 1)
            cell.lblTitle.textColor = .white
            cell.btnCross.isHidden = false
            collectionView.reloadData()
        }
    }
    
    @objc func actionDelete(_ sender:UIButton){
        let dict = objSetSubPassionVM.arrSubPassionModel[sender.tag]
        objSetSubPassionVM.arrSelection.remove(dict.title ?? "")
        let cell = collVwGoals.cellForItem(at: IndexPath(item: sender.tag, section: .zero)) as! GoalsCVC
        cell.vwBackground.startColor = #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.vwBackground.endColor =  #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        cell.lblTitle.textColor = .black
        cell.btnCross.isHidden = true
        self.collVwGoals.reloadData()
    }
    
}



