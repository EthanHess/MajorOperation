//
//  PhotoListViewController.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/22/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit
import CoreImage

class PhotoListViewController: UITableViewController {
    
    let dataSourceURL = URL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")
    
    var photos = [PhotoRecord]()
    let pendingOperations = PendingOperations()
    
    var imageToPass : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(PhotoCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Photos"
        fetchData()
    }
    
    fileprivate func fetchData() {
        PhotoFetcher.sharedManager.fetchPhotos(theURL: dataSourceURL!) { (photos) in
            if photos.count > 0 {
                self.photos = photos
                self .refreshTable()
            } else {
                print("No photos!")
            }
        }
    }
    
    fileprivate func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PhotoCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoCell
        // Configure the cell...
        
        cell.viewSetup()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.center = cell.contentView.center
        cell.contentView.addSubview(indicator)
        
        //Check count?
        let photoDetails = photos[indexPath.row]

        cell.theLabel.text = photoDetails.name
        cell.theImageView.image = photoDetails.image
        
        switch photoDetails.state {
        case .Filtered:
            indicator.stopAnimating()
        case .Failed:
            indicator.stopAnimating()
            cell.theLabel.text = "Failed to load"
        case .New, .Downloaded:
            indicator.startAnimating()
            if !tableView.isDragging && !tableView.isDecelerating {
                //start operations
                startOperationsForPhotoRecord(photoDetails: photoDetails, indexPath: indexPath)
            }
        }
        
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //go to detail, these images are cool
        let photoRecord = photos[indexPath.row]
        guard let theImage = photoRecord.image else { return }
        imageToPass = theImage
        pushToDetail()
    }
    
    fileprivate func pushToDetail() {
        let detailVC = PhotoDetailViewController()
        detailVC.theImage = self.imageToPass!
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PhotoListViewController {
    
    fileprivate func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
        pendingOperations.filtrationQueue.isSuspended = true
    }
    
    fileprivate func resumeAllOperations () {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filtrationQueue.isSuspended = false
    }
    
    fileprivate func loadImagesForOnscreenCells () {
        
        if let pathArray = tableView.indexPathsForVisibleRows {
            
            let pendingOps = Set(pendingOperations.downloadsInProgress.keys).union(pendingOperations.filtrationInProgress.keys)
            
            var toBeCancelled = pendingOps
            let visiblePaths = Set(pathArray)
            toBeCancelled.subtract(visiblePaths)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtract(pendingOps)
            
            //iteration
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                
                if let filtration = pendingOperations.filtrationInProgress[indexPath] {
                    filtration.cancel()
                }
                pendingOperations.filtrationInProgress.removeValue(forKey: indexPath)
            }
            
            for indexPath in toBeStarted {
                let recordToProcess = self.photos[indexPath.row]
                startOperationsForPhotoRecord(photoDetails: recordToProcess, indexPath: indexPath)
            }
        }
    }
    
    fileprivate func startOperationsForPhotoRecord(photoDetails: PhotoRecord, indexPath: IndexPath) {
        switch photoDetails.state {
        case .New:
            startDownloadForRecord(photoDetails: photoDetails, indexPath: indexPath)
        case .Downloaded:
            startFiltrationForRecord(photoDetails: photoDetails, indexPath: indexPath)
        default:
            NSLog("-- Do nothing --")
        }
    }
    
    fileprivate func startDownloadForRecord(photoDetails: PhotoRecord, indexPath: IndexPath) {
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            print(downloadOperation)
            return //if it's already there return
        }
        
        let downloader = ImageDownloader(photoRecord: photoDetails)
        
        downloader.completionBlock = {
            if downloader.isCancelled == true {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    fileprivate func startFiltrationForRecord(photoDetails: PhotoRecord, indexPath: IndexPath) {
        if let filterOperation = pendingOperations.filtrationInProgress[indexPath] {
            print(filterOperation)
            return
        }
        
        let filterer = Filter(photoRecord: photoDetails)
        filterer.completionBlock = {
            if filterer.isCancelled == true {
                return
            }
            DispatchQueue.main.async { //execute?
                self.pendingOperations.filtrationInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        pendingOperations.filtrationInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
}
