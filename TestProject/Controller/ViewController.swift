//
//  ViewController.swift
//  TestProject
//
//  Created by Patel, Sanjay on 3/31/17.
//  Copyright © 2017 Patel, Sanjay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var appointmentsList: UICollectionView!
    
    let baseURL = "https://photo.nemours.org/P/%@/100x100?type=P"
    
    let appointmentService = AppointmentService.getInstance()
    
    var pastAppointments = [Appointment]()
    var filteredAppointments = [Appointment]()
    
    var futureAppointments = [Appointment]()
    
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    let dtFormatter = DateFormatter()
    
    //Set the delegate of the appointment service to receive data
    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession.shared
        appointmentService.delegate = self
        self.cache = NSCache()
    }

    //Get the appointments when the view will appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appointmentService.getAppointments()
    }
    
    //When the orientation changes, relayout the list of appointments to fit on the screen as per device
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        appointmentsList.reloadData()
    }
    
    func prepareURL(providerId: String) -> String {
        return String(format: baseURL, providerId)
    }
    
    func getAppointmentDate(date: Date) -> String {
        dtFormatter.dateFormat = "MMM dd, yyyy"
        return dtFormatter.string(from: date)
    }
    
    func getAppointmentTime(date: Date) -> String {
        dtFormatter.dateFormat = "hh : mm a"
        return dtFormatter.string(from: date)
    }
}

extension ViewController: AppointmentServiceDelegate {
    //Delegate method that will be called after appointments are fetched
    func appointmentsRetrieved(pastAppointmentArray: [Appointment], futureAppointmentArray: [Appointment]) {
        //Set both past and filter appointments
        self.pastAppointments = pastAppointmentArray
        self.filteredAppointments = pastAppointmentArray
        //Set future appointments
        self.futureAppointments = futureAppointmentArray

        appointmentsList.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //Return the cells to be displayed for future and past/filtered appointments
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return futureAppointments.count
        } else {
            return filteredAppointments.count
        }
    }
    
    //Set the cell of the tableview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            //Future
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FutureCell", for: indexPath) as! UpcomingEventsCell
            
            let futureObj = futureAppointments[indexPath.item]
            
            cell.dateLabel.text = getAppointmentDate(date: futureObj.dateAndTime!)
            cell.timeLbl.text = getAppointmentTime(date: futureObj.dateAndTime!)
            
            let providerName = "\(futureObj.providerFirstName!) \(futureObj.providerLastName!)"
            cell.drName = providerName
            cell.specialist = futureObj.providerSpecialty
            
            let address = getAddress(from: futureObj.address!)
            let streetAddress = address["Street"]
            
            cell.addressOne = streetAddress!
            
            let cityAndState = "\(address["City"]!), \(address["State"]!) \(address["ZIP"]!)"
            cell.addressTwo = cityAndState
            
            //Show it from cache or download it and show
            if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                print("Cached image used, no need to download it")
                cell.image.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            }else{
                let artworkUrl = prepareURL(providerId: futureObj.providerId!) //dictionary["artworkUrl100"] as! String
                let url:URL! = URL(string: artworkUrl)
                session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        // 4
                        DispatchQueue.main.async(execute: { () -> Void in
                            // 5
                            // Before we assign the image, check whether the current cell is visible
                            if let updateCell = self.appointmentsList.cellForItem(at: indexPath) as? UpcomingEventsCell{
                                let img:UIImage! = UIImage(data: data)
                                updateCell.image.image = img
                                self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            }
                        })
                    }
                }).resume()
            }
            
            return cell
        }
        
        //Set the past appointments
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastCell", for: indexPath) as! PastEventsCell
        
        let pastObj = filteredAppointments[indexPath.item]
        cell.specialist = pastObj.providerSpecialty
        cell.timeAndDrName = "\(getAppointmentTime(date: pastObj.dateAndTime!)) - \(pastObj.providerFirstName!) \(pastObj.providerLastName!)"
        cell.dateLbl.text = getAppointmentDate(date: pastObj.dateAndTime!)
        
        //Show it from cache or download it and show
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            print("Cached image used, no need to download it")
            cell.image.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }else{
            let artworkUrl = prepareURL(providerId: pastObj.providerId!) //dictionary["artworkUrl100"] as! String
            let url:URL! = URL(string: artworkUrl)
            session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    // 4
                    DispatchQueue.main.async(execute: { () -> Void in
                        // 5
                        // Before we assign the image, check whether the current cell is visible
                        if let updateCell = self.appointmentsList.cellForItem(at: indexPath) as? PastEventsCell {
                            let img:UIImage! = UIImage(data: data)
                            updateCell.image.image = img
                            self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                        }
                    })
                }
            }).resume()
        }
        
        return cell
    }
    
    //Parse the address
    func getAddress(from dataString: String) -> [String: String] {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
        let matches = detector.matches(in: dataString, options: [], range: NSRange(location: 0, length: dataString.utf16.count))
        
        var resultsArray =  [String: String]()
        
        for match in matches {
            if match.resultType == .address,
                let components = match.addressComponents {
                resultsArray = components
            } else {
                print("no components found")
            }
        }
        return resultsArray
    }
    
    //Set the header of future and past appointments sections
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
            
            sectionHeaderView.headerTitle = "Upcoming Visits"
            sectionHeaderView.allTypesBtn.isHidden = true
            sectionHeaderView.asthmaOnlyBtn.isHidden = true
            
            return sectionHeaderView
        } else {
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
            
            sectionHeaderView.headerTitle = "Past Vists"
            sectionHeaderView.allTypesBtn.isHidden = false
            sectionHeaderView.asthmaOnlyBtn.isHidden = false
            sectionHeaderView.delegate = self
            return sectionHeaderView
            
        }
    }
    
    //Change the layout of the cell based on the orientation of the device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.size.width, height: 148)
        }
        
        return CGSize(width: view.frame.size.width, height: 101)
    }
}

extension ViewController: SectionHeaderDelegate {
    //Delegate method to show full or astham filtered list
    //Filter and then update the appointments list
    func showAsthma(allow: Bool) {
        if allow {
            filteredAppointments = pastAppointments.filter({ (appointment) -> Bool in
                return appointment.isAsthmaAppointment == true
            })
        } else {
            filteredAppointments = pastAppointments
        }
        
        appointmentsList.reloadData()
    }
}
