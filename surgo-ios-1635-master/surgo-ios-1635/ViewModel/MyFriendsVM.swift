/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/


import UIKit

class MyFriendsVM: NSObject {
    
    //MARK:- Variables
    var arrFriendsModel = [UserDetails]()
    
    func getFriends(_ completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.friends).document(objUserDetails.userId!).collection(firebaseCollectionKeys.userDetail).getDocuments { querySnapshot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            self.arrFriendsModel.removeAll()
            guard let snapshot = querySnapshot else {
                return
            }
            self.arrFriendsModel = snapshot.documents.map({ document -> UserDetails in
                let ObjOtherUserModel = UserDetails()
                ObjOtherUserModel.handelData(document.data())
                ObjOtherUserModel.documentId = document.documentID
                return ObjOtherUserModel
            })
            completion()
        }
    }
}
//MARK:- TableView Delegates
extension MyFriendsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objMyFriendsVM.arrFriendsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchListTVC.className, for: indexPath) as! SearchListTVC
        let dict = objMyFriendsVM.arrFriendsModel[indexPath.row]
        cell.lblName.text = dict.name
        cell.imgVwUser.sd_setImage(with: URL(string: dict.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
        cell.btnDetail.tag = indexPath.row
        cell.btnDetail.addTarget(self, action: #selector(userDetail), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !objMyFriendsVM.arrFriendsModel.isEmpty {
            let controller = mainStoryboard.instantiateViewController(withIdentifier: UserProfileVC.className) as! UserProfileVC
            controller.objUserProfileVM.ObjOtherUserModel = objMyFriendsVM.arrFriendsModel[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @objc func userDetail(_ sender:UIButton){
        if !objMyFriendsVM.arrFriendsModel.isEmpty {
            let controller = mainStoryboard.instantiateViewController(withIdentifier: UserProfileVC.className) as! UserProfileVC
            controller.objUserProfileVM.ObjOtherUserModel = objMyFriendsVM.arrFriendsModel[sender.tag]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}
