/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FirebaseAuth
class ForgotPasswordVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldEmail: UITextField!
    
    //MARK:- Variables
    var objForgotPasswordVM = ForgotPasswordVM()
    
        //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
         UITextField.connectAllTxtFieldFields(txtfields: [txtFldEmail])
      
    }
    //MARK:- UIActions
   
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
        
    }
    @IBAction func actionSubmit(_ sender: UIButton) {
        if txtFldEmail.text == "" {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.email)
        } else {
            objForgotPasswordVM.forgotPass(txtFldEmail.text!) {
                self.popToBack()
                Proxy.shared.displayStatusCodeAlert(AlertMessage.resetLink)
            }
        }
    }
}
