/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/


import UIKit
import FirebaseAuth
class AddPostsVM: NSObject {
    //MARK:- Variables
    var objPostModel = PostModel()
    var imageUploaded = String()
    var objGalleryCameraImage = GalleryCameraImage()
    func addPosts(_ req:AddPostsRequest,postImage:UIImage, completion:@escaping() -> Void){
        DataBaseHelper.shared.UploadImage(userImage: postImage, path: postImagesPath){ (url) in
            fireStoreRef.collection(firebaseCollectionKeys.post).document().setData([
                "url": url,
                "title": req.description!,
                "fullName": objUserDetails.name ?? "",
                "imageurl": objUserDetails.userImage ?? "",
                "time": Date(),
                "uid":objUserDetails.userId ?? ""
            ]) { (err) in
                if err != nil {
                    Proxy.shared.hideActivityIndicator()
                    Proxy.shared.displayStatusCodeAlert(err!.localizedDescription)
                    return
                }
            completion()
            }
        }
    }
    func editPost(_ req:AddPostsRequest,postImage: UIImage, completion:@escaping() -> Void){
        DataBaseHelper.shared.UploadImage(userImage: postImage, path: profileImagesPath){ (url) in
            fireStoreRef.collection(firebaseCollectionKeys.post).document(self.objPostModel.documentId ?? "").updateData ([
                "url": url,
                "title": req.description!,
                "fullName": objUserDetails.name ?? "",
                "imageurl": objUserDetails.userImage ?? "",
                "time": Date(),
                "uid":objUserDetails.userId ?? ""
            ]) { (err) in
                if err != nil {
                    Proxy.shared.hideActivityIndicator()
                    Proxy.shared.displayStatusCodeAlert(err!.localizedDescription)
                    return
                }
                completion()
            }
        }
    }
    func validData(_ req:AddPostsRequest,titleVal:String) -> Bool{
        if req.postImage!.isBlank && titleVal.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.uploadPostImage)
        } else if req.description!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.enterDescription)
        }else {
            return true
        }
        return false
    }
}
