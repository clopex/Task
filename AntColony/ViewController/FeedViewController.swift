//
//  FeedViewController.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController {
    
    var feeds: [Feed] = [] {
        didSet {
            self.tableView.reloadData()
            self.stopActivityIndicator()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startActivityIndicator()
        setupUI()
        setup()
        observePosts()
        self.view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    }
    
    private func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPost)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeddCell", bundle: nil), forCellReuseIdentifier: FeddCell.reuseIdentifier)
        tableView.estimatedRowHeight = 800
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupUI() {
        self.view.addSubview(topView)
        self.view.addSubview(tableView)
        self.view.addSubview(emptyText)
        self.topView.addSubview(profileImage)
        self.topView.addSubview(dummyText)
                
        _ = topView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 100, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 70)
        _ = profileImage.anchor(nil, left: topView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        profileImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        _ = dummyText.anchor(nil, left: profileImage.rightAnchor, bottom: nil, right: topView.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        dummyText.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        _ = tableView.anchor(topView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = emptyText.anchor(topView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 24, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        emptyText.isHidden = true
    }
    
    private func observePosts() {
        FirebaseManager.observePost { [weak self] (feed) in
            if feed.isEmpty {
                self?.tableView.isHidden = true
                self?.emptyText.isHidden = false
                self?.stopActivityIndicator()
            } else {
                self?.tableView.isHidden = false
                self?.emptyText.isHidden = true
                self?.feeds = feed
            }
        }
    }
    
    @objc func openPost() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC = storyboard.instantiateViewController(withIdentifier: "PostViewController")
        self.present(postVC, animated: true)
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signIn = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        signIn?.isLogout = true
        let navController = UINavigationController(rootViewController: signIn!)
        UIApplication.shared.keyWindow?.rootViewController = navController
    }
    
    
    
    let topView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        view.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.image = UIImage(named: "profile")
        return imageView
    }()
    
    let dummyText: UILabel = {
        let label = UILabel()
        label.text = "What is on your mind?"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let emptyText: UILabel = {
        let label = UILabel()
        label.text = "No posts!"
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        table.backgroundView = bgView
        return table
    }()
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeddCell.reuseIdentifier) as! FeddCell
        let feed = feeds[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.likeBtn.tag = indexPath.row
        cell.setupUI(feed)
        return cell
    }
}

extension FeedViewController: FeedCellDelegate {
    func likeTap(_ at: Int) {
        feeds[at].isLiked?.toggle()
    }
}
