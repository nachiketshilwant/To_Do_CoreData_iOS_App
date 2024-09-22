//
//  ViewController.swift
//  coreDataToDoList
//
//  Created by Nachiket Shilwant on 28/08/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var list: [ToDoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(list.count)
        fetchList()
        let lbl = UILabel()
            setupUI()
            fetchList()
        updatePlaceholderVisibility()
    }
    
    
    func setupUI() {
        view.addSubview(heading)
        heading.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableViewClosure)
        tableViewClosure.delegate = self
        tableViewClosure.dataSource = self
        tableViewClosure.register(TableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        tableViewClosure.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addBtn)
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heading.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heading.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            tableViewClosure.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 30),
            tableViewClosure.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableViewClosure.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableViewClosure.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addBtn.topAnchor.constraint(equalTo: tableViewClosure.bottomAnchor, constant: -80),
            addBtn.widthAnchor.constraint(equalToConstant: 50),
            addBtn.heightAnchor.constraint(equalToConstant: 50),
            addBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)

        ])
    }
    
    let heading: UILabel = {
        let headLabel = UILabel()
        headLabel.text = "To-Do List"
        headLabel.font = UIFont(name: "Avenir-Black", size: 30)
        return headLabel
    }()
    
    let tableViewClosure: UITableView = {
        let tblView = UITableView()
        return tblView
    }()
    
    let addBtn: UIButton = {
        let addBttn = UIButton()
        addBttn.setImage(UIImage(systemName: "plus"), for: .normal)
        addBttn.tintColor = .white
        addBttn.backgroundColor = .systemBlue
        addBttn.layer.cornerRadius = 25
        addBttn.addTarget(self, action: #selector(addtaskAction), for: .touchUpInside)
        return addBttn
    }()
    
    let placeholderLabel: UILabel = {
            let label = UILabel()
            label.text = "Add task in to-do list"
            label.textColor = .gray
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
    
    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        let todo = list[indexPath.row]
        cell.todoLabel?.text = todo.toDo
        cell.todoLabel?.textColor = .black
        cell.todoLabel?.numberOfLines = 0
        
        cell.deleteBtn?.tag = indexPath.row
        cell.deleteBtn?.addTarget(self, action: #selector(deleteTask(_:)), for: .touchUpInside)
        
        cell.editBtn?.tag = indexPath.row
        cell.editBtn?.addTarget(self, action: #selector(editTask(_:)), for: .touchUpInside)
        return cell
    }
    
    // Action Methods
    @objc func editTask(_ sender: UIButton) {
        let index = sender.tag
        let taskToEdit = list[index]
            
        let alertController = UIAlertController(title: "Add To-Do Task", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = taskToEdit.toDo
        }
        
        let submitAction = UIAlertAction(title: "Edit Task", style: .default) { [weak self] _ in
            guard let task = alertController.textFields?.first?.text, !task.isEmpty else {
                return
            }
            self?.updatetask(task: task, index: index)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func deleteTask(_ sender: UIButton) {
        let index = sender.tag
        let taskToDelete = list[index]
        let alertController = UIAlertController(title: "Delete task named: \(taskToDelete.toDo ?? "Unknown")", message: "Deleting the selected task", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteToDoList(index: index)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func addtaskAction() {
        let alertController = UIAlertController(title: "Add To-Do Task", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Write task here ...."
        }
        
        let submitAction = UIAlertAction(title: "Add To-Do", style: .default) { [weak self] _ in
            guard let task = alertController.textFields?.first?.text, !task.isEmpty else {
                return
            }
            self?.addToDoList(task: task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Core Data Operations
    func fetchList() {
        do {
            list = try context.fetch(ToDoList.fetchRequest())
        } catch {
            print("Failed to fetch list: \(error)")
        }
        DispatchQueue.main.async {
            self.tableViewClosure.reloadData()
        }
        updatePlaceholderVisibility()
    }
    
    func updatetask(task: String, index:Int){
        let listToEdit = list[index]
        listToEdit.toDo = task
        
        do {
            try context.save()
        } catch {
            print("Failed to save new task: \(error)")
        }
        
        fetchList()
    }
    
    func addToDoList(task: String) {
        let newList = ToDoList(context: context)
        newList.toDo = task
        newList.createdAt = Date()

        do {
            try context.save()

        } catch {
            print("Failed to save new task: \(error)")
        }
        
        fetchList()
    }
    
    func deleteToDoList(index: Int) {
        let listToremove = list[index]
        context.delete(listToremove)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete task: \(error)")
        }
        
        fetchList()
    }
    
    func updatePlaceholderVisibility(){
        placeholderLabel.isHidden = !list.isEmpty
    }
}

