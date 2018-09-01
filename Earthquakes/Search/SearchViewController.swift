//
//  SearchViewController.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 9/1/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import MapKit

protocol SearchViewControllerDelegate: class {
    func searchView(_ searchViewController: SearchViewController, didSelectCoordinate coordinate: CLLocationCoordinate2D)
    func searchView(didCancel searchViewController: SearchViewController)
    func searchView(didFailed searchViewController: SearchViewController)
}

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private let loadingView = LoadingView()
    
    private let cellReuseIdentifier = String(describing: UITableViewCell.self)
    
    weak var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchCompleter.delegate = self
        self.searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
    }
    
    @IBAction func cancel(_ sender: AnyObject){
        self.delegate?.searchView(didCancel: self)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchCompleter.queryFragment = searchText
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
        print(error)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    /**
     Highlights the matching search strings with the results
     - parameter text: The text to highlight
     - parameter ranges: The ranges where the text should be highlighted
     - parameter size: The size the text should be set at
     - returns: A highlighted attributed string with the ranges highlighted
     */
    func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let regular = UIFont.systemFont(ofSize: size)
        attributedText.addAttribute(.font, value: regular, range: NSMakeRange(0, text.count))
        
        let bold = UIFont.boldSystemFont(ofSize: size)
        for value in ranges {
            attributedText.addAttribute(.font, value:bold, range:value.rangeValue)
        }
        return attributedText
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = self.searchResults[indexPath.row]
        let cell = self.searchResultsTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.attributedText = self.highlightedText(searchResult.title, inRanges: searchResult.titleHighlightRanges, size: 17.0)
        cell.detailTextLabel?.attributedText = self.highlightedText(searchResult.subtitle, inRanges: searchResult.subtitleHighlightRanges, size: 12.0)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        self.loadingView.display()
        search.start { (response, error) in
            DispatchQueue.main.async {
                self.loadingView.hide()
            }
            if let coordinate = response?.mapItems.first?.placemark.coordinate{
                self.delegate?.searchView(self, didSelectCoordinate: coordinate)
            }else{
                self.delegate?.searchView(didFailed: self)
            }
        }
    }
}
