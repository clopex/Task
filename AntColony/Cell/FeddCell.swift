//
//  FeddCell.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import UIKit

protocol FeedCellDelegate: class {
    func likeTap(_ at: Int)
}

class FeddCell: UITableViewCell {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var numLike: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    weak var delegate: FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(_ feed: Feed) {
        if let text = feed.postText {
            post.text = text
        }
        if let name = feed.name {
            fullName.text = name
        }
        if let timeDouble = feed.time {
            let newData = Date.init(milliseconds: timeDouble)
            let minutes = Date().minutesFrom(date: newData)
            time.text = "\(minutes ?? 0) minutes ago"
        }
        if let isLiked = feed.isLiked {
            if isLiked {
                likeBtn.alpha = 1
            } else {
                likeBtn.alpha = 0.2
            }
        }
        numLike.text = "\(123)"
        
    }
    
    @IBAction func likeTap(_ sender: UIButton) {
        delegate?.likeTap(sender.tag)
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension Date {
    init(milliseconds:Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func minutesFrom(date: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute
    }
}
