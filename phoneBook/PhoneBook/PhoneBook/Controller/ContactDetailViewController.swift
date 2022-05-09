
import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedContact:ContactsModel!
    
    let headers = ["Name","Email","Address","Birthday","Age","Websites"]
    let cellReuseIdentifier = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Contact Detail"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        
    }
    
    func getAge(birthday:Date)->Int{
        let now = Date()
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return age
    }
    func dateIntoString(date:Date?)->String{
        var stringDate = ""
        if let date = date{
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            stringDate = df.string(from: date)
        }
        return stringDate
    }

}

extension ContactDetailViewController:UITableViewDelegate,UITableViewDataSource{

    //header
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && selectedContact.contactName != nil{
            return 40
        }else if section == 1 && selectedContact.contactEmails!.count != 0{
            return 40
        }else if section == 2  && selectedContact.address!.count != 0{
            return 40
        }else if section == 3 && selectedContact.dateOfBirth != nil{
            return 40
        }else if section == 4 && selectedContact.dateOfBirth != nil{
            return 40
        }else if section == 5 && selectedContact.contactURLs!.count != 0{
            return 40
        }else{
            return 0
        }
    }

    //cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return selectedContact.contactEmails!.count
        }else if section == 2{
            return selectedContact.address!.count
        }else if section == 3{
            return 1
        }else if section == 4{
            return 1
        }else{
            return selectedContact.contactURLs!.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        
        if indexPath.section == 0{
            cell.textLabel?.text = "\(selectedContact.contactName ?? "") \(selectedContact.contactSurName ?? "")"
        }
        
        else if indexPath.section == 1{
            cell.textLabel?.text = selectedContact.contactEmails?[indexPath.row] ?? ""
        }
        
        else if indexPath.section == 2{
            cell.textLabel?.text = selectedContact.address?[indexPath.row] ?? ""
        }
        
        else if indexPath.section == 3{
            cell.textLabel?.text =  dateIntoString(date: selectedContact.dateOfBirth)
        }
        
        else if indexPath.section == 4{
            cell.textLabel?.text = selectedContact.dateOfBirth == nil ? "" : "\(getAge(birthday: selectedContact.dateOfBirth!)) year"
        }
        
        else{
            cell.textLabel?.text = selectedContact.contactURLs?[indexPath.row] ?? ""
        }
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ShowLocationViewController") as! ShowLocationViewController
            vc.address = selectedContact.address![indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

