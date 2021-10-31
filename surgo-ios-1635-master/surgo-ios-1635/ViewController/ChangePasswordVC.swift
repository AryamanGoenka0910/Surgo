/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
class ChangePasswordVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldOldPass: ACFloatingTextfield!
    @IBOutlet weak var txtFldNewPass: ACFloatingTextfield!
    @IBOutlet weak var txtFldConfirmPass: ACFloatingTextfield!
    
    //MARK:- Variables
    var objChangePasswordVM = ChangePasswordVM()
    
    //MARK:- UIViewController's Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldOldPass,txtFldNewPass,txtFldConfirmPass])
    }
    //MARK:- UIActions
    @IBAction func actionSave(_ sender: UIButton) {
        let req = ChangePassRequest.init(oldPass: txtFldOldPass.text, newPass: txtFldNewPass.text, confirmPass: txtFldConfirmPass.text)
        if self.objChangePasswordVM.validData(req) {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable() {
                self.objChangePasswordVM.changePassword(req) {
                    DataBaseHelper.shared.logoutUser {
                        Proxy.shared.hideActivityIndicator()
                        self.rootWithoutDrawer(LoginVC.className)
                        Proxy.shared.displayStatusCodeAlert(AlertMessage.passwordChangeSuccss)
                    }
                }
            }
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    @IBAction func actionEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.tag {
        case 0:
            txtFldOldPass.isSecureTextEntry = !sender.isSelected
        case 1:
            txtFldNewPass.isSecureTextEntry = !sender.isSelected
        case 2:
            txtFldConfirmPass.isSecureTextEntry = !sender.isSelected
        default:
            break
        }
    }
}
