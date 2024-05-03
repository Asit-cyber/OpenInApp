//
//  DataCellTableViewCell.swift
//  openInAppDemo
//
//  Created by ASIT GHATAK on 30/04/24.
//

import UIKit

class DataCellTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var currDate: UILabel!
    
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var clicks: UILabel!
    
    @IBOutlet weak var cell: DataCellTableViewCell!
    @IBOutlet weak var linkRow: DataCellTableViewCell!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
         //Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
//        linkRow.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
//        linkRow.layer.borderWidth = 0.5
//        linkRow.layer.borderColor = UIColor.blue.cgColor

        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.blue.cgColor
        dashedBorder.lineDashPattern = [2, 3] // Adjust the values to change the length of dashes and gaps
        let path = UIBezierPath(roundedRect: linkRow.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
        dashedBorder.frame = linkRow.bounds
        dashedBorder.fillColor = nil
//        dashedBorder.cornerRadius = 8
        dashedBorder.path = UIBezierPath(rect: linkRow.bounds).cgPath
        linkRow.layer.addSublayer(dashedBorder)
//        linkRow.layer.cornerRadius = 8
        // Configure the view for the selected state
    }
    
}
