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
class LoginVM: NSObject {
    
    func userLogin(_ request:SingupRequest, completion:@escaping() -> Void){
        Auth.auth().signIn(withEmail: request.email!, password: request.password!) { data, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            let uid = Auth.auth().currentUser!.uid
            DataBaseHelper.shared.getDocument(firebaseCollectionKeys.users, uid: uid) { dict in
                objUserDetails.handelData(dict)
                Proxy.shared.hideActivityIndicator()
                completion()
            }
        }
    }
    
    func validData(_ request:SingupRequest) -> Bool{
         if request.email!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.email)
        } else if !Proxy.shared.isValidEmail(request.email!) {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.validEmail)
        } else if request.password!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.password)
        } else {
            return true
        }
        return false
    }
}
