/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class RequestListVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblVwRequests: UITableView!
    
    //MARK:- variables
    var objRequestListVM = RequestListVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Proxy.shared.registerNib(tblVwRequests, identifierCell: FriendRequestTVC.className)
        Proxy.shared.showActivityIndicator()
        if Proxy.shared.networkReachable() {
            self.objRequestListVM.objSearchVM.friendRequestList(objUserDetails.userId!) {
                Proxy.shared.hideActivityIndicator()
                if self.objRequestListVM.objSearchVM.arrUserRequestModel.isEmpty {
                    self.noDataFound(self.tblVwRequests,msg:TitleMessage.noFriendReq)
                } else {
                    self.tblVwRequests.backgroundView = nil
                }
                self.tblVwRequests.reloadData()
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
}


