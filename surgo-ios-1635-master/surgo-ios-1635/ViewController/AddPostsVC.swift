/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import IQKeyboardManager
class AddPostsVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var txtVwDescription: IQTextView!
    @IBOutlet weak var imgVwPosts: UIImageView!
    
    //MARK:- Variables
    var objAddPostVM = AddPostsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        objPassImageDelegate = self
        
        if self.title == TitleMessage.editPost {
            txtVwDescription.text = objAddPostVM.objPostModel.descriptions
            imgVwPosts.sd_setImage(with: URL(string: objAddPostVM.objPostModel.postImage ?? ""), placeholderImage:#imageLiteral(resourceName: "ic_image"))
        }
    }
    //MARK:- IBaction
    @IBAction func actionPost(_ sender: Any) {
        if title == TitleMessage.editPost {
            editPostApi()
        } else {
            addPostData()
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    @IBAction func actionSelectImage(_ sender: Any) {
        objAddPostVM.objGalleryCameraImage.customActionSheet(self)
    }
    func addPostData(){
        let req = AddPostsRequest.init(description: txtVwDescription.text, postImage: self.objAddPostVM.imageUploaded)
        if objAddPostVM.validData(req,titleVal:""){
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable(){
                objAddPostVM.addPosts(req, postImage: imgVwPosts.image!){
                    Proxy.shared.hideActivityIndicator()
                    self.popToBack()
                }
            }
        }
    }
    func editPostApi(){
        let req = AddPostsRequest.init(description: txtVwDescription.text, postImage: self.objAddPostVM.imageUploaded)
        if objAddPostVM.validData(req,titleVal:self.title ?? ""){
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable(){
                objAddPostVM.editPost(req, postImage: imgVwPosts.image!){
                    Proxy.shared.hideActivityIndicator()
                    self.popToBack()
                }
            }
        }
    }
}

extension AddPostsVC: PassImageDelegate {
    func passSelectedImgCrop(selectImage: UIImage) {
        self.objAddPostVM.imageUploaded = TitleMessage.addFriend
        imgVwPosts.image = selectImage
    }
}
