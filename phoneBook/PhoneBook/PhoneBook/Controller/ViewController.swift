

import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var allowContactView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var contactsArray = [Dictionary<String, [ContactsModel]>.Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FreeAdsHeaderview", bundle: nil), forHeaderFooterViewReuseIdentifier: "FreeAdsHeaderview")
        
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContacts()
    }
    
    func getContacts(){
        ContactHelper.shared.checkIfAccessGranted {[self] (grant) in
            
            if grant == true{
                contactsArray = ContactHelper.shared.generateModelArray()
                tableView.reloadData()
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

        cell.setData(
            name: "\(contact.contactName ?? "") \(contact.contactSurName ?? "")",
            age: contact.dateOfBirth == nil ? "" : "\(getAge(birthday: contact.dateOfBirth!)) year",
            number: contact.phoneNumber?[0] ?? "")
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
    
    
}

