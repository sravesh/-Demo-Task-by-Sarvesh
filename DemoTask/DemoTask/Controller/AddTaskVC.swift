//
//  AddTaskVC.swift
//  Demo_App
//
//  Created by Sarvesh Gundi on 11/04/21.
//

import UIKit

class AddTaskVC: UIViewController {

    @IBOutlet weak var txt_Title: TextFieldCard!
    @IBOutlet weak var txt_Desc: TextViewCard!
    
    @IBOutlet weak var btn_Submit: ButtonCard!
    
    var isUpdate:Bool? = false
    private let manager: TaskManager = TaskManager()
    var selectedTask: Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = isUpdate! ? "Update Task" : "Add Task"
        btn_Submit.setTitle(isUpdate! ? "Update" : "Submit", for: .normal)
        if isUpdate! {
            txt_Title.text = selectedTask?.taskName
            txt_Desc.text = selectedTask?.taskDescription
        }
    }
    @IBAction func didTapCancel
    (_ sender: ButtonCard) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSubmit(_ sender: ButtonCard) {
        
        if isUpdate! {
            let request = Task(id: selectedTask!.id, taskName: txt_Title.text!, taskDescription: txt_Desc.text!, taskDate: Date())
            let validation = TaskValidation().validate(request: request)
            if !validation.success {
                self.present("".alert(validation.errorMessage!, "", "OK", { (action) in
                    
                }), animated: true, completion: nil)
            }else{
                if manager.updateEmployee(task: request) {
                    self.present("".alert("Record Updated", "", "OK", { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }), animated: true, completion: nil)
                }else{
                    self.present("".alert("Alert", "Something went wrong, please try again later", "OK", { (action) in
                    }), animated: true, completion: nil)
                }
            }
        }else{
            let request = Task(id: UUID(), taskName: txt_Title.text!, taskDescription: txt_Desc.text!, taskDate: Date())
            let validation = TaskValidation().validate(request: request)
            if !validation.success {
                self.present("".alert(validation.errorMessage!, "", "OK", { (action) in
                    self.txt_Title.resignFirstResponder()
                }), animated: true, completion: nil)
            }else{
                manager.createTask(task: request)
                self.navigationController?.popViewController(animated: true)
            }
        }
    
    }
    
}

struct ValidationResult{
    let success: Bool
    let errorMessage: String?
}

struct TaskValidation {
    
    func validate(request: Task) -> ValidationResult {
        if request.taskName.isEmpty {
            return ValidationResult(success: false, errorMessage: "Please enter task title")
        }else if request.taskDescription.isEmpty {
            return ValidationResult(success: false, errorMessage: "Please enter task description")
        }
        return ValidationResult(success: true, errorMessage: nil)
    }
    
}
