//
//  SearchController.swift
//  KlaxitTest
//
//  Created by Grégoire Marchand on 22/03/2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController()
    private let viewModel = SearchViewModel()
    weak var delegate : SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = NSLocalizedString("addressLabel", comment: "Label for the address")
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        self.tableView.tableHeaderView = UIView()
        self.tableView.register(AddressCell.nib, forCellReuseIdentifier: AddressCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.viewModel.addresses.bind(listener: { [weak self] addresses in
            self?.tableView.reloadData()
        })
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "", query.count > 3 else {
            print("nothing to search")
            return
        }
        
        print(query)
        self.viewModel.fetchAddresses(with: query)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.addresses.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.identifier, for: indexPath) as? AddressCell else {
            return UITableViewCell()
        }
        let address = self.viewModel.addresses.value[indexPath.row]
        cell.setup(with: address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        if let delegate = delegate {
            delegate.returnSelectedAddress(label: self.viewModel.addresses.value[indexPath.row].label)
        }
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: false)
    }
}

protocol SearchViewControllerDelegate : NSObjectProtocol {
    func returnSelectedAddress(label: String)
}
