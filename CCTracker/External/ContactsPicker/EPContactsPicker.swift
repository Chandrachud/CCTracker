//
//  EPContactsPicker.swift
//  EPContacts
//
//  Created by Prabaharan Elangovan on 12/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit
import Contacts


@objc protocol EPPickerDelegate{
    
    @objc @available(iOS 9.0, *)
optional    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    @objc @available(iOS 9.0, *)
optional    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    @objc @available(iOS 9.0, *)
optional    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact)
    @objc @available(iOS 9.0, *)
optional    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts : [EPContact])

}
@available(iOS 9.0, *)
typealias ContactsHandler = (_ contacts : [CNContact] , _ error : NSError?)  -> Void

enum SubtitleCellValue{
    case Phonenumer
    case Email
    case Birthday
    case Organization
    
}

@available(iOS 9.0, *)
class EPContactsPicker: UITableViewController {
    
// MARK: - Properties
    var contactDelegate : EPPickerDelegate?
    var contactsStore : CNContactStore?
    var arrContacts = [CNContact]()
    var contactSearchBar = UISearchBar()
    var orderedContacts = [String:[CNContact]]() //Contacts ordered in dicitonary alphabetically
    
    var sortedContactKeys = [String]()
    @objc var multiSelectEnabled : Bool = false //Default is single selection contact
    var selectedContacts = [EPContact]()
    
    var subtitleCellValue = SubtitleCellValue.Phonenumer
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = EPGlobalConstants.Strings.contactsTitle
        let nib = UINib(nibName: "EPContactCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        inititlizeBarButtons()
        initializeSearchBar()
        reloadContacts()
    }
    
    func initializeSearchBar(){

        contactSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        contactSearchBar.sizeToFit()
        contactSearchBar.setShowsCancelButton(false, animated: true)
        
        self.tableView.tableHeaderView? = contactSearchBar
    }
    
