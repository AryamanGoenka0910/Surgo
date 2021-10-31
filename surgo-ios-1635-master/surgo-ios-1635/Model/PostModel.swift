/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import Firebase
import FirebaseFirestore
class PostModel {
    var userImage,userName,descriptions,finalTime,postImage,documentId ,userId: String?
    var date = Date()
    var time = Timestamp()
    var seconds = Date()
    func getData(_ dict:[String:Any]){
        userId = dict["uid"] as? String ?? ""
        userName = dict["fullName"] as? String ?? ""
        userImage = dict["imageurl"] as? String ?? ""
        postImage = dict["url"] as? String ?? ""
        time = dict["time"] as? Timestamp ?? Timestamp()
        descriptions = dict["title"] as? String ?? ""
        if let stamp = dict["time"] as? Timestamp {
            let spamptime = Int(stamp.seconds * 1000)
            date = Date(timeIntervalSince1970:TimeInterval(spamptime))
            seconds = spamptime.dateFromMilliseconds(format: "hh:mm a")
            finalTime = DateFormatter.sharedDateFormatter.string(from: seconds)
        }
    }
}

