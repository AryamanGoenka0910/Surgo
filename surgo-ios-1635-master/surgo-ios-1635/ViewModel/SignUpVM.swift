/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class SignUpVM: NSObject {
    
    func userRegister(_ request:SingupRequest, completion:@escaping() -> Void){
        Auth.auth().createUser(withEmail: request.email!, password: request.password!) { data, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            let uid = Auth.auth().currentUser!.uid
            fireStoreRef.collection(firebaseCollectionKeys.users).document(uid).setData([
                "uid" :uid,
                "number":request.phoneNo!,
                "email":request.email!,
                "fullName":request.name!,
                "dateCreated": Date(),
                "profileSetup":1
                
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
    func validData(_ request:SingupRequest) -> Bool{
        if request.name!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.name)
        } else if !Proxy.shared.isValidName(request.name!) {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.validName)
        } else if request.email!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.email)
        } else if !Proxy.shared.isValidEmail(request.email!) {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.validEmail)
        } else if request.password!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.password)
        } else if request.password!.count < 8 {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.minimumPassword)
        } else if request.phoneNo!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.mobileNumber)
        } else if !Proxy.shared.isValidPhone(request.phoneNo!) && request.phoneNo!.count < 5 {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.correctMobile)
        } else {
            return true
        }
        return false
    }
}
extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField == txtFldPhone ? range.location < 15 : true
    }
}
