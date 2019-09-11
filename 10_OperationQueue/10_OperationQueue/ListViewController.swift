/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreImage

let dataSourceURL = URL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")!

class ListViewController: UITableViewController {
    var photoRecords: [PhotoRecord] = []
    
    lazy var photoDownloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.shuyu.operationQueueDemo.photoDownloadQueue"
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    lazy var photoFilterQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.shuyu.operationQueueDemo.photoFilterQueue"
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    lazy var downloadingOperationDic: Dictionary<IndexPath, Operation> = {
        return Dictionary<IndexPath, Operation>()
    }()
    
    lazy var filteringOprationDic: Dictionary<IndexPath, Operation> = {
        return Dictionary<IndexPath, Operation>()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Classic Photos"
        fetchPhotoDataSource()
    }
    
    private func fetchPhotoDataSource() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let photos = NSDictionary(contentsOf: dataSourceURL) {
                self?.photoRecords = []
                for photo in photos.enumerated() {
                    if let url = URL(string: photo.element.value as! String) {
                        self?.photoRecords.append(PhotoRecord(url: url, name: photo.element.key as! String))
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return photoRecords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let photoRecord = self.photoRecords[indexPath.row]
        cell.textLabel?.text = photoRecord.name
        cell.imageView?.image = photoRecord.image
        if (!self.tableView.isDragging && !self.tableView.isDecelerating) {
            takeOperation(photoRecord: photoRecord, for: cell, at: indexPath)
        }
        return cell
    }
    

    private func takeOperation(photoRecord: PhotoRecord, for cell:UITableViewCell, at indexPath: IndexPath) {
        cell.accessoryView = UIActivityIndicatorView(style: .gray)
        let loadingIndicator = cell.accessoryView as! UIActivityIndicatorView
        loadingIndicator.startAnimating()
        
        switch photoRecord.status {
        case .Initiated:
            if let _ = self.downloadingOperationDic[indexPath] {
                break
            }
            let downloadOperation = ImageDownloadOperation(photoRecord)
            downloadOperation.completionBlock = { [weak self] in
                DispatchQueue.main.async {
                    self?.downloadingOperationDic.removeValue(forKey: indexPath)
                    self?.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            self.photoDownloadQueue.addOperation(downloadOperation)
            self.downloadingOperationDic[indexPath] = downloadOperation
            break
            
        case .Downloaded:
            if let _ = self.filteringOprationDic[indexPath] {
                break
            }
            let filterOperation = ImageFilterOperation(photoRecord)
            filterOperation.completionBlock = { [weak self] in
                DispatchQueue.main.async {
                    self?.filteringOprationDic.removeValue(forKey: indexPath)
                    self?.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            self.photoFilterQueue.addOperation(filterOperation)
            self.filteringOprationDic[indexPath] = filterOperation
            break
            
        case .Filtered:
            loadingIndicator.stopAnimating()
            cell.accessoryView = nil
            break
            
        default:
            loadingIndicator.stopAnimating()
            cell.accessoryView = nil
            break
        }
    }
}

extension ListViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperation()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        takeOprationForVisibleRowsInOneScreen()
        resumeAllOperation()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        takeOprationForVisibleRowsInOneScreen()
        resumeAllOperation()
    }
    
    private func suspendAllOperation() {
        self.photoDownloadQueue.isSuspended = true
        self.photoFilterQueue.isSuspended = true
    }
    
    private func resumeAllOperation() {
        self.photoDownloadQueue.isSuspended = false
        self.photoFilterQueue.isSuspended = false
    }
    
    private func takeOprationForVisibleRowsInOneScreen() {
        let visibleIndexPaths = self.tableView.indexPathsForVisibleRows ?? [IndexPath]()
        let downloadingIndexPaths:[IndexPath] = Array(self.downloadingOperationDic.keys)
        let filteringIndexPaths:[IndexPath] = Array(self.filteringOprationDic.keys)
        
        let allInprogressIndexPathsSet = Set(downloadingIndexPaths + filteringIndexPaths)
        var toStartedIndexPathsSet = Set(visibleIndexPaths)
        var toCancelIndexPathsSet = allInprogressIndexPathsSet
        
        toCancelIndexPathsSet = toCancelIndexPathsSet.subtracting(toStartedIndexPathsSet)
        toStartedIndexPathsSet = toStartedIndexPathsSet.subtracting(allInprogressIndexPathsSet)
        
        for indexPath in toCancelIndexPathsSet {
            if let downloadOperation = self.downloadingOperationDic[indexPath] {
                downloadOperation.cancel()
                self.downloadingOperationDic.removeValue(forKey: indexPath)
            }
            
            if let filterOperation = self.filteringOprationDic[indexPath] {
                filterOperation.cancel()
                self.filteringOprationDic.removeValue(forKey: indexPath)
            }
        }
        
        for indexpath in toStartedIndexPathsSet {
            let photoRecord = self.photoRecords[indexpath.row]
            let cell = self.tableView.cellForRow(at: indexpath)
            takeOperation(photoRecord: photoRecord, for: cell!, at: indexpath)
        }
    }
}
