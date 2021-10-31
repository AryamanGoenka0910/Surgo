/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/


import UIKit
import FirebaseAuth
class SplashVC: UIViewController {
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(3)
    }
    override func viewDidAppear(_ animated: Bool) {
        if Proxy.shared.accessNil().isEmpty {
            self.moveToNext(LoginVC.className)
        } else {
            guard let user = Auth.auth().currentUser else {
                self.moveToNext(LoginVC.className)
                return
            }
            DataBaseHelper.shared.getDocument(firebaseCollectionKeys.users, uid: user.uid) { dict in
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
            }
        }
    }
}
