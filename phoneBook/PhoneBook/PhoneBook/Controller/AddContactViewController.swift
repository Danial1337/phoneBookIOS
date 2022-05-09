
import UIKit

class AddContactViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    
    var selectedBithDate:Date!
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add New Contact"
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        birthdayTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setDatePicker()
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setDatePicker(){
        
        let date = selectedBithDate == nil ? Date() : selectedBithDate!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthdayTextField.text = formatter.string(from: date)
        
    }
    
    @objc func imageTapped(){
        imagePicker.photoGalleryAsscessRequest()
    }
    
    @IBAction func saveContactTapped(_ sender: Any) {
        
        
        checkUserInputs {
            
            ContactHelper.shared.saveContact(profileImg: self.profileImageView.image!,
                                             name: self.nameTextField.text ?? "",
                                             email: self.emailTextField.text ?? "",
                                             number: self.numberTextField.text ?? "",
                                             birthdayDate: self.selectedBithDate) {
                
                self.showToast(message: "contact saved", font: .systemFont(ofSize: 12.0))
                self.navigationController?.popViewController(animated: true)
            } failure: {
                self.showToast(message: "cannot save contact", font: .systemFont(ofSize: 12.0))
            }
            
        }
    }
    
    
    
    
    func checkUserInputs(completion:@escaping()->Void){
        if profileImageView.image == #imageLiteral(resourceName: "user"){
            self.showToast(message: "Please select image", font: .systemFont(ofSize: 12.0))
            return
        }
        
        if nameTextField.text == "" || emailTextField.text == "" || numberTextField.text == ""{
            self.showToast(message: "Fields cannot be", font: .systemFont(ofSize: 12.0))
            return
        }
        
        if selectedBithDate == nil{
            self.showToast(message: "Please select DOB", font: .systemFont(ofSize: 12.0))
            return
        }
        
        if isValidEmail(emailTextField.text ?? "") == false{
            self.showToast(message: "Invalid Email", font: .systemFont(ofSize: 12.0))
            return
        }
        
        if  numberTextField.text!.isPhoneNumber == false{
            self.showToast(message: "Number is badly formatted", font: .systemFont(ofSize: 12.0))
            return
        }
        
        completion()
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validateNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }
    
}


//MARK: -   IMAGE PICKER

extension AddContactViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        profileImageView.image = image
        imagePicker.dismiss()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}



//MARK: -   TEXTFIELD DELGETES

extension AddContactViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == birthdayTextField{
            openDatePicker()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField{
            numberTextField.becomeFirstResponder()
        }else if textField == numberTextField{
            birthdayTextField.becomeFirstResponder()
        }
        return true
    }
}


//MARK: -   DATE PICKER

extension AddContactViewController{
    func openDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        birthdayTextField.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClicked))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnClicked))
        toolBar.setItems([cancelBtn,doneBtn], animated: false)
        birthdayTextField.inputAccessoryView = toolBar
        
    }
    
    
    @objc func cancelBtnClicked(){
        birthdayTextField.resignFirstResponder()
    }
    @objc func doneBtnClicked(){
        if let datePicker = birthdayTextField.inputView as? UIDatePicker{
            selectedBithDate = datePicker.date
            birthdayTextField.resignFirstResponder()
            setDatePicker()
        }
    }
}
