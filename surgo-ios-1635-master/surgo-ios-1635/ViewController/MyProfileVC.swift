/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class MyProfileVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblVwUserPost: UITableView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var arrBtnList: [UIButton]!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblPassion: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet var vwSeelction: [GradientView]!
    @IBOutlet weak var lblNoDataFound: UILabel!
    //MARK:- Variables
    var objMyProfileVM = MyProfileVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Proxy.shared.registerNib(tblVwUserPost, identifierCell: PostTVC.className)
        Proxy.shared.registerNib(tblVwUserPost, identifierCell: SettingsTVC.className)
        showUserData()
        animateSegments(arrBtnList.first!)
    }
    override func viewWillAppear(_ animated: Bool) {
        getPostedApi()
    }
    func showUserData(){
        lblEmail.text = objUserDetails.email
        lblName.text = objUserDetails.name
        lblBio.text = objUserDetails.bio
        lblPassion.text = objUserDetails.passion
        lblContactNo.text = objUserDetails.conatctNo
        imgVwUser.sd_setImage(with: URL(string: objUserDetails.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
    }
    //MARK:- UIActions
    @IBAction func animateSegments(_ sender: UIButton) {
        vwSeelction.forEach { vw in
            vw.startColor = vw.tag == sender.tag ? #colorLiteral(red: 0.9254901961, green: 0.4431372549, blue: 0.5294117647, alpha: 1) : #colorLiteral(red: 0.9489304423, green: 0.9490666986, blue: 0.94890064, alpha: 1)
            vw.endColor = vw.tag == sender.tag ? #colorLiteral(red: 0.9568627451, green: 0.7215686275, blue: 0.5764705882, alpha: 1) : #colorLiteral(red: 0.9489304423, green: 0.9490666986, blue: 0.94890064, alpha: 1)
        }
        arrBtnList.forEach(){$0.setTitleColor($0.tag == sender.tag ? .white : .black, for: .normal)}
        objMyProfileVM.selectedSegment = sender.tag
        getPostedApi()
    }
    func getPostedApi(){
        if objMyProfileVM.selectedSegment == 0 {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable() {
                self.objMyProfileVM.getPostData {
                    Proxy.shared.hideActivityIndicator()
                    self.lblNoDataFound.text = self.objMyProfileVM.arrUserPost.isEmpty ? TitleMessage.noDataFound : ""
                    self.tblVwUserPost.setContentOffset(.zero, animated: true)
                    self.tblVwUserPost.reloadData()
                }
            }
        } else {
            lblNoDataFound.text = ""
            tblVwUserPost.reloadData()
        }
    }
    @IBAction func actionMyFriends(_ sender: UIButton) {
        moveToNext(MyFriendsVC.className)
    }
    @IBAction func actionEditProfile(_ sender: UIButton) {
        let controller = mainStoryboard.instantiateViewController(withIdentifier: EditProfileVC.className) as! EditProfileVC
        controller.objEditProfileVM.objCompUser = {
            self.showUserData()
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

