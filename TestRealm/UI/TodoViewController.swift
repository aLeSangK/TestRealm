//
//  TodoViewController.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/05/30.
//  Copyright © 2020 楽桑. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class TodoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!

    private let disposeBag = DisposeBag()

    var viewModel: TodoViewModel?

    var itemList: Observable<[String]>?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.navigation
            .observeOn(MainScheduler.init())
            .subscribe(onNext: { [weak self] event in
                switch event {
                case let event  as TodoViewModel.FetchTodosSuccess:
                    self?.initializeTable(event: event)
                case _ as TodoViewModel.ReloadTable:
                    self?.viewModel?.handleTodoAction(action: .fetch, parameter: nil)
                case _ as TodoViewModel.ResetTextField:
                    self?.textField.text = ""
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        addButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let text = self?.textField.text else {
                    return
                }
                self?.viewModel?.handleTodoAction(action: .add, parameter: text)
            })
            .disposed(by: disposeBag)

        deleteButton.rx.tap
            .subscribe(onNext: {[weak self]_ in
                self?.viewModel?.handleTodoAction(action: .clear, parameter: nil)
            })
            .disposed(by: disposeBag)

        scanButton.rx.tap
            .subscribe(onNext: {[weak self]_ in
                let QRScanner = self?.storyboard?.instantiateViewController(withIdentifier: "QRScannerController")
                QRScanner?.modalPresentationStyle = .fullScreen
                self?.present(QRScanner!, animated: true, completion: nil)            })
            .disposed(by: disposeBag)

        table.rx.itemDeleted
            .subscribe(onNext: {[weak self] in
                self?.viewModel?.handleTodoAction(action: .delete, parameter: $0.row)
            })
            .disposed(by: disposeBag)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.handleTodoAction(action: .fetch, parameter: nil)
    }

    func initializeTable(event: TodoViewModel.FetchTodosSuccess ) {
        self.itemList = Observable.from(optional: event.todos)
        self.itemList?.bind(to: table.rx.items(cellIdentifier: "lastCell")) { _, element, cell in
            cell.textLabel?.text = element
        }
        .disposed(by: disposeBag)
    }
}
