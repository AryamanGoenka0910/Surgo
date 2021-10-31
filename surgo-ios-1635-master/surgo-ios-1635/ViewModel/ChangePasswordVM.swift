/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FirebaseAuth
class ChangePasswordVM: NSObject {
    
    
    func changePassword(_ request:ChangePassRequest, completion:@escaping() -> Void){
        let credential = EmailAuthProvider.credential(withEmail: objUserDetails.email!, password: request.oldPass!)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { data, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            Auth.auth().currentUser?.updatePassword(to: request.newPass!, completion: { err in
                if err != nil {
                    Proxy.shared.hideActivityIndicator()
                    Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                    return
                }
                completion()
            })
        })
        }
    
    func validData(_ request:ChangePassRequest) -> Bool{
        if request.oldPass!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.passwordOld)
        } else if request.newPass!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.newPassword)
        } else if request.newPass!.count < 8 {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.minimumPassword)
        } else if request.confirmPass!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.confirmPassword)
        } else if request.confirmPass != request.newPass {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.passwordMatch)
        } else {
            return true
        }
        return false
    }
    
}
