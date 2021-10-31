/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
var objUserDetails = UserDetails()
var arrGoalsModel = [GoalsModel]()
var arrSubpassion = [GoalsModel]()
class UserDetails: NSObject {

    var username,userImage,bio,descriptions,time,userId,email,conatctNo,name,passion,documentId,postImage : String?
    var profileSetup:Int?
    var date : Date?
    func handelData(_ dict:[String:Any]){
        username = dict["username"] as? String ?? "" 
        userImage = dict["imageurl"] as? String ?? ""
        postImage = dict["url"] as? String ?? ""
        bio = dict["bio"] as? String ?? ""
        name = dict["fullName"] as? String ?? ""
        date = dict["dateCreated"] as? Date ?? Date()
        email = dict["email"] as? String ?? ""
        conatctNo = dict["number"] as? String ?? ""
        userId = dict["uid"] as? String ?? ""
        profileSetup = Proxy.shared.getIntegerValue(dict["profileSetup"] as Any)
        passion = dict["passion"] as? String ?? ""
        descriptions = dict["title"] as? String ?? ""
        arrGoalsModel.removeAll()
        arrSubpassion.removeAll()
        if let arrList = dict["subPassions"] as? NSArray {
            arrSubpassion = arrList.map({ val in
                let obj = GoalsModel(val: "\(val)")
                return obj
            })
        }
        if let arrList = dict["goals"] as? NSArray {
            arrGoalsModel = arrList.map({ val in
                let obj = GoalsModel(val: "\(val)")
                return obj
            })
        }
    }
}
