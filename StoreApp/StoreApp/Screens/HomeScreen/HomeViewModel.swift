//
//  HomeViewModel.swift
//  StoreApp
//
//  Created by Giri on 4/19/25.
//


import Foundation


enum SortType {
    case lowToHigh
    case highToLow
}


class HomeViewModel: NSObject {
    var reloadTable: (() -> Void)?
    var showLoader: (() -> Void)?
    var hideLoader: (() -> Void)?
    
    var datalist: [Datalist] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadTable?()
                self.hideLoader?()
            }
        }
    }

    var allDatalist: [Datalist] = []
    private var pageSize = 10
    private var currentPage = 0

    func apiCall() {
        showLoader?()
        NetworkManager(url: Apis.homeUrl, method: .get, isJSONRequest: false).executeQuery { (result: Result<[Datalist], Error>) in
            switch result {
            case .success(let response):
                if !response.isEmpty {
                    self.allDatalist = response
                    self.currentPage = 0
                    let end = min(self.pageSize, response.count)
                    self.datalist = Array(response[0..<end])
                } else {
                    self.allDatalist = []
                    self.datalist = []
                    DispatchQueue.main.async {
                        self.hideLoader?()
                    }
                }
            case .failure(let error):
                print("API Error: \(error)")
                DispatchQueue.main.async {
                    self.hideLoader?()
                }
            }
        }
    }

    func loadMoreData(currentIndex: Int) {
        let thresholdIndex = datalist.count - 5
        guard currentIndex == thresholdIndex else { return }

        let nextPage = currentPage + 1
        let start = nextPage * pageSize
        let end = min(start + pageSize, allDatalist.count)

        guard start < allDatalist.count else { return }

        let moreItems = Array(allDatalist[start..<end])
        datalist.append(contentsOf: moreItems)
        currentPage = nextPage
    }
    
    func sortData(by sortType: SortType) {
        switch sortType {
        case .lowToHigh:
            datalist = datalist.sorted { ($0.price ?? 0.0) < ($1.price ?? 0.0) }
        case .highToLow:
            datalist = datalist.sorted { ($0.price ?? 0.0) > ($1.price ?? 0.0) }
        }
    }

}
