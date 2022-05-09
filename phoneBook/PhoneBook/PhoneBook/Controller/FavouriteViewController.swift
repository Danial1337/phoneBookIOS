
import UIKit

class FavouriteViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var favouritesContact = [ContactsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Favourites"
        
        tableview.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    
    func getAge(birthday:Date)->Int{
        let now = Date()
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return age
    }

    

}


extension FavouriteViewController:UITableViewDelegate,UITableViewDataSource{
    
    //cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesContact.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.setData(
            name: "\(favouritesContact[indexPath.row].contactName ?? "") \(favouritesContact[indexPath.row].contactSurName ?? "")",
            age: favouritesContact[indexPath.row].dateOfBirth == nil ? "" : "\(getAge(birthday: favouritesContact[indexPath.row].dateOfBirth!)) year",
            number: favouritesContact[indexPath.row].phoneNumber?[0] ?? "")
        
        cell.startBtn.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    
    
}
