/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import Foundation
struct SingupRequest {
    var name,email,password,phoneNo:String?
    
}
struct UserDetailRequest {
    var userImage,bio,username:String?
}
struct ChangePassRequest {
    var oldPass,newPass,confirmPass:String?
}
struct AddPostsRequest {
    var description,postImage:String?
    
}
struct AddTaskRequest {
    var date,title,time:String?
    var arrSubTitle:NSMutableArray?
}
