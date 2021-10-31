/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
class EnterDetailVM: NSObject {
    //MARK:- Variables
    var imageUploaded = String()
    var objGalleryCameraImage = GalleryCameraImage()
   
    
    func valiData(_ req:UserDetailRequest) -> Bool{
        if req.userImage!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.uploadImage)
        } else if req.username!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.enterUsername)
        } else if req.bio!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.enterBio)
        } else {
            return true
        }
        return false
    }
    
    func saveUserDetails(_ req:UserDetailRequest,userImage:UIImage, completion:@escaping() -> Void){
        let uid = Auth.auth().currentUser!.uid
        DataBaseHelper.shared.UploadImage(userImage: userImage, path: profileImagesPath){ (url) in
            fireStoreRef.collection(firebaseCollectionKeys.users).document(uid).updateData([
                "imageurl": url,
                "username": req.username!,
                "bio": req.bio!,
                "profileSetup":2
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
}
extension EnterDetailVC:PassImageDelegate {
    
    func passSelectedImgCrop(selectImage: UIImage) {
        imgVwUser.image = selectImage
        self.objEnterDetailVM.imageUploaded = AlertMessage.uploadImage
    }
    
}

