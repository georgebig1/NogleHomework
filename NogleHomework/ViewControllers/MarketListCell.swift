//
//  MarketListCell.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import UIKit
import RxCocoa
import RxSwift

class MarketListCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    private var item: Record!
    private var vm: MarketListCellViewModel!
    
    lazy var lblName: UILabel = {
        return UILabel()
    }()
    
    lazy var lblPrice: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        return l
    }()
    
    lazy var line: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(item: Record) {
        self.item = item
        vm = MarketListCellViewModel(symbol: item.symbol)
        
        lblName.text = item.symbol
        
        let price = item.price ?? 0
        lblPrice.text = price > 0 ? "\(price)" : ""
        
        initBinding()
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(lblName)
        self.contentView.addSubview(lblPrice)
        self.contentView.addSubview(line)
        
        lblName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(lblPrice.snp.left).offset(-20)
        }
        
        lblPrice.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalTo(lblName)
            make.trailing.equalTo(lblPrice)
            make.height.equalTo(1)
        }
    }
    
    func initBinding() {
        vm.price.subscribeSuccess {[weak self] price in
            self?.lblPrice.text = price > 0 ? "\(price)" : ""
        }.disposed(by: disposeBag)
    }
}
