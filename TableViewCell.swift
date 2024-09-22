//
//  TableViewCell.swift
//  coreDataToDoList
//
//  Created by Nachiket Shilwant on 28/08/24.
//

import UIKit

class TableViewCell: UITableViewCell {
    var todoLabel : UILabel?
    var editBtn : UIButton?
    var deleteBtn : UIButton?

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.isUserInteractionEnabled = true

        todoLabel = UILabel()
        addSubview(todoLabel!)
        todoLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        editBtn = UIButton()
        editBtn!.setImage(UIImage(systemName: "pencil"), for: .normal)
        addSubview(editBtn!)
        editBtn!.translatesAutoresizingMaskIntoConstraints = false
        
        deleteBtn = UIButton()
        deleteBtn!.setImage(UIImage(systemName: "trash"), for: .normal)
        addSubview(deleteBtn!)
        deleteBtn!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todoLabel!.topAnchor.constraint(equalTo: topAnchor),
            todoLabel!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            todoLabel!.widthAnchor.constraint(equalToConstant: 300),
            todoLabel!.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            editBtn!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            editBtn!.leadingAnchor.constraint(equalTo: todoLabel!.trailingAnchor, constant: 10),
            editBtn!.widthAnchor.constraint(equalToConstant: 30),
            editBtn!.heightAnchor.constraint(equalToConstant: 30),

            deleteBtn!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteBtn!.leadingAnchor.constraint(equalTo: editBtn!.trailingAnchor, constant: 10),
            deleteBtn!.widthAnchor.constraint(equalToConstant: 30),
            deleteBtn!.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
