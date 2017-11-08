//
//  MovieViewController.swift
//  Flicks
//
//  Created by Deepthy on 9/13/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import ARSLineProgress

class MovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var toolbarView: UIToolbar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedCntrl: UISegmentedControl!
    
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let defaults = UserDefaults.init()
    fileprivate var movies: [[String: Any]]  = [[:]]
    fileprivate var movie : Movie!
    fileprivate var moviesList: [Movie] = []
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var selectedMovie:Movie? {
        didSet {
            if let movie = selectedMovie {
                selectedMovie = movie
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden  = true
        
        errorView.isHidden = true

        self.tabBarController?.delegate = self
        searchBar.delegate = self

        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: Constants.refreshControlTitle)
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named: "Flicks"), for: .default)
            navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.gray.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize.init(width:2, height:2)
            shadow.shadowBlurRadius = 4
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        }
    
        defaults.set((self.tabBarController?.selectedIndex)!, forKey: "TAB_VALUE" )
        
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tableView.addSubview(self.refreshControl)
        self.collectionView.addSubview(self.refreshControl)
        
        self.collectionView.isHidden = defaults.integer(forKey: "SEGMENTED_VALUE") == 0
        self.tableView.isHidden = defaults.integer(forKey: "SEGMENTED_VALUE") != 0
        self.segmentedCntrl.selectedSegmentIndex = defaults.integer(forKey: "SEGMENTED_VALUE")

        let  selection = self.tableView.indexPathForSelectedRow
        
        if selection != nil {
            self.tableView.deselectRow(at: selection!, animated: true)
        }
        
        self.tabBarController?.tabBar.items?[0].isEnabled = true
        self.tabBarController?.tabBar.items?[1].isEnabled = true

    }
    
    func refresh(sender:AnyObject) {
        
        self.errorView.isHidden = true
        self.searchBar.isHidden = false
        self.toolbarView.isHidden = false
        
        getMovies()
        
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }

    fileprivate func getMovies()
    {
        var urlString = Constants.nowPlayingURL
        
        if defaults.integer(forKey: "TAB_VALUE") == 1 {
            urlString = Constants.topRatedURL
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession (
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )

        ARSLineProgress.showWithPresentCompetionBlock {

            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {
                (dataOrNil, response, error) in
                if let err = error {
                
                    ARSLineProgress.hide()
                
                    self.tableView.addSubview(self.refreshControl)
                    self.collectionView.addSubview(self.refreshControl)

                    self.movies.removeAll()
                    self.moviesList.removeAll()

                    self.tableView.reloadData()
                    self.collectionView.reloadData()

                    self.errorView.isHidden = false
                    self.errorView.backgroundColor = UIColor(red: 0.00, green: 0.16, blue: 0.29, alpha: 0.9)
                    self.searchBar.isHidden = true
                    self.toolbarView.isHidden = true
                
                    print ("err \(err)")
                }
                else
                {
                    if let data = dataOrNil {
                    
                        let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                        self.movies = dictionary["results"] as! [[String: Any]]
                    
                        self.moviesList = []
                    
                        for result in self.movies {
                            self.moviesList.append(Movie(data: result))
                        }
                    
                        if !self.tableView.isHidden {
                            self.tableView.reloadData()
                        
                        }
                        else {
                            self.collectionView.reloadData()
                        
                        }

                        ARSLineProgress.hide()
                    }
                }
            });
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var indexPath: IndexPath?
        
        if let cell = sender as? MovieCell {
            indexPath = tableView.indexPath(for: cell)
        }
        
        if let cell = sender as? MovieCollectionCell {
            indexPath = collectionView.indexPath(for: cell)
        }
        selectedMovie = moviesList[(indexPath?.row)!]
        
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            movieDetailsViewController.movie = selectedMovie
        }
        
    }

    @IBAction func toggleView(_ sender: Any) {
        
        let segmentedSelectedIndex = (sender as AnyObject).selectedSegmentIndex!
        defaults.set(segmentedSelectedIndex, forKey: "SEGMENTED_VALUE" )
        
        self.collectionView.isHidden = defaults.integer(forKey: "SEGMENTED_VALUE") == 0
        self.tableView.isHidden = defaults.integer(forKey: "SEGMENTED_VALUE") != 0

        if defaults.integer(forKey: "SEGMENTED_VALUE") == 0 {
            self.tableView?.addSubview(self.refreshControl)
            self.tableView.reloadData()
        }
        else {
            self.collectionView?.addSubview(self.refreshControl)
            self.collectionView.reloadData()
        }
    }
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableReuseIdentifier) as! MovieCell
        cell.selectionStyle = .default
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: (198.0/255.0), green: (21.0/255.0), blue: (19.0/255.0), alpha: 1.0).withAlphaComponent(0.1)
        cell.selectedBackgroundView = bgColorView
        
        let movie = moviesList[indexPath.row]//movies[indexPath.row]
        cell.movie = movie
        
        return cell
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate protocol
extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionReuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionCell
        cell.layer.borderWidth = 1

        let movie = moviesList[indexPath.row]
        cell.movie = movie
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout protocol
extension MovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UITabBarControllerDelegate delegate
extension MovieViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        defaults.set((self.tabBarController?.selectedIndex)!, forKey: "TAB_VALUE" )
        self.collectionView.isHidden = defaults.integer(forKey: "SEGMENTED_VALUE") == 0
        self.tableView.isHidden = defaults.integer(forKey: "SEGMENTED_VALUE") != 0

        if defaults.integer(forKey: "SEGMENTED_VALUE") == 0 {
            self.tableView?.addSubview(self.refreshControl)
            tableView.reloadData()
            
        }
        else {
            self.tableView.isHidden = true
            collectionView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate delegate
extension MovieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            getMovies()
            searchBar.resignFirstResponder()
            
        } else {
            filterTableView(text: searchText)
        }
    }
    
    private func filterTableView(text: String) {
        
        //fix of not searching when backspacing
        let filteredMovies = movies.filter({ (movie: [String: Any]) -> Bool in
            
            let matchFound = (movie["title"]! as! String).lowercased().contains(text.lowercased())
            return matchFound
        })
        
        if filteredMovies.count != 0 {
            var filteredList: [Movie] = []
            
            for result in filteredMovies {
                filteredList.append(Movie(data: result))
            }
            
            moviesList = filteredList
        }
        
        if !self.tableView.isHidden {
            self.tableView.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        
        searchBar.endEditing(true)
        getMovies()
        
    }
}
