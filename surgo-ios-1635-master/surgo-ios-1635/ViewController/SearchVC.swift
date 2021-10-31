/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class SearchVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tblVwUserList: UITableView!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var vwCount: GradientView!
    
    //MARK:- Variables
    var objSearchVM = SearchVM()
    
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Proxy.shared.showActivityIndicator()
        if Proxy.shared.networkReachable() {
            self.objSearchVM.getUsers {
                Proxy.shared.hideActivityIndicator()
                self.tblVwUserList.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.objSearchVM.friendRequestList(objUserDetails.userId!) {
            self.vwCount.isHidden = self.objSearchVM.arrUserRequestModel.isEmpty
            self.lblCount.text = "\(self.objSearchVM.arrUserRequestModel.count)"
        }
    }
    //MARK:- UIActions
    @IBAction func actionOpenRequests(_ sender: Any) {
        moveToNext(RequestListVC.className)
    }
}





