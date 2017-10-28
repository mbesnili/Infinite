//
//  InfiniteTableViewController.swift
//  Infinite
//
//  Created by mbesnili on 27/10/2017.
//  Copyright © 2017 mbesnili. All rights reserved.
//

import UIKit

class InfiniteTableViewController: UIViewController {
    
    enum Constants {
        enum UI {
            static let activityIndicatorSize = CGSize(width: 20.0, height: 20.0)
            static let loadMoreViewHeight = CGFloat(50.0)
            static let estimatedRowHeight = CGFloat(44.0)
        }
    }

    var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    lazy var loadMoreView: UIView = {
        let v = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: Constants.UI.loadMoreViewHeight))
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        activityIndicatorView.frame = CGRect(x: (self.view.bounds.width - Constants.UI.activityIndicatorSize.width) / 2, y: (v.bounds.height - Constants.UI.activityIndicatorSize.height) / 2, width: Constants.UI.activityIndicatorSize.width, height: Constants.UI.activityIndicatorSize.height)
        v.backgroundColor = .clear
        v.addSubview(activityIndicatorView)
        return v
    }()
    
    private var currentPage: Int = 0
    private var hasMore: Bool = true
    private var refreshing: Bool = true
    
    var tableViewStyle = UITableViewStyle.plain
    
    convenience init(tableViewStyle: UITableViewStyle) {
        self.init(nibName: nil, bundle: nil)
        self.tableViewStyle = tableViewStyle
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        tableView = UITableView(frame: .zero, style: tableViewStyle)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = loadMoreView
        tableView.estimatedRowHeight = Constants.UI.estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        view.backgroundColor = .white

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        request(for: currentPage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        var loadingMoreViewFrame = loadMoreView.frame
        loadingMoreViewFrame.size.width = view.bounds.width
        loadMoreView.frame = loadingMoreViewFrame
    }
    
    @objc func refreshControlValueChanged() {
        reset()
    }
    
    private func reset() {
        currentPage = 0
        hasMore = true
        refreshing = true
        request(for: currentPage)
    }
    
    private func request(for page: Int) {
        tableView(tableView, willFetchFor: page) { [weak self](hasMore) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.currentPage = strongSelf.currentPage + 1
            strongSelf.hasMore = hasMore
            if !hasMore {
                strongSelf.tableView.tableFooterView = UIView(frame: .zero)
            }
            if strongSelf.refreshControl.isRefreshing {
                strongSelf.refreshControl.endRefreshing()
            }
            strongSelf.refreshing = false
            strongSelf.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, willFetchFor page: Int, completionBlock: @escaping ((Bool) -> ())) {
        // Subclassses should override this method to make requests
    }

}

extension InfiniteTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        let lastSection = indexPath.section == tableView.numberOfSections - 1
        let lastCell = lastRow && lastSection
        if lastCell && hasMore && !refreshing {
            refreshing = true
            request(for: currentPage)
        }
    }
}

