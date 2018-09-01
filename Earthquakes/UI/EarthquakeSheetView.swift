//
//  EarthquakeSheetView.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 9/1/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import AppDomain

typealias EarthquakeSheetViewDataSource = UITableViewDataSource & EarthquakesDataSourceProtocol
protocol EarthquakeSheetViewDelegate: class {
    func sheetView(_ sheetView: EarthquakeSheetView, didSelectEarthquake earthquake: Earthquake)
}

class EarthquakeSheetView: SheetView {
    
    private var tableView: UITableView!
    private let dataSource: EarthquakeSheetViewDataSource
    weak var earthquakDelegate: EarthquakeSheetViewDelegate?
    
    init(dataSource: EarthquakeSheetViewDataSource) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        self.closeOnTap = false
        self.setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView(){
        self.tableView = UITableView(frame: .zero)
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 92
        self.tableView.backgroundColor = UIColor.clear
        let reuseIdentifier = String(describing: EarthquakeCell.self)
        self.tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    func install() {
        super.install(self.tableView)
    }
    
    func reloadData(){
        self.tableView.reloadData()
    }
}

extension EarthquakeSheetView: UITableViewDelegate{
    func callDelegate(forModelAt index: Int){
        let model = self.dataSource.earthquakes[index]
        self.earthquakDelegate?.sheetView(self, didSelectEarthquake: model)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.callDelegate(forModelAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.callDelegate(forModelAt: indexPath.row)
    }
    
}
