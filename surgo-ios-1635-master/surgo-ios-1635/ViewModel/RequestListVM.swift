/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class RequestListVM: NSObject {
    
    //MARK:- Varaibles
    var objSearchVM = SearchVM()
    
    func rejectReq(_ documentId:String, completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.friendRequests).document(objUserDetails.userId!).collection(firebaseCollectionKeys.userDetail).document(documentId).delete { error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            completion()
        }
    }
    func acceptReq(_ documentId:String, userDetail:UserDetails, completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.friendRequests).document(objUserDetails.userId!).collection(firebaseCollectionKeys.userDetail).document(documentId).delete { error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            let dict = ["uid" :userDetail.userId ?? "",
                        "fullName":userDetail.name ?? "",
                        "dateCreated": Date(),
                        "imageurl": userDetail.userImage ?? "",
                        "username": userDetail.username ?? "",
                        "bio": userDetail.bio ?? "",
            ] as [String:Any]
            fireStoreRef.collection(firebaseCollectionKeys.friends).document(objUserDetails.userId!).collection(firebaseCollectionKeys.userDetail).document().setData(dict) { error in
                if error != nil {
                    Proxy.shared.hideActivityIndicator()
                    Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                    return
                }
                let dict = ["uid" :objUserDetails.userId ?? "",
                            "fullName":objUserDetails.name ?? "",
                            "dateCreated": Date(),
                            "imageurl": objUserDetails.userImage ?? "",
                            "username": objUserDetails.username ?? "",
                            "bio": objUserDetails.bio ?? "",
                ] as [String:Any]
                fireStoreRef.collection(firebaseCollectionKeys.friends).document(userDetail.userId!).collection(firebaseCollectionKeys.userDetail).document().setData(dict) { error in
                    if error != nil {
                        Proxy.shared.hideActivityIndicator()
                        Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                        return
                    }
                completion()
            }
            
        }
    }
    }
}
//MARK:- TableView Delegates
extension RequestListVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objRequestListVM.objSearchVM.arrUserRequestModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestTVC.className, for: indexPath) as! FriendRequestTVC
        let dict = self.objRequestListVM.objSearchVM.arrUserRequestModel[indexPath.row]
        cell.imgVwUser.sd_setImage(with: URL(string: dict.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
        cell.lblName.text = dict.name
        cell.btnRejectReq.tag = indexPath.row
        cell.btnRejectReq.addTarget(self, action: #selector(rejectReq), for: .touchUpInside)
        cell.btnAccept.tag = indexPath.row
        cell.btnAccept.addTarget(self, action: #selector(acceptReq), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.objRequestListVM.objSearchVM.arrUserRequestModel.isEmpty {
            let controller = mainStoryboard.instantiateViewController(withIdentifier: UserProfileVC.className) as! UserProfileVC
            controller.objUserProfileVM.ObjOtherUserModel = self.objRequestListVM.objSearchVM.arrUserRequestModel[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func rejectReq(_ sender:UIButton){
        if !self.objRequestListVM.objSearchVM.arrUserRequestModel.isEmpty {
            let dict = self.objRequestListVM.objSearchVM.arrUserRequestModel[sender.tag]
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable() {
            self.objRequestListVM.rejectReq(dict.documentId!) {
                Proxy.shared.hideActivityIndicator()
                if self.objRequestListVM.objSearchVM.arrUserRequestModel.isEmpty {
                    self.noDataFound(self.tblVwRequests,msg:TitleMessage.noFriendReq)
                } else {
                    self.tblVwRequests.backgroundView = nil
                }
                self.tblVwRequests.reloadData()
            }
            }
        }
        }
    
    @objc func acceptReq(_ sender:UIButton){
        if !self.objRequestListVM.objSearchVM.arrUserRequestModel.isEmpty {
            let dict = self.objRequestListVM.objSearchVM.arrUserRequestModel[sender.tag]
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable() {
                self.objRequestListVM.acceptReq(dict.documentId!, userDetail: dict) {
                    Proxy.shared.displayStatusCodeAlert(TitleMessage.requestSuccessfull)
                    Proxy.shared.hideActivityIndicator()
                    if self.objRequestListVM.objSearchVM.arrUserRequestModel.isEmpty {
                        self.noDataFound(self.tblVwRequests,msg: TitleMessage.noFriendReq)
                    } else {
                        self.tblVwRequests.backgroundView = nil
                    }
                    self.tblVwRequests.reloadData()
                }
            }
        }
    }
}
