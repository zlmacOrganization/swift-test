//
//  ContactsViewController.swift
//  SwiftTest
//
//  Created by bfgjs on 2019/2/28.
//  Copyright © 2019 ZhangLiang. All rights reserved.
//

import UIKit
import SnapKit
import Contacts
import ContactsUI

class Person {
    var name: String = ""
    var phoneNum: String = ""
}

class ContactsViewController: BaseViewController {

    private let cellIdentifier = "contactCell"
    private var dataArray = [Person]()
    
    private var zlFilterView: ZLFilterView!
    
    private lazy var tableView: UITableView = {
        let myTableView = UITableView()
        myTableView.delegate = self
        myTableView.dataSource = self
//        myTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        
        myTableView.rowHeight = 60
        myTableView.tableFooterView = UIView()
        return myTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let filterView = UIView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 40))
        view.addSubview(filterView)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(filterView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        
        zlFilterView = ZLFilterView(baseView: filterView, selectBlock: { (dict, value) in
            
        })

        getContactsData()
    }

    private func getContactsData() {
        let contactStore = CNContactStore()
        //        contactStore.requestAccess(for: CNEntityType.contacts) { (isAccess, error) in
        //            if isAccess {
        //
        //            }else {
        //
        //            }
        //        }
        
        //        let request = CNContactFetchRequest(keysToFetch: CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName) as! [CNKeyDescriptor])
        //        try contactStore.enumerateContacts(with: request) { (contact, stop) in
        //
        //        }
        
        let keys = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        DispatchQueue.global().async {
            do {
                try contactStore.enumerateContacts(with: request) { contact, stop in
                    for phone in contact.phoneNumbers {
                        
                        let person = Person()
                        person.name = "\(contact.familyName)\(contact.givenName)"
                        
                        var phoneStr = phone.value.stringValue
                        phoneStr = phoneStr.replacingOccurrences(of: " ", with: "")
                        phoneStr = phoneStr.replacingOccurrences(of: "-", with: "")
                        phoneStr = phoneStr.replacingOccurrences(of: " ", with: "")
                        person.phoneNum = phoneStr
                        
                        self.dataArray.append(person)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch let enumerateError {
                print(enumerateError.localizedDescription)
            }
        }
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        let person = dataArray[indexPath.row]
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = person.phoneNum
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contactVC = CNContactPickerViewController()
        contactVC.modalPresentationStyle = .fullScreen
        present(contactVC, animated: true, completion: nil)
    }
}
