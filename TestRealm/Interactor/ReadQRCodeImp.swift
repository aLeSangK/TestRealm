//
//  ReadQRCodeImp.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

class ReadQRCodeImp: ReadQRCode {
    private let repository: ReadQRCodeRepository
    private var presenter: ReadQRCodePresenter?

    init(repository: ReadQRCodeRepository) {
        self.repository=repository
    }

    func startReadQRResult(readQRResult: ReadQRResult) {
        repository.addNewTodo(result: readQRResult)
        presenter?.notifyQRCodeResult(code: readQRResult.resultCode)
    }

    func setPresenter(presenter: ReadQRCodePresenter) {
        self.presenter=presenter
    }

}
