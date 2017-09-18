//
//  MovieViewController.swift
//  Flicks
//
//  Created by Deepthy on 9/13/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import AFNetworking
import ARSLineProgress


class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var toolbarView: UIToolbar!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segmentedCntrl: UISegmentedControl!
    
    let refreshControl = UIRefreshControl()
    
    let defaults: UserDefaults = UserDefaults.init()
    
    var movies: [[String: Any]]  = [[String: Any]] ()
    var movie : Movie!
    var moviesList: [Movie] = [Movie] ()

    var tabIndex = 0
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
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
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named: "Flicks"), for: .default)
            navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            //navigationBar.layer.borderWidth = 1
            //navigationBar.layer.borderColor = UIColor.white.cgColor
            
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
        
        let segVal = defaults.integer(forKey: "SEGMENTED_VALUE")
        
        print("segVal \(segVal)")
        
        if(segVal == 0)
        {
            self.collectionView.isHidden = true
            self.tableView.isHidden = false
            self.tableView?.addSubview(self.refreshControl)
            tableView.reloadData()
            
        }
        else {
            self.collectionView.isHidden = false
            self.collectionView?.addSubview(self.refreshControl)
            self.tableView.isHidden = true
            collectionView.reloadData()
        }
        
        
        self.segmentedCntrl.selectedSegmentIndex = segVal
        
        defaults.set((self.tabBarController?.selectedIndex)!, forKey: "TAB_VALUE" )
        
        
        print("viewDidLoad  ")
        print("self.collectionView.isHidden  \(self.collectionView.isHidden)")
        
        print("self.tableView.isHidden \(self.tableView.isHidden)  ")
        print("*************************************  ")
        
        getMovies()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tableView.addSubview(self.refreshControl)
        self.collectionView.addSubview(self.refreshControl)
        
        print ("viewWillAppear  ------>  self.tabBarController?.selectedIndex \(self.tabBarController?.selectedIndex)")
        
        self.tabBarController?.tabBar.items?[0].isEnabled = true
        self.tabBarController?.tabBar.items?[1].isEnabled = true

        if(defaults.integer(forKey: "SEGMENTED_VALUE") == 0)
        {
            self.collectionView.isHidden = true
            self.tableView.isHidden = false
            let  selection = self.tableView.indexPathForSelectedRow
            print("selection \(selection)")

            if ((selection) != nil) {
                self.tableView.deselectRow(at: selection!, animated: true)
            }
            self.tableView?.addSubview(self.refreshControl)
            
            //tableView.reloadData()
            
        }
        else {
            self.collectionView.isHidden = false
            self.collectionView?.addSubview(self.refreshControl)
            
            self.tableView.isHidden = true
            //   collectionView.reloadData()
            
        }
        
        self.segmentedCntrl.selectedSegmentIndex = defaults.integer(forKey: "SEGMENTED_VALUE")
        
        print("viewWillAppear  ")
        print("self.collectionView.isHidden  \(self.collectionView.isHidden)")
        
        print("self.tableView.isHidden \(self.tableView.isHidden)  ")
        print("*************************************  ")
        
        
        
    }
    
    func refresh(sender:AnyObject) {
        
        self.errorView.isHidden = true
        //self.errorView.backgroundColor = UIColor.clear
        self.searchBar.isHidden = false
        self.toolbarView.isHidden = false
        //self.tableView.addSubview(self.refreshControl)
        //self.collectionView.addSubview(self.refreshControl)
        getMovies()
        
        if self.refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
        }
    }

    func getMovies()
    {
        
        var urlString = Constants.nowPlayingURL
        
        if((defaults.object(forKey: "TAB_VALUE")! as! Int) == 1)
        {
            
            urlString = Constants.topRatedURL
            
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )

        ARSLineProgress.showWithPresentCompetionBlock {

        
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
        {
            (dataOrNil, response, error) in
            if let err = error {
                
                ARSLineProgress.hide()
                
                self.tableView.addSubview(self.refreshControl)
                self.collectionView.addSubview(self.refreshControl)

                self.movies.removeAll()
                self.moviesList.removeAll()

                self.tableView.reloadData()
                self.collectionView.reloadData()

                //self.tableView.isHidden = true
                self.errorView.isHidden = false
                self.errorView.backgroundColor = UIColor(red: 0.00, green: 0.16, blue: 0.29, alpha: 0.9)
                self.searchBar.isHidden = true
                self.toolbarView.isHidden = true
                
                print ("err \(err)")


            }
            else
            {
                //self.tableView.isHidden = false
                
                if let data = dataOrNil {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    self.movies = dictionary["results"] as! [[String: Any]]
                    
                    self.moviesList = [Movie]()
                    
                    for result in self.movies {
                        self.moviesList.append(Movie(data: result))
                    }
                    
                    if(!self.tableView.isHidden)
                    {
                        self.tableView.reloadData()
                        
                    }
                    else{
                        self.collectionView.reloadData()
                        
                    }

                    
                    ARSLineProgress.hide()
                }
            }
        });
        task.resume()
        }
    }
    
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
        
        var posterUrl :URL!
        
        if let path = movie.moviePosterPath {
            
            print("Path for title \(movie.movieTitle) -----> \(path)")
            //let cellImgBaseUrl = "http://image.tmdb.org/t/p/w500"
            posterUrl = URL(string: Constants.cellImgBaseUrl + path)
        
            let posterRequest = URLRequest(url: posterUrl)
        
            cell.posterView.setImageWith(
                posterRequest,
                placeholderImage: nil,
                success: {
                    (imageRequest, imageResponse, image) -> Void in
            
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
            
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            
                    print("error in animation --->> \(error)")
                })
        
        }
        
        
        cell.titleLabel.text = movie.movieTitle
        cell.synopsisLabel.text = movie.movieOveriew
        cell.synopsisLabel.sizeToFit()
        //cell.posterView.setImageWith(posterUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let nameVC = NameController()
       // nameVC.fullName = names[indexPath.row]
       // nameVC.delegate = self
        
        //selectedIndexPath = indexPath
     //   tableView.deselectRow(at: indexPath, animated: false)
       // self.navigationController?.pushViewController(nameVC, animated: true)
        
    }
    
    var selectedMovie:Movie?
    {
        didSet {
            if let movie = selectedMovie {
                
                selectedMovie = movie
                
            }
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
    
        print(" ======== switchTabs sender ======= ")
        //print("self.tabBarController?.selectedIndex \(self.tabBarController?.selectedIndex)")
        print(" (sender as AnyObject).selectedSegmentIndex ======= \((sender as AnyObject).selectedSegmentIndex!)")
        
        
        
        let segmentedSelectedIndex = (sender as AnyObject).selectedSegmentIndex!
        defaults.set(segmentedSelectedIndex, forKey: "SEGMENTED_VALUE" )
        
        if((defaults.object(forKey: "SEGMENTED_VALUE")! as! Int) == 0)
        {
            self.collectionView.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        else {
            self.collectionView.isHidden = false
            self.tableView.isHidden = true
            self.collectionView.reloadData()
        }
        
        print("selectedSeg  ")
        print("self.collectionView.isHidden  \(self.collectionView.isHidden)")
        
        print("self.tableView.isHidden \(self.tableView.isHidden)  ")
        print("*************************************  ")
        
        
    }

    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionReuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionCell
        
        let movie = moviesList[indexPath.row]
        
        if let path = movie.moviePosterPath//["poster_path"] as? String 
        {
            let posterUrl: URL = URL(string: Constants.cellImgBaseUrl + path)!
            
            let posterRequest = URLRequest(url: posterUrl)
            
            cell.collectionCellImg.setImageWith(
                posterRequest,
                placeholderImage: nil,
                success: {
                    (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        
                        print("Image was NOT cached, fade in image")
                        cell.collectionCellImg.alpha = 0.0
                        cell.collectionCellImg.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.collectionCellImg.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.collectionCellImg.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
                    
                    print("error in animation --->> \(error)")
            })
            
            
        }
        cell.layer.borderWidth = 1
        
      //  cell.collectionCellImg.setImageWith(posterUrl)
        
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // MARK: - tab bar delegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //print("tabBar111 \(viewController)")
        // let yourView = viewController as! UINavigationController
        
        print("tabbar index -=== tabBarController ====  \(self.tabBarController?.selectedIndex)")
        
        // print("segmented control index -== tabBarControlle r======  \(self.segmentedCntrl.selectedSegmentIndex)")
        
        
        defaults.set((self.tabBarController?.selectedIndex)!, forKey: "TAB_VALUE" )
        
        
        
        //self.segmentedCntrl.selectedSegmentIndex = defaults.object(forKey: "SEGMENTED_VALUE")! as! Int
        
        // yourView.popToRootViewController(animated: false)
        // print("tabBar222 \(yourView)")
        
        //if((defaults.object(forKey: "SEGMENTED_VALUE")! as! Int) == 0)
        
        if(defaults.integer(forKey: "SEGMENTED_VALUE") == 0)
        {
            self.collectionView.isHidden = true
            self.tableView.isHidden = false
            self.tableView?.addSubview(self.refreshControl)
            tableView.reloadData()
            
        }
        else {
            self.collectionView.isHidden = false
            self.collectionView?.addSubview(self.refreshControl)
            
            self.tableView.isHidden = true
            collectionView.reloadData()
        }
        //self.viewWillAppear(true)
        //getMovies()
        
        
        print("tabBarController  ")
        print("self.collectionView.isHidden  \(self.collectionView.isHidden)")
        
        print("self.tableView.isHidden \(self.tableView.isHidden)  ")
        print("*************************************  ")
        
        
    }

    // MARK: - search bar delegate
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            print("if searchBar")
            
            getMovies()
            searchBar.resignFirstResponder()
            
        }else {
            
            print("else searchBar")
            filterTableView(text: searchText)
        }
    }
    
    
    func filterTableView(text: String) {
        print("filterTableView searchBar")
        ////    print("text \(text)")
        
        //fix of not searching when backspacing
        let filteredMovies = movies.filter({ (movie: [String: Any]) -> Bool in
            
            ////            print("movie[title] --->\(movie["title"]!)")
            ////           print("text   \(text)")
            
            let matchFound = (movie["title"]! as! String).lowercased().contains(text.lowercased()) //== text.lowercased()
            
            ////         print("matchFound --->\(matchFound)")
            
            return matchFound
        })
           print("movies --->\(movies.count)")
        
        if(filteredMovies.count != 0)
        {

            var filteredList = [Movie]()
            
            for result in filteredMovies {
                filteredList.append(Movie(data: result))
            }
            
            moviesList = filteredList

            print("--moviesList--- \(self.moviesList[0].movieReleaseDate)")


        }
        
        if(!self.tableView.isHidden)
        {
            self.tableView.reloadData()
        }
        else{
            self.collectionView.reloadData()
            
        }
        
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        print("searchBarSearchButtonClicked ")
        
        searchBar.resignFirstResponder()
        searchBar.text = nil

        searchBar.endEditing(true)
        //self.filterTableView(text: "")
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked ")
        
        searchBar.resignFirstResponder()
        searchBar.text = nil

        searchBar.endEditing(true)

        getMovies()
        
    }
    
}
