/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class MyFriendsVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblVwFriendList: UITableView!
    //MARK:- Variables
    var objMyFriendsVM = MyFriendsVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getFriends()
    }
    func getFriends(){
        Proxy.shared.showActivityIndicator()
        if Proxy.shared.networkReachable() {
            objMyFriendsVM.getFriends {
                Proxy.shared.hideActivityIndicator()
                if self.objMyFriendsVM.arrFriendsModel.isEmpty {
                    self.noDataFound(self.tblVwFriendList)
                } else {
                    self.tblVwFriendList.backgroundView = nil
                }
                self.tblVwFriendList.reloadData()
            }
        }
    }
    //MARK:- IBAtions
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
}


