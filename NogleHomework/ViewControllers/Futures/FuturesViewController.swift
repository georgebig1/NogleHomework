//
//  FuturesViewController.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/1.
//

import UIKit
import RxCocoa
import RxSwift

class FuturesViewController: UIViewController {
    static func create() -> FuturesViewController {
        return FuturesViewController()
    }
    
    let vm = FutureViewModel()
    let disposeBag = DisposeBag()
    
    lazy var btnName: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Name", for: .normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    lazy var btnPrice: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Price", for: .normal)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .clear
        v.separatorStyle = .none
        v.showsVerticalScrollIndicator = false
        v.delegate = self
        v.dataSource = self
        v.register(MarketListCell.self, forCellReuseIdentifier: String(describing: MarketListCell.self))
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initBinding()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(btnName)
        btnName.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.centerX)
            make.height.equalTo(30)
        }
        
        view.addSubview(btnPrice)
        btnPrice.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp.centerX)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(btnName.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func initBinding() {
        vm.futuresList.subscribeSuccess {[weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        btnName.rx.tap.subscribeSuccess {[weak self] _ in
            self?.vm.toggleNameSorting()
        }.disposed(by: disposeBag)
        
        btnPrice.rx.tap.subscribeSuccess {[weak self] _ in
            self?.vm.togglePriceSorting()
        }.disposed(by: disposeBag)
    }
}

extension FuturesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.futuresList.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = vm.futuresList.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MarketListCell.self), for: indexPath) as! MarketListCell
        cell.config(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
