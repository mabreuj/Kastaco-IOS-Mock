//
//  UITableViewMock.swift
//  RollerBladeApp
//
//  Created by Miguel Abreu on 8/19/17.
//  Copyright © 2017 TED. All rights reserved.
//

import UIKit

class UITableViewMock: UITableView {

    @IBInspectable var rows:Int = 3
    @IBInspectable var cellName:String = "cell"
    @IBInspectable var sections:Int = 1
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
    }
}

extension UITableViewMock: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: cellName) ?? UITableViewCell.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
}
