//
//  HomeViewController.swift
//  StoreApp
//
//  Created by Giri on 4/18/25.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var popLbl: UILabel!
    @IBOutlet weak var sortlbl: UILabel!
    
    var viewModel = HomeViewModel()
    let loader = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSeaechbar()
        setupUI()
        setupLoader()
        loder()
        viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.cardCollectionView.reloadData()
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loader.startAnimating()
        viewModel.apiCall()
    }
    private func setupUI() {
        popLbl.text = Strings.popular
        sortlbl.text = Strings.sort
        popLbl.font = InterFont.interBold(size: 22)
        sortlbl.font = InterFont.interLight(size: 10)
        
    }
    private func setupCollectionView() {
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        cardCollectionView.collectionViewLayout = layout
    }
    
    private func setupSeaechbar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = adapted(dimensionSize: 1)
        searchView.layer.cornerRadius = adapted(dimensionSize: 10)
        searchTextfield.delegate = self
        searchTextfield.font = InterFont.interRegular(size: 16)
        searchImg.tintColor = UIColor.gray
        let tab = UITapGestureRecognizer(target: self, action: #selector(clear(tab:)))
        searchImg.isUserInteractionEnabled = true
        searchImg.addGestureRecognizer(tab)
        searchImg.image = UIImage(systemName: "magnifyingglass")
        searchTextfield.placeholder = Strings.search
    }
    
    @objc func clear(tab: UITapGestureRecognizer)
    {
        if searchImg.image == UIImage(systemName: "xmark.circle.fill") {
            searchTextfield.text = ""
            viewModel.datalist = viewModel.allDatalist
            searchImg.image = UIImage(systemName: "magnifyingglass")
        }
        
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let alert = UIAlertController(title: Strings.sort, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Strings.lowToHigh, style: .default, handler: { _ in
            self.viewModel.sortData(by: .lowToHigh)
        }))
        
        alert.addAction(UIAlertAction(title: Strings.highToLow, style: .default, handler: { _ in
            self.viewModel.sortData(by: .highToLow)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupLoader() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.bringSubviewToFront(loader)
    }
    
    private func loder() {
        viewModel.showLoader = { [weak self] in
            DispatchQueue.main.async {
                self?.loader.startAnimating()
            }
        }
        
        viewModel.hideLoader = { [weak self] in
            DispatchQueue.main.async {
                self?.loader.stopAnimating()
            }
        }
    }
    
}


extension HomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = searchTextfield.text as NSString? else { return true }
        let searchText = currentText.replacingCharacters(in: range, with: string)
        
        if !searchText.isEmpty {
            searchImg.image = UIImage(systemName: "xmark.circle.fill")
            cardCollectionView.isHidden = false
            viewModel.datalist = viewModel.allDatalist.filter { data in
                guard let title = data.title else { return false }
                return title.range(of: searchText, options: .caseInsensitive) != nil
            }
            
        } else {
            viewModel.datalist = viewModel.allDatalist
        }
        
        viewModel.reloadTable?()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchView.layer.borderColor = UIColor.black.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchView.layer.borderColor = UIColor.lightGray.cgColor
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datalist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        let item = viewModel.datalist[indexPath.row]
        cell.cardImage.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "blur"))
        cell.title.text = item.title ?? "No Title"
        cell.price.text = "$\(item.price ?? 0.0)"
        viewModel.loadMoreData(currentIndex: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigatToDetail(viewModel.datalist[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 10
        let width = (collectionView.bounds.width - spacing) / 2
        return CGSize(width: width, height: adapted(dimensionSize: 280))
    }
    
    func navigatToDetail(_ data: Datalist) {
        let vc = storyboard?.instantiateViewController(identifier: Screens.detail) as! DescriptionViewController
        vc.data = data
        self.present(vc, animated: true)
    }
    
    
}
