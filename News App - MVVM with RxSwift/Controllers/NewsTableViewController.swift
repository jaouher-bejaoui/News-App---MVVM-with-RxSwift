//
//  NewsTableViewController.swift
//  News App - MVVM with RxSwift
//
//  Created by Jaouher Bejaoui  on 26/7/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class NewsTableViewController : UITableViewController{
    
    let disposeBag = DisposeBag()
    
    private var articleListViewModel : ArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
     
        populateNews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.articleListViewModel == nil ? 0:self.articleListViewModel.articlesVM.count
    }
    
    
    private func populateNews(){
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=3e6043b17c8f4a75b9293ba3dc7708da")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext:{ articleResponse in
                
                let articles = articleResponse.articles
                self.articleListViewModel = ArticleListViewModel(articles)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for :indexPath) as? ArticleTableViewCell else{
            fatalError("ArticleTableViewCell in not found" )
        }
        
        let articleVM = self.articleListViewModel.articleAt(indexPath.row)
        
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    
        
        return cell
    }
}
