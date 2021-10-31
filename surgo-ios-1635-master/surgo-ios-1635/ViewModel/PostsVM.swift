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
class PostsVM: NSObject {
    //MARK:- Variables
    var arrUserPost = [PostModel]()
    var btnSelected = -1
    var selectedIndex = 0
    func getPostData(_ completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.post).getDocuments { snap, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            self.arrUserPost.removeAll()
            guard let snapshot = snap else {
                return
            }
            if !snapshot.documents.isEmpty {
                for j in 0..<snapshot.documents.count {
                    fireStoreRef.collection(firebaseCollectionKeys.post).document(snapshot.documents[j].documentID).getDocument{ (snapData, error) in
                        if error != nil {
                            Proxy.shared.hideActivityIndicator()
                            Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                            return
                        }
                        guard let data = snapData else {
                            return
                        }
                        let objPostModel = PostModel()
                        objPostModel.getData(data.data()!)
                        objPostModel.documentId = data.documentID
                        self.arrUserPost.append(objPostModel)
                        self.arrUserPost = self.arrUserPost.sorted{$0.date > $1.date}
                        completion()
                    }
                }
            } else {
        
                completion()
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
    func getUserData(_ userId:String, completion:@escaping(_ objuserModel:UserDetails) -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.users).document(userId).getDocument { (snap, error) in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            guard let snapData = snap else {
                return
            }
            let obj = UserDetails()
            obj.handelData(snapData.data()!)
            completion(obj)
        }
    }
}
//MARK:- TableView Delegates
extension PostsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPostsVM.arrUserPost.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTVC.className, for: indexPath) as! PostTVC
        if indexPath.row < objPostsVM.arrUserPost.count {
            let dict = objPostsVM.arrUserPost[indexPath.row]
            cell.btnDots.isHidden = objUserDetails.userId != dict.userId
            cell.btnDots.tag = indexPath.row
            cell.btnDots.addTarget(self, action: #selector(EditAndDelete), for: .touchUpInside)
            cell.lblUserName.text = dict.userName
            cell.lblTime.text = dict.finalTime
            cell.lblDescription.text = dict.descriptions
            cell.imgVwProfile.sd_setImage(with: URL(string: dict.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
            cell.imgVwPosts.sd_setImage(with: URL(string: dict.postImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_image"))
            cell.vwEditDelete.isHidden = indexPath.row != objPostsVM.btnSelected
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deletePost(_:)), for: .touchUpInside)
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(editPost(_:)), for: .touchUpInside)
            cell.btnShowProfile.tag = indexPath.row
            cell.btnShowProfile.addTarget(self, action: #selector(showProfile(_:)), for: .touchUpInside)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        objPostsVM.selectedIndex = indexPath.row
        tblVwPostList.reloadData()
    }
    @objc func EditAndDelete(_ sender:UIButton){
        objPostsVM.btnSelected = sender.tag == objPostsVM.btnSelected ? -1 : sender.tag
        tblVwPostList.reloadData()
    }
    @objc func showProfile(_ sender:UIButton){
        if !objPostsVM.arrUserPost.isEmpty {
            let dict = objPostsVM.arrUserPost[sender.tag]
            Proxy.shared.showActivityIndicator()
            self.objPostsVM.getUserData(dict.userId!) { (objOtherUser) in
                Proxy.shared.hideActivityIndicator()
                let controller = mainStoryboard.instantiateViewController(withIdentifier: UserProfileVC.className) as! UserProfileVC
                controller.objUserProfileVM.ObjOtherUserModel = objOtherUser
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    @objc func editPost(_ sender:UIButton){
        let dict = objPostsVM.arrUserPost[sender.tag]
        objPostsVM.btnSelected = -1
        let controller = mainStoryboard.instantiateViewController(withIdentifier: AddPostsVC.className) as! AddPostsVC
        controller.title = TitleMessage.editPost
        controller.objAddPostVM.objPostModel = dict
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func deletePost(_ sender:UIButton){
        let dict = objPostsVM.arrUserPost[sender.tag]
        self.deleteAlert(AlertMessage.deleteAlert){_ in
            Proxy.shared.showActivityIndicator()
            self.objPostsVM.deletePost(dict.documentId!){
                self.objPostsVM.arrUserPost.remove(at: sender.tag)
                self.objPostsVM.btnSelected = -1
                Proxy.shared.hideActivityIndicator()
                if self.objPostsVM.arrUserPost.isEmpty {
                    self.noDataFound(self.tblVwPostList,msg:TitleMessage.noPostYet)
                } else {
                    self.tblVwPostList.backgroundView = nil
                }
                self.tblVwPostList.reloadData()
            }
        }
    }
}


