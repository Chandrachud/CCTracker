
//
//  EPContact.swift
//  EPContacts
//
//  Created by Prabaharan Elangovan on 13/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit
import Contacts




class EPContact: NSObject {
    
    var firstName : NSString!
    var lastName : NSString!
    var company : NSString!
    var thumbnailProfileImage : UIImage?
    var profileImage : UIImage?
    var birthday : NSDate?
    var birthdayString : String?
    var contactId : String?
    var phoneNumbers = [(phoneNumber: String ,phoneLabel: String )]()
    var emails = [(email: String ,emailLabel: String )]()
    
    @available(iOS 9.0, *)
    init (contact: CNContact)
    {
        super.init()
        
        //VERY IMPORTANT: Make sure you have all the keys accessed below in the fetch request
        firstName = contact.givenName as NSString
        lastName = contact.familyName as NSString
        company = contact.organizationName as NSString
        contactId = contact.identifier
        
        //If lets are used becasue there are chances that we would be accessing nil objects
        if let thumbnailImageData = contact.thumbnailImageData
        {
            thumbnailProfileImage = UIImage(data:thumbnailImageData)
        }
        
        if let imageData = contact.imageData
        {
            profileImage = UIImage(data:imageData)
        }
        
        if let birthdayDate = contact.birthday {
            birthday = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)?.date(from: birthdayDate) as NSDate?
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = EPGlobalConstants.Strings.birdtdayDateFormat
            //Example Date Formats:  Oct 4, Sep 18, Mar 9
            birthdayString = dateFormatter.string(from: birthday! as Date)
        }
        
        for phoneNumber in contact.phoneNumbers {
            let phone = phoneNumber.value
            phoneNumbers.append((phoneNumber: phone.stringValue, phoneLabel: phoneNumber.label ?? ""))
        }

        for emailAddress in contact.emailAddresses {
            let email = emailAddress.value as String
            emails.append((email,emailAddress.label ?? ""))
        }

    
    }
    
    func displayName() -> String {
        return "\(String(describing: firstName)) \(String(describing: lastName))"
    }
    
    func contactInitials() -> String {
        var initials = String()
        if firstName.length > 0
        {
            initials.append(firstName.substring(to: 1))
        }
        if lastName.length > 0
        {
            initials.append(lastName.substring(to: 1))
        }
        return initials
    }
    
}
