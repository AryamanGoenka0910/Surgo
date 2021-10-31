/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

class EditTaskVC: UIViewController,PassSubTask {
    //MARK:- Outlets
    @IBOutlet weak var txtFldAddTaskTitle: ACFloatingTextfield!
    @IBOutlet weak var txtFldTime: ACFloatingTextfield!
    @IBOutlet weak var lblTaskHeader: UILabel!
    @IBOutlet weak var tblVwEditTask: UITableView!
    @IBOutlet weak var cnstHeightTblVw: NSLayoutConstraint!
    //MARK:- Varaibles
   var objEditTaskVM = EditTaskVM()
    var objAddTaskVM = AddTaskVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title != ""{
            let dateString = title
            lblTaskHeader.text = Proxy.shared.changeDateFormat(dateString!, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "MMM d")
            
        }
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldAddTaskTitle,txtFldTime])
        txtFldAddTaskTitle.text  = objEditTaskVM.objTaskListModel.title
        txtFldTime.text = Proxy.shared.dateConvertDay(date: objEditTaskVM.objTaskListModel.taskTime ?? "", dateFormat:"HH:mm:ss" , getFormat: "hh:mm a")
        //txtFldTime.text  = objEditTaskVM.objTaskListModel.taskTime
        for index in objEditTaskVM.objTaskListModel.arrSubtitles! {
            objEditTaskVM.arrTaskSubTitle.add(index)
        }
        objPassSubTask = self
        tblVwEditTask.reloadData()
        openPicker()
    }
    //MARK:- IBaction
    @IBAction func actionSave(_ sender: UIButton){
        self.view.endEditing(true)
        let req  = AddTaskRequest.init(title: txtFldAddTaskTitle.text, time: txtFldTime.text, arrSubTitle: self.objEditTaskVM.arrTaskSubTitle)
        if self.objEditTaskVM.validData(req) {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable() {
                self.objEditTaskVM.updateTask(req) {
                    Proxy.shared.hideActivityIndicator()
                    self.popToBack()
                    Proxy.shared.displayStatusCodeAlert(AlertMessage.taskAddSuccess)
                }
            }
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
    }
    @IBAction func actionComplete(_ sender: UIButton) {
    }
    @IBAction func actionAddNewTaskTitle(_ sender: UIButton) {
        self.objEditTaskVM.arrTaskSubTitle.add("")
        tblVwEditTask.reloadData()
        self.cnstHeightTblVw.constant = CGFloat(self.objEditTaskVM.arrTaskSubTitle.count * 80)
    }
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    @objc func pickDate(pick: UIDatePicker){
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        pick.maximumDate = Date()
        txtFldTime.text = format.string(from: pick.date)
        
    }
    
    func openPicker(){
        objEditTaskVM.timePickerTask.datePickerMode = .time
        if #available(iOS 14,  *){
            objEditTaskVM.timePickerTask.preferredDatePickerStyle = .wheels
            objEditTaskVM.timePickerTask.sizeToFit()
        }
        objEditTaskVM.timePickerTask.locale = NSLocale(localeIdentifier: "en_US") as Locale
        txtFldTime.inputView = objEditTaskVM.timePickerTask
        objEditTaskVM.timePickerTask.addTarget(self, action: #selector(pickDate), for: .valueChanged)
    }
    func passData(_ title:String, tag:Int) {
        self.objEditTaskVM.arrTaskSubTitle.replaceObject(at: tag, with: title)
        tblVwEditTask.reloadData()
        self.cnstHeightTblVw.constant = CGFloat(self.objEditTaskVM.arrTaskSubTitle.count * 80)
    }
}

