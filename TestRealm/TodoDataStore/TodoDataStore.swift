//
//  TodoDataStore.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/07.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation
import RealmSwift

protocol TodoDataStore {
    func fetchTodo()->Results<TodoModel>?
    func addNewTodo(todo: TodoModel)
    func deleteTodo(todo: TodoModel)
    func clear()
}

class TodoDataStoreImp: TodoDataStore {
    init() {}

    func fetchTodo() -> Results<TodoModel>? {
        do {
            let realm = try Realm()
            return realm.objects(TodoModel.self)
        } catch {
            print(error)
            return nil
        }

    }

    func addNewTodo(todo: TodoModel) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(todo)
            }
        } catch {
            print(error)
        }
    }

    func clear() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }

    func deleteTodo(todo: TodoModel) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            print(error)
        }
    }
}
