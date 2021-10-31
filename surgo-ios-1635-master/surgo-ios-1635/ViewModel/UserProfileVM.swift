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
class UserProfileVM: NSObject {
    
    //MARK:- Variables
    var selectedSegment = Int()
    var arrUserPost = [PostModel]()
    var ObjOtherUserModel = UserDetails()
    var arrUserRequestModel = [UserDetails]()
    var arrMyFriendsModel = [UserDetails]()
    var btnSelected = -1
    
    func sendFriendRequest(_ userDetail:UserDetails, completion:@escaping()-> Void){
        let dict = ["uid" :objUserDetails.userId ?? "",
                    "fullName":objUserDetails.name ?? "",
                    "dateCreated": Date(),
                    "imageurl": objUserDetails.userImage ?? "",
                    "username": objUserDetails.username ?? "",
                    "bio": objUserDetails.bio ?? "",
        ] as [String:Any]
        fireStoreRef.collection(firebaseCollectionKeys.friendRequests).document(userDetail.userId!).collection(firebaseCollectionKeys.userDetail).document().setData(dict) { error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            completion()
        }
    }
    func getFriendPost(_ completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.post).whereField("uid", isEqualTo: ObjOtherUserModel.userId!).getDocuments{ querySnapShot, error in
            self.arrUserPost.removeAll()
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            guard let snapshot = querySnapShot else {
                return
            }
            if !snapshot.documents.isEmpty {
                self.arrUserPost = snapshot.documents.map({ dict -> PostModel in
                    let objPostModel = PostModel()
                    objPostModel.getData(dict.data())
                    objPostModel.documentId = dict.documentID
                    return objPostModel
                })
                self.arrUserPost = self.arrUserPost.sorted{$0.date < $1.date}
                completion()
            } else {
                completion()
            }
        }
    }
    func friendRequestList(_ userDetail:UserDetails, completion:@escaping()-> Void){
        fireStoreRef.collection(firebaseCollectionKeys.friendRequests).document(userDetail.userId!).collection(firebaseCollectionKeys.userDetail).getDocuments { querySnapshot, error in
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
        }
    }
    func friendList(_ userDetail:UserDetails, completion:@escaping()-> Void){
        fireStoreRef.collection(firebaseCollectionKeys.friends).document(userDetail.userId!).collection(firebaseCollectionKeys.userDetail).getDocuments { querySnapshot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            self.arrMyFriendsModel.removeAll()
            guard let snapshot = querySnapshot else {
                return
            }
            self.arrMyFriendsModel = snapshot.documents.map({ document -> UserDetails in
                let ObjOtherUserModel = UserDetails()
                ObjOtherUserModel.handelData(document.data())
                ObjOtherUserModel.documentId = document.documentID
                return ObjOtherUserModel
            })
            completion()
        }
    }
    func sendRequestThisuserToMe(_ userDetail:UserDetails, completion:@escaping(_ isYes:Bool)-> Void){
        fireStoreRef.collection(firebaseCollectionKeys.friendRequests).document(objUserDetails.userId!).collection(firebaseCollectionKeys.userDetail).getDocuments { querySnapshot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else {
                completion(false)
                return
            }
            var arrData = [UserDetails]()
            arrData = snapshot.documents.map({ document -> UserDetails in
                let ObjOtherUserModel = UserDetails()
                ObjOtherUserModel.handelData(document.data())
                ObjOtherUserModel.documentId = document.documentID
                return ObjOtherUserModel
            })
            completion(arrData.filter{$0.userId == userDetail.userId}.count > 0)
        }
    }
    func unfriendUser(_ userDetail:UserDetails, completion:@escaping()-> Void){
        fireStoreRef.collection(firebaseCollectionKeys.friends).document(objUserDetails.userId!).collection(firebaseCollectionKeys.userDetail).getDocuments { querySnapshot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            guard let snapshot = querySnapshot else {
                return
            }
            var arrData = [UserDetails]()
            arrData = snapshot.documents.map({ document -> UserDetails in
                let ObjOtherUserModel = UserDetails()
                ObjOtherUserModel.handelData(document.data())
                ObjOtherUserModel.documentId = document.documentID
                return ObjOtherUserModel
            })
            let arr = arrData.filter{$0.userId == userDetail.userId}
            if !arr.isEmpty {
                fireStoreRef.collection(firebaseCollectionKeys.friends).document(objUserDetails.userId!).collection(firebaseCollectionKeys.userDetail).document(arr.first!.documentId!).delete { error in
                    if error != nil {
                        Proxy.shared.hideActivityIndicator()
                        Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                        return
                    }
                    fireStoreRef.collection(firebaseCollectionKeys.friends).document(userDetail.userId!).collection(firebaseCollectionKeys.userDetail).getDocuments { querySnapshot, error in
                        if error != nil {
                            Proxy.shared.hideActivityIndicator()
                            Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                            return
                        }
                        
                        guard let snapshot = querySnapshot else {
                            return
                        }
                        var arrDetail = [UserDetails]()
                        arrDetail = snapshot.documents.map({ document -> UserDetails in
                            let ObjOtherUserModel = UserDetails()
                            ObjOtherUserModel.handelData(document.data())
                            ObjOtherUserModel.documentId = document.documentID
                            return ObjOtherUserModel
                        })
                        let arrUser = arrDetail.filter{$0.userId == objUserDetails.userId}
                        if !arrUser.isEmpty {
                            fireStoreRef.collection(firebaseCollectionKeys.friends).document(userDetail.userId!).collection(firebaseCollectionKeys.userDetail).document(arrUser.first!.documentId!).delete { error in
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
        }
    }
    
    func deletePost(_ documentId:String, completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.post).document(documentId).delete { error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            completion()
        }
    }
}
//MARK:- TableView Delegates
extension UserProfileVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.objUserProfileVM.selectedSegment == 0 ? objUserProfileVM.arrMyFriendsModel.count : objUserProfileVM.arrUserPost.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if objUserProfileVM.selectedSegment == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendTVC.className, for: indexPath) as! MyFriendTVC
            let dict = objUserProfileVM.arrMyFriendsModel[indexPath.row]
            cell.lblName.text = dict.name
            cell.imgVwUser.sd_setImage(with: URL(string: dict.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
            cell.btnDetail.tag = indexPath.row
            cell.btnDetail.addTarget(self, action: #selector(userDetail), for:.touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTVC.className, for: indexPath) as! PostTVC
            let dict = objUserProfileVM.arrUserPost[indexPath.row]
            cell.btnDots.isHidden = objUserDetails.userId != dict.userId
            cell.lblUserName.text = dict.userName
            cell.lblTime.text = dict.finalTime
            cell.lblDescription.text = dict.descriptions
            cell.imgVwProfile.sd_setImage(with: URL(string: dict.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
            cell.imgVwPosts.sd_setImage(with: URL(string: dict.postImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_image"))
            cell.vwEditDelete.isHidden = indexPath.row != objUserProfileVM.btnSelected
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(DeletePost(_:)), for: .touchUpInside)
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(EditPost(_:)), for: .touchUpInside)
            cell.btnDots.tag = indexPath.row
            cell.btnDots.addTarget(self, action: #selector(EditAndDelete), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objUserProfileVM.selectedSegment == 0 ? 70 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if objUserProfileVM.selectedSegment == 0 {
            if !objUserProfileVM.arrMyFriendsModel.isEmpty {
                let controller = mainStoryboard.instantiateViewController(withIdentifier: UserProfileVC.className) as! UserProfileVC
                controller.objUserProfileVM.ObjOtherUserModel = objUserProfileVM.arrMyFriendsModel[indexPath.row]
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    @objc func userDetail(_ sender:UIButton){
        if !objUserProfileVM.arrMyFriendsModel.isEmpty {
            self.noDataFound(self.tblVwUserPost)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: UserProfileVC.className) as! UserProfileVC
            controller.objUserProfileVM.ObjOtherUserModel = objUserProfileVM.arrMyFriendsModel[sender.tag]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    @objc func EditAndDelete(_ sender:UIButton){
        objUserProfileVM.btnSelected = sender.tag == objUserProfileVM.btnSelected ? -1 : sender.tag
        tblVwUserPost.reloadData()
    }
    @objc func EditPost(_ sender:UIButton){
        let dict = objUserProfileVM.arrUserPost[sender.tag]
        objUserProfileVM.btnSelected = -1
        let controller = mainStoryboard.instantiateViewController(withIdentifier: AddPostsVC.className) as! AddPostsVC
        controller.title = TitleMessage.editPost
        controller.objAddPostVM.objPostModel = dict
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func DeletePost(_ sender:UIButton){
        let dict = objUserProfileVM.arrUserPost[sender.tag]
        self.deleteAlert(AlertMessage.deleteAlert){_ in
            Proxy.shared.showActivityIndicator()
            self.objUserProfileVM.deletePost(dict.documentId!){
                self.objUserProfileVM.arrUserPost.remove(at: sender.tag)
                self.objUserProfileVM.btnSelected = -1
                Proxy.shared.hideActivityIndicator()
                self.tblVwUserPost.reloadData()
            }
        }
    }
}
