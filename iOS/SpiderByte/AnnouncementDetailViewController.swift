//
//  AnnouncementDetailViewController.swift
//  SpiderByte
//
//  Created by Alin Fulga on 27/02/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import FirebaseDatabaseUI
import Firebase
import Down
import FontAwesomeIconFactory
import Floaty

/** The view controller for the detail page upon selection of an announcement.
 */
class AnnouncementDetailViewController: UIViewController, FloatyDelegate {
    
//relevant outlets.
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorImage: UIImageView!
    
    var announcementKey = ""
    var email = ""
    let announcement: Announcement = Announcement()
    lazy var ref: DatabaseReference = Database.database().reference()
    var announcementRef: DatabaseReference!
    var eventRef: DatabaseReference!
    var refHandle: DatabaseHandle?
    var eventRefHandle: DatabaseHandle?
    var contentView: DownView?
    var actionButton: Floaty!
    
    /** Call the other functions within view did load, as it is required upon the page load
     directy after clicking the announcement.
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseContentView()
        initialiseDatabaseChild()
        initialiseNavbarTitle()
        initialiseFloatingButton()
        checkUserReadAnnouncement()
    }
    
    func layoutFAB() {
        let fab = Floaty()
        let item = FloatyItem()
        item.buttonColor = UIColor(red: 188/255, green: 46/255, blue: 35/255, alpha: 1)
        item.circleShadowColor = UIColor.red
        item.titleShadowColor = UIColor(red: 188/255, green: 46/255, blue: 35/255, alpha: 0.5)
        item.title = "Custom item"
        item.handler = { item in }
        
        fab.fabDelegate = self
    }
    func initialiseFloatingButton() {
        
        actionButton = Floaty()
        actionButton.buttonColor =  UIColor(hexString: "#009688")
        actionButton.plusColor = UIColor.white
        actionButton.fabDelegate = self
        actionButton.isHidden = true
        
        self.view.addSubview(actionButton)
        
    }

    private func initialiseNavbarTitle() {
        self.navigationItem.title = "Announcement Detail"
    }
    
    private func initialiseDatabaseChild() {
        announcementRef = ref.child("announcements").child(announcementKey)
        eventRef = ref.child("event").child(announcementKey)
    }
    
    private func generateDownViewHeight() -> CGFloat {
        return UIScreen.main.bounds.height - authorLabel.frame.height - authorImage.frame.height - (navigationController?.navigationBar.frame.height ?? 0) - view.safeAreaInsets.top - 70
    }
    
    private func initialiseContentView() {
        guard let contentView = try? DownView(frame: CGRect(x: 0, y: 0, width: 0, height: 10), markdownString: "") else { return }
        view.addSubview(contentView)
        contentView.scrollView.bounces = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: generateDownViewHeight()).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.contentView = contentView
    }
    private func checkUserReadAnnouncement() {
        announcementRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var announcement = currentData.value as? [String : AnyObject] {
                var readingList = announcement["readingList"] as? NSMutableArray ?? []
                
                if readingList == ["none"] {
                    readingList = [self.email]
                }
                else {
                    if !readingList.contains(self.email) {
                        readingList.add(self.email)
                    }
                }

                announcement["readingList"] = readingList as AnyObject?
                
                // Set value and report transaction success
                currentData.value = announcement
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    private func createItem(title: String, icon: NIKFontAwesomeIcon) -> FloatyItem {
        
        let item = FloatyItem()
        let factory = FontAwesomeIconFactory.init()
        item.buttonColor = UIColor(hexString: "#D32F2F")
        item.circleShadowColor = UIColor.red
        item.titleShadowColor = UIColor(red: 188/255, green: 46/255, blue: 35/255, alpha: 0.5)
        item.title = title
        item.icon = factory.createImage(icon)
        item.iconTintColor = UIColor.white
        item.handler = { item in }
        self.actionButton.addItem(item: item)
        self.actionButton.isHidden = false
        
        return item
    }
    @objc override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refHandle = announcementRef.observe(DataEventType.value, with: { (snapshot) in

            let announcementDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.announcement.setValuesForKeys(announcementDict)

            do {
                try self.contentView?.update(markdownString: self.announcement.content)
                if let decodedImage = Data(base64Encoded: self.announcement.photoB64, options: .ignoreUnknownCharacters) {
                    self.authorImage.image =  UIImage(data: decodedImage)
                    self.authorImage.clipsToBounds = true
                    self.authorImage.layer.masksToBounds = true
                    self.authorImage.layer.cornerRadius = self.authorImage.frame.width / 2
                }
                self.authorLabel.text = self.announcement.author
                self.titleLabel.text = self.announcement.title
                
                if self.announcement.pdf != "" {
                    let item = self.createItem(title: "Open file", icon: NIKFontAwesomeIcon.filePdfO)
                    item.handler = { (item) in
                        self.actionButton.items = []
                        self.actionButton.close()
                        self.performSegue(withIdentifier: "pdfSegue", sender: nil)
                    }
                }
                
                if self.announcement.hasEvent == 1 {
                    let item = self.createItem(title: "Show event", icon: NIKFontAwesomeIcon.calendarPlusO)
                    item.handler = { (item) in
                        let event = Event()
                        self.eventRefHandle = self.eventRef.observe(DataEventType.value, with: { (snapshot) in
                            
                            let eventDict = snapshot.value as? [String : AnyObject] ?? [:]
                            event.setValuesForKeys(eventDict)
                            let alert = UIAlertController(title: event.title, message: "\(event.location)\n\(event.day) from \(event.starttime) to \(event.endtime)\n\(event.desc)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        })
                        self.eventRef.removeObserver(withHandle: self.eventRefHandle!)
                        self.actionButton.close()
                    }
                }

            }
            catch {
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pdf: PDFViewController = segue.destination as? PDFViewController else {
            return
        }
        pdf.announcement = self.announcementKey
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let refHandle = refHandle {
            announcementRef.removeObserver(withHandle: refHandle)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

