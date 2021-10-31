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

class MyProfileVM: NSObject {
    //MARK:- Variables
    var arrSettings = ["Change Password","About Us","Terms and Conditions","Privacy Policy","Logout"]
    var selectedSegment = Int()
    var selectedIndex = 0
    var btnSelected = -1
    var arrUserPost = [PostModel]()
    func getPostData(_ completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.post).whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { querySnapShot, error in
            self.arrUserPost.removeAll()
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            guard let snapshot = querySnapShot else {
                return
            }
            self.arrUserPost = snapshot.documents.map({ dict -> PostModel in
                let objPostModel = PostModel()
                objPostModel.getData(dict.data())
                objPostModel.documentId = dict.documentID
                return objPostModel
            })
            self.arrUserPost = self.arrUserPost.sorted{$0.date > $1.date}
            completion()
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
extension MyProfileVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objMyProfileVM.selectedSegment == 1{
            return objMyProfileVM.arrSettings.count
        }else{
            return objMyProfileVM.arrUserPost.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if objMyProfileVM.selectedSegment == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.className, for: indexPath) as! SettingsTVC
            cell.lblTitle.text = objMyProfileVM.arrSettings[indexPath.row]
            cell.btnArrow.tag = indexPath.row
            objMyProfileVM.selectedIndex = cell.btnArrow.tag
            cell.btnArrow.addTarget(self, action: #selector(ArrowNext), for: .touchUpInside)
            if indexPath.row == objMyProfileVM.arrSettings.count-1 {
            cell.btnArrow.isHidden = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTVC.className, for: indexPath) as! PostTVC
            let dict = objMyProfileVM.arrUserPost[indexPath.row]
              cell.btnDots.isHidden = objUserDetails.userId != dict.userId
                cell.btnDots.tag = indexPath.row
                cell.btnDots.addTarget(self, action: #selector(EditAndDelete), for: .touchUpInside)
                cell.lblUserName.text = dict.userName
                cell.lblDescription.text = dict.descriptions
                cell.lblTime.text = dict.finalTime
                cell.imgVwProfile.sd_setImage(with: URL(string: dict.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
                cell.imgVwPosts.sd_setImage(with: URL(string: dict.postImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_image"))
                cell.vwEditDelete.isHidden = indexPath.row != objMyProfileVM.btnSelected
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(DeletePost(_:)), for: .touchUpInside)
                cell.btnEdit.tag = indexPath.row
                cell.btnEdit.addTarget(self, action: #selector(EditPost(_:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                if objMyProfileVM.selectedSegment == 1 && indexPath.row == 4 {
            deleteAlert(AlertMessage.logoutAlert) { isYes in
                if isYes {
                    Proxy.shared.showActivityIndicator()
                    if Proxy.shared.networkReachable(){
                        DataBaseHelper.shared.logoutUser {
                            self.rootWithoutDrawer(LoginVC.className)
                            Proxy.shared.displayStatusCodeAlert(AlertMessage.logoutSuccess)
                        }
                    }
                }
            }
        } else if objMyProfileVM.selectedSegment == 1 && indexPath.row == 0{
            moveToNext(ChangePasswordVC.className)
        }
    }
    @objc func EditAndDelete(_ sender:UIButton){
        objMyProfileVM.btnSelected = sender.tag == objMyProfileVM.btnSelected ? -1 : sender.tag
        tblVwUserPost.reloadData()
    }
    @objc func ArrowNext(_ sender:UIButton){
        if objMyProfileVM.selectedSegment == 1 && sender.tag == 4{
            deleteAlert(AlertMessage.logoutAlert) { isYes in
                if isYes {
                    Proxy.shared.showActivityIndicator()
                    if Proxy.shared.networkReachable(){
                        DataBaseHelper.shared.logoutUser {
                            self.rootWithoutDrawer(LoginVC.className)
                            Proxy.shared.displayStatusCodeAlert(AlertMessage.logoutSuccess)
                        }
                    }
                }
            }
        }else if objMyProfileVM.selectedSegment == 1 && sender.tag == 0{
            moveToNext(ChangePasswordVC.className)
        }
    }
    @objc func EditPost(_ sender:UIButton){
        if !objMyProfileVM.arrUserPost.isEmpty {
        let dict = objMyProfileVM.arrUserPost[sender.tag]
            objMyProfileVM.btnSelected = -1
        let controller = mainStoryboard.instantiateViewController(withIdentifier: AddPostsVC.className) as! AddPostsVC
        controller.title = TitleMessage.editPost
        controller.objAddPostVM.objPostModel = dict
        self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @objc func DeletePost(_ sender:UIButton){
        if !objMyProfileVM.arrUserPost.isEmpty {
        let dict = objMyProfileVM.arrUserPost[sender.tag]
        self.deleteAlert(AlertMessage.deleteAlert){_ in
            Proxy.shared.showActivityIndicator()
            self.objMyProfileVM.deletePost(dict.documentId!){
                self.objMyProfileVM.arrUserPost.remove(at: sender.tag)
                self.objMyProfileVM.btnSelected = -1
                Proxy.shared.hideActivityIndicator()
                self.lblNoDataFound.text = self.objMyProfileVM.arrUserPost.isEmpty ? TitleMessage.noDataFound : ""
                self.tblVwUserPost.reloadData()
            }
        }
        }
    }
}
