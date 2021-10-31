/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class TaskListModel: NSObject {
    
    var userId,title,taskTime,selectedDate:String?
    var state:Int?
    var arrSubtitles : NSArray?
    var taskId:String?
    var date = Date()

    func getData(_ dict:[String:Any],documentId:String) {
        taskId = documentId
        userId = dict["uid"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        taskTime = dict["taskTime"] as? String ?? ""
        selectedDate = dict["slectedDate"] as? String ?? ""
        state = dict["state"] as? Int ?? 0
        date = "2021-10-29 \(taskTime!)".stringToDate("yyyy-MM-dd HH:mm:ss")
        if let arr = dict["subTitles"] as? NSArray {
            arrSubtitles = arr
        }
        
    }
    
   

}
