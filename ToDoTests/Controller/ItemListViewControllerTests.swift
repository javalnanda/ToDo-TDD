//
//  ItemListViewControllerTests.swift
//  ToDoTests
//
//  Created by Javal Nanda on 30/09/17.
//  Copyright © 2017 Equal experts. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    var sut: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ItemListViewController")
        sut = viewController as! ItemListViewController
        _ = sut.view
        
    }
    
    override func tearDown() {
//        sut.itemManager.removeAll()
        super.tearDown()
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_LoadingView_SetsTableViewDataSource() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ItemListViewController")
        let sut = viewController as! ItemListViewController
        
        
        _ = sut.view
        
        
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsTableViewDelegate() {
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsDataSourceAndDelegateToSameObject() {
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                       sut.tableView.delegate as? ItemListDataProvider)
    }
    
    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
    }
    
    func test_AddItem_PresentsAddItemViewController() {
        
        performAddItemAction()
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputViewController =
            sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC() {
        
        performAddItemAction()
        
        guard let inputViewController =
            sut.presentedViewController as? InputViewController else
        { XCTFail(); return }
        guard let inputItemManager = inputViewController.itemManager else
        { XCTFail(); return }
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func test_ViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func test_tableView_IsReloaded_WhenItemIsAdded() {
        
        let mockTableView = MockTable()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue(mockTableView.reloadDataCalled)
        
    }
    
    func testItemSelectedNotification_PushesDetailVC() {

        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        _ = sut.view

        sut.itemManager.add(ToDoItem(title: "Foo"))
        sut.itemManager.add(ToDoItem(title: "Bar"))
        
        NotificationCenter.default.post(
            name: NSNotification.Name("ItemSelectedNotification"),
            object: self,
            userInfo: ["index": 1])

        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else { XCTFail(); return }
        guard let detailItemManager = detailViewController.itemInfo?.0 else
        { XCTFail(); return }
        guard let index = detailViewController.itemInfo?.1 else
        { XCTFail(); return }
        _ = detailViewController.view

        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
    }
    
    func performAddItemAction() {
        guard let addButton = sut.navigationItem.rightBarButtonItem else
        { XCTFail(); return }
        guard let action = addButton.action else { XCTFail(); return }
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        
        sut.performSelector(onMainThread: action,
                            with: addButton,
                            waitUntilDone: true)
        
    }
    
    
}

extension ItemListViewControllerTests {
    class MockTable: UITableView {
        var reloadDataCalled = false
        override func reloadData() {
            reloadDataCalled = true
        }
    }
    class MockNavigationController : UINavigationController {
        
        var pushedViewController: UIViewController?
        override func pushViewController(_ viewController: UIViewController,
                                         animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
