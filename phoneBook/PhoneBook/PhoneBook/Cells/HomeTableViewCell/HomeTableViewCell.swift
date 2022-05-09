import UIKit
protocol StarCellProtocol {
    func starBtnTapped(indexPath:IndexPath)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactAge: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    var starCellProtocol:StarCellProtocol!
    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(name:String,age:String,number:String){
        contactName.text = name
        contactAge.text = age
        contactNumber.text = number
    }
    @IBAction func starBtnTapped(_ sender: Any) {
        starCellProtocol.starBtnTapped(indexPath: indexPath)
    }
    
}
