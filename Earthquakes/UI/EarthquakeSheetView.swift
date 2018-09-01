//
//  EarthquakeSheetView.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 9/1/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit

class EarthquakeSheetView: SheetView {
    
    private var tableView: UITableView!
    private let dataSource: UITableViewDataSource
    
    init(dataSource: UITableViewDataSource) {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function, #line)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print(#function, #line)
    }
    
}
