

import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var allowContactView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var contactsArray = [Dictionary<String, [ContactsModel]>.Element]()
    var favouritesContact = [ContactsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Phonebook"
        
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTapped))
        
        
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(favouriteTapped), for: .touchUpInside)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = #imageLiteral(resourceName: "star")
        imageView.tintColor = UIColor.orange
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        button.frame = buttonView.frame
        buttonView.addSubview(button)
        buttonView.addSubview(imageView)
        let barButton = UIBarButtonItem.init(customView: buttonView)
        self.navigationItem.leftBarButtonItem = barButton
        
        
    }
    
    @objc func favouriteTapped(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FavouriteViewController") as! FavouriteViewController
        vc.favouritesContact = self.favouritesContact
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func addAddressTapped(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddContactViewController") as! AddContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContacts()
    }
    
    func getContacts(){
        ContactHelper.shared.checkIfAccessGranted {[self] (grant) in
            
            if grant == true{
                contactsArray = ContactHelper.shared.generateModelArray()
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }else{
                allowContactView.isHidden = false
            }
        } failure: { (error) in
            print("error ",error)
        }
    }
    
    
    @IBAction func openSetting(_ sender:UIButton){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    func getAge(birthday:Date)->Int{
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return age
    }
    
    
}

//MARK: -               TABLE VIEW PROTOCOL

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    //header
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactsArray[section].key
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    //cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let contact = contactsArray[indexPath.section].value[indexPath.row]
        
        cell.indexPath = indexPath
        cell.starCellProtocol = self
        cell.setData(
            name: "\(contact.contactName ?? "") \(contact.contactSurName ?? "")",
            age: contact.dateOfBirth == nil ? "" : "\(getAge(birthday: contact.dateOfBirth!)) year",
            number: contact.phoneNumber?[0] ?? "")
        
        let found = favouritesContact.contains(where: {$0.contactName == contact.contactName})
        if found == true{
            cell.startBtn.tintColor = UIColor.orange
        }else{
            cell.startBtn.tintColor = UIColor.lightGray
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ContactDetailViewController") as! ContactDetailViewController
        vc.selectedContact = contactsArray[indexPath.section].value[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


//MARK: -               STAR PROTOCOL

extension HomeViewController:StarCellProtocol{
    func starBtnTapped(indexPath: IndexPath) {
        
        let item = contactsArray[indexPath.section].value[indexPath.row]
        let index = favouritesContact.firstIndex(where: {$0.contactName == item.contactName})
        
        if index == nil{
            
            // add item in the favourite
            favouritesContact.append(item)
        }else{
            
            //remove item from favourite
            favouritesContact.remove(at: index!)
        }
        
        tableView.reloadData()
        
        
        
        
    }
}
