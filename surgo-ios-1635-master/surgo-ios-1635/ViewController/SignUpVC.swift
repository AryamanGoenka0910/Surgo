/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import Alamofire
import FirebaseAuth
class SignUpVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var txtFldPhone: UITextField!
    @IBOutlet weak var lblAlready: UILabel!
    
    //MARK:- Variables
    var objSignUpVM = SignUpVM()
    
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldEmail,txtFldName,txtFldPassword,txtFldPhone])
        lblAlready.attributedText = Proxy.shared.createAttributedString(fullString: TitleMessage.alreadyAccount, fullStringColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), subString: TitleMessage.logIn, subStringColor: #colorLiteral(red: 0.9254901961, green: 0.4431372549, blue: 0.5294117647, alpha: 1))
    }
    //MARK:- UIActions
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        let req = SingupRequest.init(name: txtFldName.text, email: txtFldEmail.text, password: txtFldPassword.text, phoneNo: txtFldPhone.text)
        if objSignUpVM.validData(req) {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable(){
                self.objSignUpVM.userRegister(req) {
                    UserDefaults.standard.setValue(Auth.auth().currentUser!.uid, forKey: accessToken)
                    UserDefaults.standard.synchronize()
                    self.moveToNext(EnterDetailVC.className)
                    Proxy.shared.displayStatusCodeAlert(AlertMessage.signupSuccess)
                }
            }
        }
    }
    func addGesture()  {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        gestureRecognizer.numberOfTapsRequired = 1
        lblAlready.isUserInteractionEnabled = true
        lblAlready.addGestureRecognizer(gestureRecognizer)
    }
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let text = (lblAlready.text)!
        let findNew = (text as NSString).range(of: TitleMessage.logIn)
        if gestureRecognizer.didTapAttributedTextInLabel(label: lblAlready, inRange: findNew) {
            popToBack()
        }
    }
    
    @IBAction func actionEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtFldPassword.isSecureTextEntry = !sender.isSelected
    }
    
}
