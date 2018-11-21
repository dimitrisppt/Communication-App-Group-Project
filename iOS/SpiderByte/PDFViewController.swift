//
//  pdfViewController.swift
//  SpiderByte
//
//  Created by Sadi Ashraful on 26/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import PDFKit


/**
 
 */

class PDFViewController: UIViewController {
    
    /**
     
     */

    var pdfView: PDFView = PDFView ()
    var announcement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadPDF()
        playWithPDF()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     
     */
    private func configureUI(){
        
        
        pdfView = PDFView ()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        pdfView.delegate = self as? PDFViewDelegate
    }
    
    /**
     
     */
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)
    }
    
    /**
     
     */
    @objc private func handlePageChange(notification: Notification){
    }
    
    /**
     
     */
    private func loadPDF() {
        guard
            let url = URL(string:"http://stormy-reef-95988.herokuapp.com/listAnnouncements/pdf/\(announcement).pdf"),
            let document = PDFDocument(url: url)
            else { return }
        pdfView.document = document
        self.navigationItem.title = "Document"
    }
    
    /**
     
     */
    private func playWithPDF(){
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
    }
}
