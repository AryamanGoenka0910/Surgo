/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FSCalendar
class CalenderVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblVwUserTask: UITableView!
    @IBOutlet weak var taskCalender: FSCalendar!
    @IBOutlet weak var lblMonthYear: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    //MARK:- Variables
    var objCalenderVM = CalenderVM()
    var objAddTaskVM = AddTaskVM()
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVwUserTask.rowHeight = UITableView.automaticDimension
        tblVwUserTask.estimatedRowHeight = 38
        let currentPageDate = taskCalender.currentPage
        let currentYear = Calendar.current.component(.year, from: currentPageDate)
        let currentMonth = Calendar.current.component(.month, from: currentPageDate)
        let monthStr = Calendar.current.monthSymbols[currentMonth-1]
        lblMonthYear.text = "\(monthStr) \(currentYear)"
        lblDate.text = Date().stringFromFormat("EEEE, dd MMM")
    }
    override func viewWillAppear(_ animated: Bool) {
        let val = taskCalender.selectedDate
        objCalenderVM.arrTaskListModel = []
        Proxy.shared.showActivityIndicator()
        let format =  DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let todayDate = format.string(from: val ?? Date())
        if Proxy.shared.networkReachable() {
            objCalenderVM.getTask(todayDate) {
                Proxy.shared.hideActivityIndicator()
                self.tblVwUserTask.reloadData()
            }
        }
    }
    //MARK:- Actions
    @IBAction func actionAddPost(_ sender: Any) {
        moveToNext(AddTaskVC.className,titleStr: "\(objCalenderVM.selectedDate)")
    }
}
extension CalenderVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objCalenderVM.arrTaskListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTVC.className, for: indexPath) as! TaskListTVC
        let dict = objCalenderVM.arrTaskListModel[indexPath.row]
        cell.lblName.text = dict.title
        let timeVal = Proxy.shared.dateConvertDay(date: dict.taskTime ?? "", dateFormat:"HH:mm:ss" , getFormat: "hh:mm a")
        cell.lblDate.text = "\(dict.selectedDate!), \(timeVal)"
        if dict.state == TaskState.new.rawValue{
            cell.vwLine.backgroundColor = UIColor(named: "yellow-1")
        }else{
            cell.vwLine.backgroundColor = UIColor(named: "yellow")
        }
        let multiLineString = dict.arrSubtitles?.componentsJoined(by: "\n• ")
        cell.lblSubTask.text = "• \(multiLineString!)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
