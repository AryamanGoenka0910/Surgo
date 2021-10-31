/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/


import UIKit
protocol PassSubTask {
    func passData(_ title:String, tag:Int)
}
var objPassSubTask:PassSubTask?
class AddSubTaskTVC: UITableViewCell {
    @IBOutlet weak var txtFldSubTask: ACFloatingTextfield!
    @IBOutlet weak var btnDelete: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        txtFldSubTask.delegate = self
        // Initialization code
    }
}
extension AddSubTaskTVC: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        objPassSubTask?.passData(textField.text ?? "", tag: textField.tag)
        return true
    }
}
