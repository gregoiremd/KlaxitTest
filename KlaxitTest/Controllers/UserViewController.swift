//
//  ViewController.swift
//  KlaxitTest
//
//  Created by Grégoire Marchand on 22/03/2022.
//

import UIKit
import Haneke

class UserViewController: UIViewController, SearchViewControllerDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    private let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.pictureUrl.bind { [weak self] pictureUrl in
            guard let url = URL(string: pictureUrl) else {
                //TODO: Show error
                return
            }
            self?.userImageView.hnk_setImageFromURL(url)
            self?.userImageView.layer.masksToBounds = true
            self?.userImageView.layer.cornerRadius = self!.userImageView.bounds.width / 2
        }
        
        viewModel.userName.bind { [weak self] userName in
            self?.nameLabel.text = userName
        }
        
        viewModel.phoneNumber.bind { [weak self] phoneNumber in
            self?.phoneNumberLabel.text = phoneNumber
            self?.phoneNumberLabel.isHidden = phoneNumber == nil || phoneNumber == ""
        }
        
        viewModel.company.bind { [weak self] company in
            self?.companyLabel.text = company
            self?.companyLabel.isHidden = company == nil || company == ""
        }
        
        viewModel.profession.bind { [weak self] profession in
            self?.professionLabel.text = profession
            self?.professionLabel.isHidden = profession == nil || profession == ""
        }
        
        viewModel.address.bind { [weak self] address in
            self?.addressLabel.text = address
            self?.addressLabel.isHidden = address == nil
        }
    }
    
    @IBAction func editPhoneNumber(_ sender: Any) {
        self.showInputDialog(title: NSLocalizedString("phoneNumberLabel", comment: "Label for the phone number"), inputValue: viewModel.phoneNumber.value, inputKeyboardType: .phonePad, actionHandler:  { (input) in
            if let input = input {
                self.viewModel.setPhoneNumber(value: input)
            }
        })
    }
    
    @IBAction func editCompany(_ sender: Any) {
        self.showInputDialog(title: NSLocalizedString("companyLabel", comment: "Label for the company"), inputValue: viewModel.company.value, inputKeyboardType: .default, actionHandler:  { (input) in
            if let input = input {
                self.viewModel.setCompany(value: input)
            }
        })
    }
    
    @IBAction func editProfession(_ sender: Any) {
        self.showInputDialog(title: NSLocalizedString("professionLabel", comment: "Label for the profession"), inputValue: viewModel.profession.value, inputKeyboardType: .default, actionHandler:  { (input) in
            if let input = input {
                self.viewModel.setProfession(value: input)
            }
        })
    }
    
    @IBAction func editAddress(_ sender: Any) {
        performSegue(withIdentifier: "search_segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "search_segue"){
            let searchVC = segue.destination as! SearchViewController
            searchVC.delegate = self
        }
    }
    
    func returnSelectedAddress(label: String) {
        self.viewModel.setAddress(value: label)
    }
    
    func showInputDialog(title: String? = nil,
                         subtitle: String? = nil,
                         inputValue: String? = nil,
                         inputKeyboardType: UIKeyboardType,
                         cancelHandler: ((UIAlertAction) -> Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.text = inputValue
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("validate", comment: "Label for the validate button"), style: .destructive, handler: { (_:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Label for the cancel button"), style: .cancel, handler: cancelHandler))
        self.present(alert, animated: true, completion: nil)
    }
}