    func inititlizeBarButtons(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(EPContactsPicker.onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        if multiSelectEnabled {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(EPContactsPicker.onTouchDoneButton))
            self.navigationItem.rightBarButtonItem = doneButton
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    convenience init(delegate: EPPickerDelegate? )  {
        self.init(delegate: delegate , multiSelection: false)
    }
    
    @objc convenience init(delegate: EPPickerDelegate? , multiSelection : Bool ){
        self.init(style: .plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
    }

    convenience init(delegate: EPPickerDelegate? , multiSelection : Bool , subtitleCellType : SubtitleCellValue){
        self.init(style: .plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
        subtitleCellValue = subtitleCellType
    }
    
    
// MARK: - Contact Operations
  
  func reloadContacts(){
    getContacts(completion: { (contacts, error) in
        if (error == nil)
        {
            self.arrContacts = contacts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    })
  }
  
  func getContacts (completion : @escaping ContactsHandler){
    if contactsStore == nil {
        //ContactStore is control for accessing the Contacts
        contactsStore = CNContactStore()
    }
        let error = NSError(domain: "EPContactPickerErrorDomain", code: 1, userInfo: [ NSLocalizedDescriptionKey: "No Contacts Access"])
        
    switch CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        {
    case CNAuthorizationStatus.denied,CNAuthorizationStatus.restricted :
                //User has denied the current app to access the contacts.
                
        let productName = Bundle.main.infoDictionary!["CFBundleName"]!
                
        let alert = UIAlertController(title: "Unable to access contacts", message: "\(productName) does not have access to contacts. Kindly enable it in privacy settings ", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {  action in
                    self.contactDelegate?.epContactPicker!(self, didContactFetchFailed: error)
            completion([],error)
            self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
                
            break
            
    case CNAuthorizationStatus.notDetermined :
                //This case means the user is prompted for the first time for allowing contacts
        contactsStore?.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) -> Void in
                    //At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                    if  (!granted ){
                        DispatchQueue.main.async {
                          _ =  (contacts: [],error:error!)
                        }
                    }
                    else{
                        self.getContacts(completion: completion)
                    }
                })
            break
            
        case  CNAuthorizationStatus.authorized :
                //Authorization granted by user for this app.
                var contactsArray = [CNContact]()
                
                let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys() as [CNKeyDescriptor])
                
                do {
                    try contactsStore?.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                        //Ordering contacts based on alphabets in firstname
                        contactsArray.append(contact)
                        var key : String = "#"
                        //If ordering has to be happening via family name change it here.
                        if let firstLetter = contact.givenName[0..<1], ( firstLetter.containsAlphabets()) {
                            key = firstLetter.uppercased()
                        }
                        var contacts = [CNContact]()
                        
                        if let segregatedContact = self.orderedContacts[key]
                        {
                            contacts = segregatedContact

                        }
                        contacts.append(contact)
                        self.orderedContacts[key] = contacts

                    })
                    self.sortedContactKeys = Array(self.orderedContacts.keys).sorted(by: <)
                    if self.sortedContactKeys.first == "#"
                    {
                        self.sortedContactKeys.removeFirst()
                        self.sortedContactKeys.append("#")
                    }
                    completion(contactsArray,nil)
                }
                //Catching exception as enumerateContactsWithFetchRequest can throw errors
                catch let error as NSError {
                    print(error.localizedDescription)
                }
            break
            
        }
  }
    
    
    func allowedContactKeys() -> [String]{
        //We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
        return [CNContactNamePrefixKey,
            CNContactGivenNameKey,
          //  CNContactMiddleNameKey,
            CNContactFamilyNameKey,
          //  CNContactNameSuffixKey,
          //  CNContactNicknameKey,
          //  CNContactPhoneticGivenNameKey,
          //  CNContactPhoneticMiddleNameKey,
          //  CNContactPhoneticFamilyNameKey,
            CNContactOrganizationNameKey,
          //  CNContactDepartmentNameKey,
          //  CNContactJobTitleKey,
            CNContactBirthdayKey,
          //  CNContactNonGregorianBirthdayKey,
          //  CNContactNoteKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey,
            CNContactImageDataAvailableKey,
          //  CNContactTypeKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
          //  CNContactPostalAddressesKey,
          //  CNContactDatesKey,
          //  CNContactUrlAddressesKey,
          //  CNContactRelationsKey,
          //  CNContactSocialProfilesKey,
          //  CNContactInstantMessageAddressesKey
        ]
    }
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedContactKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contactsForSection = orderedContacts[sortedContactKeys[section]]
        {
            return contactsForSection.count
        }
        return 0
    }

    // MARK: - Table view delegates

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! EPContactCell
        cell.accessoryType = UITableViewCell.AccessoryType.none
        //Convert CNContact to EPContact
        if let contactsForSection = orderedContacts[sortedContactKeys[indexPath.section]]
        {
            let contact =  EPContact(contact: contactsForSection[indexPath.row])
            if multiSelectEnabled  {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
            
            cell.updateContactsinUI(contact: contact, indexPath: indexPath, subtitleType: subtitleCellValue)
            return cell
        }
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Convert CNContact to EPContact        
        if let contactsForSection = orderedContacts[sortedContactKeys[indexPath.section]]
        {
            let contact =  EPContact(contact: contactsForSection[indexPath.row])
            if multiSelectEnabled {
                let cell = tableView.cellForRow(at: indexPath as IndexPath)
                //Keeps track of enable=ing and disabling contacts
                if cell?.accessoryType == UITableViewCell.AccessoryType.checkmark
                {
                    cell?.accessoryType = UITableViewCell.AccessoryType.none
                    selectedContacts = selectedContacts.filter(){
                        return contact.contactId != $0.contactId
                    }
                }
                else{
                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    selectedContacts.append(contact)
                }
            }
            else{
                //Single selection code
                contactDelegate?.epContactPicker!(self, didSelectContact: contact)
                self.dismiss(animated: true, completion: nil)
            }
        }

    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        tableView.scrollToRow(at: NSIndexPath(row: 0, section: index) as IndexPath, at: UITableView.ScrollPosition.top , animated: false)
        
        return EPGlobalConstants.Arrays.alphabets.firstIndex(of: title) ?? 0
    }
    
      func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sortedContactKeys
    }

     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedContactKeys[section]
    }
    
//MARK: Button Actions
    @objc func onTouchCancelButton() {
        contactDelegate?.epContactPicker!(self, didCancel: NSError(domain: "EPContactPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func onTouchDoneButton() {
        contactDelegate?.epContactPicker!(self, didSelectMultipleContacts: selectedContacts)
        dismiss(animated: true, completion: nil)
    }
    
}
