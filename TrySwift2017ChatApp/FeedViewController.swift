//
//  ViewController.swift
//  TrySwift2017ChatApp
//
//  Created by 田中賢治 on 2017/03/04.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit
import PagingMenuController

class FeedViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    var pagingMenuController: PagingMenuController?
    
    private var menuItems: [MenuItemViewCustomizable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Feed"
        
        setupPagingMenuController(feeds: ["Twitter", "Slack", "Messenger"])
    }
}

// MARK: - PagingMenuController
extension FeedViewController {
    fileprivate func setupPagingMenuController(feeds: [String]) {
        
        var menus: [MenuItemViewCustomizable] = []
        
        // FIXME: ホームだけ別扱いで処理しているので後で直す
        let homeTimelineMenu = createMenuItem(title: "All")
        menus.append(homeTimelineMenu)
        
        for feed in feeds {
            let menuItem = createMenuItem(title: feed)
            menus.append(menuItem)
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            let menus: [MenuItemViewCustomizable]
            
            init(menus: [MenuItemViewCustomizable]) {
                self.menus = menus
            }
            
            var height: CGFloat {
                return 44
            }
            
            var displayMode: MenuDisplayMode {
                let width = UIScreen.main.bounds.size.width / 4
                
                return .infinite(widthMode: .fixed(width: width), scrollingMode: .scrollEnabled)
            }
            
            var focusMode: MenuFocusMode {
                return .underline(height: 4, color: UIColor.red, horizontalPadding: 0, verticalPadding: 0)
            }
            
            var itemsOptions: [MenuItemViewCustomizable] {
                return menus
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            var menus: [MenuItemViewCustomizable] = []
            
            init(menus: [MenuItemViewCustomizable]) {
                self.menus = menus
            }
            
            var componentType: ComponentType {
                return .all(menuOptions: MenuOptions(menus: menus), pagingControllers: viewControllers)
            }
            
            var viewControllers: [UIViewController] = []
        }
        
        var options = PagingMenuOptions(menus: menus)
        
        var vcs: [UIViewController] = []
        
        let tapCellAction = { [unowned self] in
            let roomVC = RoomViewController()
            self.navigationController?.pushViewController(roomVC, animated: true)
        }
        
        // FIXME: Allだけ別扱いで処理しているので後で直す
        let allVC = UIStoryboard(name: "FeedList", bundle: nil).instantiateInitialViewController()! as! FeedListViewController
        allVC.tapCellAction = tapCellAction
        vcs.append(allVC)
        
        for i in 1...feeds.count {
            let feedListVC = UIStoryboard(name: "FeedList", bundle: nil).instantiateInitialViewController()! as! FeedListViewController
            feedListVC.tapCellAction = tapCellAction
            vcs.append(feedListVC)
        }
        
        options.viewControllers = vcs
        
        pagingMenuController = PagingMenuController(options: options)
//        pagingMenuController?.onMove = { [weak self] state in
//            guard let weakSelf = self else { return }
//            
//            switch state {
//            case let .didMoveController(menuController, _):
//                ()
//            default:
//                ()
//            }
//        }
        
        pagingMenuController?.menuView?.layer.borderWidth = 1.0
        pagingMenuController?.menuView?.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        addChildViewController(pagingMenuController!)
        containerView.addSubview(pagingMenuController!.view)
        pagingMenuController!.didMove(toParentViewController: self)
        
        pagingMenuController!.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = pagingMenuController!.view.adjustConstraints(to: containerView)
        containerView.addConstraints(constraints)
    }
    
    private func createMenuItem(title: String) -> MenuItemViewCustomizable {
        struct MenuItem: MenuItemViewCustomizable {
            let title: String
            
            init(title: String) {
                self.title = title
            }
            
            var displayMode: MenuItemDisplayMode {
                return .text(title: MenuItemText(
                    text: title,
                    color: UIColor.black,
                    selectedColor: UIColor.red,
                    font: UIFont.systemFont(ofSize: 12),
                    selectedFont: UIFont.systemFont(ofSize: 14))
                )
            }
        }
        
        let menuItem = MenuItem(title: title)
        return menuItem
    }
}

