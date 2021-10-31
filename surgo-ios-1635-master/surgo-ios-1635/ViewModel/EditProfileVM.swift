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
class EditProfileVM: NSObject {
    //MARK:- Variables
    var objGalleryCameraImage = GalleryCameraImage()
    typealias compUser = () -> Void
    var objCompUser:compUser?
    func saveUserDetails(_ req:UserDetailRequest,userImage:UIImage, request:SingupRequest, completion:@escaping() -> Void){
        let uid = Auth.auth().currentUser!.uid
        DataBaseHelper.shared.UploadImage(userImage: userImage, path: profileImagesPath){ (url) in
            fireStoreRef.collection(firebaseCollectionKeys.users).document(uid).updateData([
                "imageurl": url,
                "username": req.username!,
                "bio": req.bio!,
                "number":request.phoneNo!,
                "fullName":request.name!
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
    
    func valiData(_ req:UserDetailRequest,request:SingupRequest) -> Bool{
       if request.name!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.name)
       } else if !Proxy.shared.isValidName(request.name!) {
           Proxy.shared.displayStatusCodeAlert(AlertMessage.validName)
        } else if req.username!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.enterUsername)
//        } else if !Proxy.shared.isValidName(req.username!) {
//            Proxy.shared.displayStatusCodeAlert(AlertMessage.validUsername)
        } else if request.phoneNo!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.mobileNumber)
        } else if !Proxy.shared.isValidPhone(request.phoneNo!) {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.correctMobile)
        } else if req.bio!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.enterBio)
        } else {
            return true
        }
        return false
    }
}
