/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class EnterDetailVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var txtFldUserName: ACFloatingTextfield!
    @IBOutlet weak var txtVwBio: UITextView!
    @IBOutlet weak var imgVwUser: UIImageView!
    
    //MARK:- Variables
    var objEnterDetailVM = EnterDetailVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        objPassImageDelegate = self
    }
    
    //MARK:- UIActions
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    
    @IBAction func actionCamera(_ sender: UIButton) {
        objEnterDetailVM.objGalleryCameraImage.customActionSheet(self)
    }
    
    @IBAction func actionContinue(_ sender: UIButton) {
        let req = UserDetailRequest.init(userImage: self.objEnterDetailVM.imageUploaded, bio: txtVwBio.text ?? "", username: txtFldUserName.text ?? "")
        if objEnterDetailVM.valiData(req) {
            Proxy.shared.showActivityIndicator()
            objEnterDetailVM.saveUserDetails(req, userImage: imgVwUser.image!) {
                self.moveToNext(SetGoalsVC.className)
            }
        }
    }
}
