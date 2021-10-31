/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FSCalendar

class AddTaskVC: UIViewController,PassSubTask {
    //MARK:- Outlets
    @IBOutlet weak var txtFldAddTaskTitle: ACFloatingTextfield!
    @IBOutlet weak var txtFldTime: ACFloatingTextfield!
    @IBOutlet weak var tblVwAddTask: UITableView!
    @IBOutlet weak var lblTaskHeader: UILabel!
    @IBOutlet weak var cnstHeightTblVw: NSLayoutConstraint!
    @IBOutlet weak var taskCalender: FSCalendar!
    @IBOutlet weak var vwScrool: UIScrollView!
    //MARK:- Varaible
    var objAddTaskVM = AddTaskVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTaskHeader.text = Date().stringFromFormat("EEEE, dd MMM")
        objPassSubTask = self
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldAddTaskTitle,txtFldTime])
        addEmptyData()
        openPicker()
    }
    override func viewWillAppear(_ animated: Bool) {
        taskCalender.scope = .week
    }
    func passData(_ title:String, tag:Int) {
        self.objAddTaskVM.arrTaskSubTitle.replaceObject(at: tag, with: title)
        tblVwAddTask.reloadData()
        self.cnstHeightTblVw.constant = CGFloat(self.objAddTaskVM.arrTaskSubTitle.count * 80)
    }
    func addEmptyData(){
        self.objAddTaskVM.arrTaskSubTitle.add("")
        tblVwAddTask.reloadData()
        self.cnstHeightTblVw.constant = 80
        
    }
    func openPicker(){
        objAddTaskVM.timePickerTask.datePickerMode = .time
        if #available(iOS 14,  *){
            objAddTaskVM.timePickerTask.preferredDatePickerStyle = .wheels
            objAddTaskVM.timePickerTask.sizeToFit()
        }
        objAddTaskVM.timePickerTask.locale = NSLocale(localeIdentifier: "en_US") as Locale
        txtFldTime.inputView = objAddTaskVM.timePickerTask
        objAddTaskVM.timePickerTask.addTarget(self, action: #selector(pickDate), for: .valueChanged)
    }
    
    @objc func pickDate(){
        let format =  DateFormatter()
        format.dateFormat = "hh:mm a"
        txtFldTime.text = format.string(from: objAddTaskVM.timePickerTask.date)
    }
    //MARK:- IBaction
    @IBAction func actionSave(_ sender: UIButton){
        self.view.endEditing(true)
        let req  = AddTaskRequest.init(date:objAddTaskVM.date , title: txtFldAddTaskTitle.text, time: txtFldTime.text, arrSubTitle: self.objAddTaskVM.arrTaskSubTitle)
        if self.objAddTaskVM.validData(req) {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable() {
                self.objAddTaskVM.createTask(req) {
                    Proxy.shared.hideActivityIndicator()
                    self.popToBack()
                    Proxy.shared.displayStatusCodeAlert(AlertMessage.taskAddSuccess)
                }
            }
        }
    }
    @IBAction func actionBack(_ sender: UIButton){
        popToBack()
    }
    @IBAction func actionAddSubTask(_ sender: UIButton) {
        self.objAddTaskVM.arrTaskSubTitle.add("")
        tblVwAddTask.reloadData()
        self.cnstHeightTblVw.constant = CGFloat(self.objAddTaskVM.arrTaskSubTitle.count * 80)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) { [self] in
            let bottomOffset = CGPoint(x: 0, y: vwScrool.contentSize.height - vwScrool.bounds.height + vwScrool.contentInset.bottom)
            vwScrool.setContentOffset(bottomOffset, animated: true)
        }
    }
}
