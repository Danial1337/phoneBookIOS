
import UIKit
import Contacts
import CoreLocation

struct Section {
    let letter : String
    let contact : [ContactsModel]
}


class ContactHelper{
    static let shared = ContactHelper()
    
    
    func checkIfAccessGranted(completion:@escaping(Bool)->Void,failure:@escaping(Error)->Void){
        let contactStore = CNContactStore()
        contactStore.requestAccess(for: .contacts) { (granted, err) in
            if let error = err{
                failure(error)
            }

            completion(granted)
        }
    }
    
    func generateModelArray() -> [Dictionary<String, [ContactsModel]>.Element]{
        
        
        let contactStore = CNContactStore()
        
        var contactsData = [ContactsModel]()
        let key = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactPostalAddressesKey,
            CNContactUrlAddressesKey,
            CNContactBirthdayKey] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: key)
        try? contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
            let contactName = contact.givenName
            let surName = contact.familyName
            let contactNumber: [String] = contact.phoneNumbers.map{ $0.value.stringValue }
            let contactBirthday = contact.birthday?.date
            
            
            //address
            var contactAddress = [String]()
            if contact.postalAddresses.count != 0{
                for subContact in contact.postalAddresses{
                    if let addressString = (((subContact as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value")) as? CNPostalAddress {
                        let streetAddress = "\(addressString.street), \(addressString.city), \(addressString.state), \(addressString.postalCode), \(addressString.country)"
                        contactAddress.append(streetAddress)
                    }
                }
            }
            
            
            
            //email
            var contactEmails = [String]()
            if contact.emailAddresses.count != 0{
                for email in contact.emailAddresses{
                    contactEmails.append(email.value as String)
                }
            }
            
            
            //websites
            
            var contactURLs = [String]()
            if contact.urlAddresses.count != 0{
                for urlItem in contact.urlAddresses{
                    contactURLs.append(urlItem.value as String)
                }
            }
          
            
            
            var newContact = ContactsModel()
            newContact.contactName = contactName
            newContact.contactSurName = surName
            newContact.phoneNumber = contactNumber
            newContact.dateOfBirth = contactBirthday
            newContact.address = contactAddress
            newContact.contactEmails = contactEmails
            newContact.contactURLs = contactURLs
            contactsData.append(newContact)
            
        })
        
        //sort the contacts
        
        let groupedDictionary = Dictionary(grouping: contactsData, by: {String($0.contactSurName == "" ? $0.contactName!.capitalizingFirstLetter().prefix(1) :$0.contactSurName!.prefix(1) )})
        let sortedDictionary = groupedDictionary.sorted(by: { $0.0 < $1.0 })
        
        return sortedDictionary
    }
    
    
    func saveContact(profileImg:UIImage,name:String,email:String,number:String,birthdayDate:Date,success:@escaping()->Void,failure:@escaping()->Void){
        
        let newContact = CNMutableContact()
        
        //name
        newContact.givenName = name

        //email
        let workEmail = CNLabeledValue(label:CNLabelWork, value:email as NSString)
        newContact.emailAddresses = [workEmail]
        
        //number
        newContact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:number))]
        
        //birthday
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.month,.year], from: birthdayDate)
        
        var birthday = DateComponents()
        birthday.day = components.day
        birthday.month = components.month
        birthday.year = components.year
        newContact.birthday = birthday

        //image
        newContact.imageData = profileImg.pngData()
        
        //save contact
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier: nil)
        do{
            try store.execute(saveRequest)
            success()
        }catch{
            failure()
        }
        
        
    }
    
          
}
