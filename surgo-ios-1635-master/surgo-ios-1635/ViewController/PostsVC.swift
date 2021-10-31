/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class PostsVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tblVwPostList: UITableView!
    //MARK:- Variables
    var objPostsVM = PostsVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Proxy.shared.registerNib(tblVwPostList, identifierCell: PostTVC.className)
    }
    override func viewWillAppear(_ animated: Bool) {
        postList()
    }
    
    func postList(){
        Proxy.shared.showActivityIndicator()
        if Proxy.shared.networkReachable() {
            self.objPostsVM.getPostData {
                Proxy.shared.hideActivityIndicator()
//                let sorted =  self.objPostsVM.arrUserPost.sorted{$0.time.compare($1.time) == .orderedAscending}
//                self.objPostsVM.arrUserPost = sorted
//                for date in sorted{
//                    debugPrint("\(date.time)")
//                }
                if self.objPostsVM.arrUserPost.isEmpty {
                    self.noDataFound(self.tblVwPostList,msg:TitleMessage.noPostYet)
                } else {
                    self.tblVwPostList.backgroundView = nil
                }
                self.tblVwPostList.reloadData()
                if !self.objPostsVM.arrUserPost.isEmpty {
                    self.tblVwPostList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionAddPost(_ sender: Any) {
        moveToNext(AddPostsVC.className)
    }
}

