/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/
import UIKit

class EditProfileVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var txtVwBio: UITextView!
    @IBOutlet weak var txtFldName: ACFloatingTextfield!
    @IBOutlet weak var txtFldUsername: ACFloatingTextfield!
    @IBOutlet weak var txtFldEmail: ACFloatingTextfield!
    @IBOutlet weak var txtFldConatctNo: ACFloatingTextfield!
    //MARK:- Varaibles
    var objEditProfileVM = EditProfileVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        objPassImageDelegate = self
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldName,txtFldUsername,txtFldConatctNo])
        ShowData()
    }
    
    func ShowData(){
        txtFldUsername.text = objUserDetails.username
        txtFldEmail.text = objUserDetails.email
        txtFldName.text = objUserDetails.name
        txtVwBio.text = objUserDetails.bio
        txtFldConatctNo.text = objUserDetails.conatctNo
        imgVwUser.sd_setImage(with: URL(string: objUserDetails.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
    }
    //MARK:- IBaction
    @IBAction func actionSave(_ sender: UIButton){
        let requset = SingupRequest.init(name: txtFldName.text, email: txtFldEmail.text, password: "", phoneNo: txtFldConatctNo.text)
        let req = UserDetailRequest.init(userImage: "", bio: txtVwBio.text, username: txtFldUsername.text)
        if objEditProfileVM.valiData(req, request: requset) {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable(){
                self.objEditProfileVM.saveUserDetails(req, userImage: imgVwUser.image!, request: requset) {
                    guard let finalComp = self.objEditProfileVM.objCompUser else {return}
                    finalComp()
                    self.popToBack()
                }
            }
        }
    }
    @IBAction func actionCamera(_ sender: UIButton) {
        objEditProfileVM.objGalleryCameraImage.customActionSheet(self)
    }
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
        
    }
}
extension EditProfileVC:PassImageDelegate {
    func passSelectedImgCrop(selectImage: UIImage) {
        imgVwUser.image = selectImage
    }
    
}
extension EditProfileVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField == txtFldConatctNo ? range.location < 15 : true
    }
}

