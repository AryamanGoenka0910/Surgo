/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FirebaseAuth
class ForgotPasswordVM: NSObject {
    
    func forgotPass(_ email:String, completion:@escaping() -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            completion()
            
        }
    }

}
