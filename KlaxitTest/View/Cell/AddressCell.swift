//
//  AddressCell.swift
//  KlaxitTest
//
//  Created by Grégoire Marchand on 23/03/2022.
//

import Foundation
import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    func setup(with address: Address) {
        streetLabel.text = address.name
        cityLabel.text = "\(address.postcode) \(address.city)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        streetLabel.text = nil
        cityLabel.text = nil
    }
}
