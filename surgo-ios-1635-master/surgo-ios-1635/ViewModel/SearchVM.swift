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
class SearchVM: NSObject {
    
    //MARK:- Variables
    var arrUsers = [UserDetails]()
    var arrFilter = [UserDetails]()
    var arrUserRequestModel = [UserDetails]()
    
    func friendRequestList(_ userId:String, completion:@escaping()-> Void){
        fireStoreRef.collection(firebaseCollectionKeys.friendRequests).document(userId).collection(firebaseCollectionKeys.userDetail).addSnapshotListener({ querySnapshot, error in
            
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            self.arrUserRequestModel.removeAll()
            guard let snapshot = querySnapshot else {
                return
            }
            self.arrUserRequestModel = snapshot.documents.map({ document -> UserDetails in
                let ObjOtherUserModel = UserDetails()
                ObjOtherUserModel.handelData(document.data())
                ObjOtherUserModel.documentId = document.documentID
                return ObjOtherUserModel
            })
           
            completion()
        })
    }
    
    func getUsers(_ completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.users).getDocuments { snapShot, error in
            self.arrUsers.removeAll()
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            if let arrList = snapShot {
                self.arrUsers = arrList.documents.map({ dict -> UserDetails in
                    let objUserDetails = UserDetails()
                    objUserDetails.handelData(dict.data())
                    return objUserDetails
                })
                self.arrUsers = self.arrUsers.filter{$0.userId != objUserDetails.userId && $0.name != ""}
              
                self.arrFilter = self.arrUsers
                Proxy.shared.hideActivityIndicator()
                completion()
            } else {
                Proxy.shared.hideActivityIndicator()
            }
        }
    }
}
extension SearchVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSearchVM.arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchListTVC.className, for: indexPath) as! SearchListTVC
        let dict = objSearchVM.arrUsers[indexPath.row]
        cell.lblName.text = dict.name
        cell.imgVwUser.sd_setImage(with: URL(string: dict.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
        cell.btnDetail.tag = indexPath.row
        cell.btnDetail.addTarget(self, action: #selector(userDetail), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !objSearchVM.arrUsers.isEmpty {
            let controller = mainStoryboard.instantiateViewController(withIdentifier: UserProfileVC.className) as! UserProfileVC
            controller.objUserProfileVM.ObjOtherUserModel = objSearchVM.arrUsers[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    @objc func userDetail(_ sender:UIButton){
        if !objSearchVM.arrUsers.isEmpty {
            let controller = mainStoryboard.instantiateViewController(withIdentifier: UserProfileVC.className) as! UserProfileVC
            controller.objUserProfileVM.ObjOtherUserModel = objSearchVM.arrUsers[sender.tag]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension SearchVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txt = (txtFldSearch.text ?? "") as NSString
        let txtAfterUpdate = txt.replacingCharacters(in: range, with: string)
        if txtAfterUpdate.isEmpty {
            self.noDataFound(self.tblVwUserList)
            self.objSearchVM.arrUsers = self.objSearchVM.arrFilter
            self.tblVwUserList.reloadData()
        } else {
            self.objSearchVM.arrUsers = self.objSearchVM.arrFilter.filter{$0.name != "" && $0.name!.prefix(txtAfterUpdate.count).lowercased().contains(txtAfterUpdate.lowercased())}
            self.tblVwUserList.reloadData()
        }
        return true
    }
}
