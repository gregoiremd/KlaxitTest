//
//  SearchViewModel.swift
//  KlaxitTest
//
//  Created by Grégoire Marchand on 23/03/2022.
//

import Foundation

public class SearchViewModel {
    
    let addresses: Box<[Address]> = Box([])
    let error: Box<String?> = Box(nil)
    
    func fetchAddresses(with input: String) {
        AddressProvider.shared.fetchAddresses(input: input, { [weak self] result in
            switch result {
            case .success(let addresses):
                self?.addresses.value = addresses
                break
            case .failure(let error):
                self?.error.value = error.localizedDescription
                break
            }
        })
    }
    
    
}
