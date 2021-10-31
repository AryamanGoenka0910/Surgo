/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FirebaseAuth
class LoginVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var lblAccount: UILabel!
    
    //MARK:- Variables
    let objLoginVM = LoginVM()
    
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
         UITextField.connectAllTxtFieldFields(txtfields: [txtFldEmail,txtFldPassword])
        lblAccount.attributedText = Proxy.shared.createAttributedString(fullString: TitleMessage.dontAccount, fullStringColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), subString: TitleMessage.signUp, subStringColor: #colorLiteral(red: 0.9254901961, green: 0.4431372549, blue: 0.5294117647, alpha: 1))
    }
    
    //MARK:- UIActions
    @IBAction func actionEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtFldPassword.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        moveToNext(ForgotPasswordVC.className)
    }
    @IBAction func actionLogIn(_ sender: UIButton) {
        let req = SingupRequest.init(name: "", email: txtFldEmail.text, password: txtFldPassword.text, phoneNo: "")
        if self.objLoginVM.validData(req) {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable() {
                self.objLoginVM.userLogin(req) {
                    UserDefaults.standard.setValue(Auth.auth().currentUser!.uid, forKey: accessToken)
                    UserDefaults.standard.synchronize()
                    let uid = Auth.auth().currentUser!.uid
                    DataBaseHelper.shared.getDocument(firebaseCollectionKeys.users, uid: uid) { dict in
                        objUserDetails.handelData(dict)
                        switch objUserDetails.profileSetup {
                        case ProfileSteps.singup.rawValue:
                            self.moveToNext(EnterDetailVC.className,titleStr: TitleMessage.fromSplash)
                        case ProfileSteps.userDetail.rawValue:
                            self.moveToNext(SetGoalsVC.className,titleStr: TitleMessage.fromSplash)
                        case ProfileSteps.goals.rawValue:
                            self.moveToNext(SetPassionVC.className,titleStr: TitleMessage.fromSplash)
                        case ProfileSteps.passion.rawValue:
                            self.moveToNext(SetSubPassionVC.className,titleStr: TitleMessage.fromSplash)
                        case ProfileSteps.subPassion.rawValue:
                            self.rootWithoutDrawer(MainTBC.className)
                        default :
                            break
                        }
                        Proxy.shared.displayStatusCodeAlert(AlertMessage.loginSuccess)
                    }
                }
            }
        }
        
    }
    func addGesture()  {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        gestureRecognizer.numberOfTapsRequired = 1
        lblAccount.isUserInteractionEnabled = true
        lblAccount.addGestureRecognizer(gestureRecognizer)
    }
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let text = (lblAccount.text)!
        let findNew = (text as NSString).range(of:  TitleMessage.signUp)
        if gestureRecognizer.didTapAttributedTextInLabel(label: lblAccount, inRange: findNew) {
            self.moveToNext(SignUpVC.className)
        }
    }
}
