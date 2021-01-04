//
//  QRCodeViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/30/20.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    var contact: Contact?
    
    @IBOutlet weak var customNavBar: UINavigationBar!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var nameInitialsLabel: UILabel!
    var filter: CIFilter!
    
    fileprivate func qrCodeSetup() {
        view.setGradientBackground( colorTop: UIColor(named: K.Colors.mcBlue)!, colorBottom: UIColor(named: "MC Wine")!)
        let text = "https://www.josephmacleanarhin@outlook.com"
        let data = text.data(using: .ascii, allowLossyConversion: false)
        
        filter = CIFilter(name: "CIQRCodeGenerator")
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 30, y: 30)
        
        let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
        
        qrcodeImageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrCodeSetup()
        customNavBar.shadowImage = UIImage()
        
        let randomColor = UIColor.random
        
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
