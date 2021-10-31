/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class UserProfileVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblVwUserPost: UITableView!
    @IBOutlet var arrBtnList: [UIButton]!
    @IBOutlet var vwSeelction: [GradientView]!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var btnSendRequest: UIButton!
    //MARK:- Variables
    var objUserProfileVM = UserProfileVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBtnTitle(self.objUserProfileVM.ObjOtherUserModel.userId == objUserDetails.userId ? TitleMessage.you : "")
        Proxy.shared.registerNib(tblVwUserPost, identifierCell: MyFriendTVC.className)
        Proxy.shared.registerNib(tblVwUserPost, identifierCell: PostTVC.className)
        showData(self.objUserProfileVM.ObjOtherUserModel)
        userRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
      
        animateSegments(arrBtnList.first!)
    }
    func userRequest(){
        Proxy.shared.showActivityIndicator()
        if Proxy.shared.networkReachable() {
            self.objUserProfileVM.friendRequestList(objUserProfileVM.ObjOtherUserModel) { [self] in
                let arr = self.objUserProfileVM.arrUserRequestModel.filter{$0.userId == objUserDetails.userId}
                self.setBtnTitle(arr.isEmpty ? TitleMessage.addFriend : TitleMessage.requestSent)
                self.animateSegments(self.arrBtnList.first!)
            }
        }
    }
    func setBtnTitle(_ val:String){
        self.btnSendRequest.setTitle(btnSendRequest.currentTitle == TitleMessage.you ? TitleMessage.you : val, for: .normal)
    }
    func showData(_ dict:UserDetails){
        lblName.text = dict.name
        lblBio.text = dict.bio
        imgVwUser.sd_setImage(with: URL(string: dict.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_defaultuser"))
    }
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    @IBAction func actionAddFriend(_ sender: UIButton) {
        if sender.currentTitle == TitleMessage.requestSent {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.requestAlreadySent)
        } else if sender.currentTitle == TitleMessage.recievedRequest {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.requestAlreadyRecieved)
        } else if sender.currentTitle == TitleMessage.addFriend {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable(){
                self.objUserProfileVM.sendFriendRequest(self.objUserProfileVM.ObjOtherUserModel) {
                    Proxy.shared.hideActivityIndicator()
                    self.btnSendRequest.setTitle(TitleMessage.requestSent, for: .normal)
                    Proxy.shared.displayStatusCodeAlert(AlertMessage.requestSend)
                }
            }
        } else if sender.currentTitle == TitleMessage.unFriend {
            self.showAlert(TitleMessage.sureUnFriend) { isYes in
                if isYes {
                    Proxy.shared.showActivityIndicator()
                    if Proxy.shared.networkReachable(){
                        self.objUserProfileVM.unfriendUser(self.objUserProfileVM.ObjOtherUserModel) {
                            Proxy.shared.hideActivityIndicator()
                            self.popToBack()
                            Proxy.shared.displayStatusCodeAlert(AlertMessage.unfriendSuccess)
                        }
                    }
                }
            }
        }
    }
    @IBAction func animateSegments(_ sender: UIButton) {
        vwSeelction.forEach { vw in
            vw.startColor = vw.tag == sender.tag ? #colorLiteral(red: 0.9254901961, green: 0.4431372549, blue: 0.5294117647, alpha: 1) : #colorLiteral(red: 0.9489304423, green: 0.9490666986, blue: 0.94890064, alpha: 1)
            vw.endColor = vw.tag == sender.tag ? #colorLiteral(red: 0.9568627451, green: 0.7215686275, blue: 0.5764705882, alpha: 1) : #colorLiteral(red: 0.9489304423, green: 0.9490666986, blue: 0.94890064, alpha: 1)
        }
        arrBtnList.forEach(){$0.setTitleColor($0.tag == sender.tag ? .white : .black, for: .normal)}
        objUserProfileVM.selectedSegment = sender.tag
        if self.objUserProfileVM.selectedSegment == 0 {
            self.objUserProfileVM.friendList(self.objUserProfileVM.ObjOtherUserModel) {
                let arrFrnd = self.objUserProfileVM.arrMyFriendsModel.filter{$0.userId == objUserDetails.userId}
                self.setBtnTitle(arrFrnd.isEmpty ? "\(self.btnSendRequest.currentTitle ?? "")" : TitleMessage.unFriend)
                self.objUserProfileVM.sendRequestThisuserToMe(self.objUserProfileVM.ObjOtherUserModel) { [self] isYes in
                    self.setBtnTitle(!isYes ? "\(self.btnSendRequest.currentTitle ?? "")" : TitleMessage.recievedRequest)
                    Proxy.shared.hideActivityIndicator()
                    self.tblVwUserPost.reloadData()
                    self.lblNoDataFound.text = self.objUserProfileVM.arrMyFriendsModel.isEmpty ? TitleMessage.noDataFound :  ""
                }
            }
        } else {
            self.tblVwUserPost.backgroundView = nil
            self.objUserProfileVM.sendRequestThisuserToMe(self.objUserProfileVM.ObjOtherUserModel) { isYes in
                self.setBtnTitle(!isYes ? "\(self.btnSendRequest.currentTitle ?? "")" : TitleMessage.recievedRequest)
                Proxy.shared.showActivityIndicator()
                if Proxy.shared.networkReachable(){
                    self.objUserProfileVM.getFriendPost {
                        Proxy.shared.hideActivityIndicator()
                        self.lblNoDataFound.text = self.objUserProfileVM.arrUserPost.isEmpty ? TitleMessage.noDataFound :  ""
                        self.tblVwUserPost.reloadData()
                    }
                }
            }
        }
    }
}


