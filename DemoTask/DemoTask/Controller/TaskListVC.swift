//
//  TaskListVC.swift
//  Demo_App
//
//  Created by Sarvesh Gundi on 11/04/21.
//

import UIKit

class TaskListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_AddTask: UIBarButtonItem!
    
    var taskArray = [Task]()
    let manager: TaskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TaskListCell", bundle: nil), forCellReuseIdentifier: "TaskListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTaskList()
    }

    func getTaskList() {
        taskArray.removeAll()
        taskArray = manager.fetchTask()!
        if taskArray.count != 0 {
            tableView.reloadData()
        }
    }
    
    @IBAction func didTapAddNewTask(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        vc.isUpdate = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TaskListVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell") as! TaskListCell
        if taskArray.count > 0 {
            cell.lbl_Title.text = taskArray[indexPath.row].taskName
            cell.lbl_Desc.text = taskArray[indexPath.row].taskDescription
            cell.lbl_CreatedDate.text = "Date:\(getDate(date: taskArray[indexPath.row].taskDate))"
            cell.lbl_CreatedTime.text = "Time:\(getTime(date: taskArray[indexPath.row].taskDate))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
           
            self.present("".alert("Do you want to update this task?", "", "OK", { [self] (action) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
                vc.isUpdate = true
                vc.selectedTask = taskArray[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }), animated: true, completion: nil)
            success(true)
        })
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
           
            self.present("".alert("Do you want to delete this task?", "", "OK", { [self] (action) in
                self.deleteTask(task: taskArray[indexPath.row])
            }), animated: true, completion: nil)
            success(true)
        })
        deleteAction.image = UIImage(named: "edit")
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
   
    func getDate(date:Date)->String {
        let date = date
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let dateString = df.string(from: date)
        return dateString
    }
    
    func getTime(date:Date)-> String {
        let date = date
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        let dateString = df.string(from: date)
        return dateString
    }
    
    func deleteTask(task:Task) {
        if manager.deleteTask(id: task.id) {
            self.present("".alert("Record Deleted", "", "OK", { (action) in
                self.getTaskList()
            }), animated: true, completion: nil)
        }else{
            self.present("".alert("Alert", "Something went wrong, please try again later", "OK", { (action) in
            }), animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension String {
    func alert(_ title:String,_ message:String,_ btnTitle:String,_ actnBlock:@escaping (UIAlertAction) ->()) -> UIAlertController {
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: actnBlock))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
}
