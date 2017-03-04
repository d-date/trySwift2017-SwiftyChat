//
//  UIView+Extension.swift
//  TrySwift2017ChatApp
//
//  Created by 田中賢治 on 2017/03/04.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit

extension UIView {
    func adjustConstraints(to view: UIView, attributes: (top: CGFloat, trailing: CGFloat, leading: CGFloat, bottom: CGFloat) = (0, 0, 0, 0)) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(
                item: self, attribute: .top, relatedBy: .equal,
                toItem: view, attribute: .top, multiplier: 1.0,
                constant: attributes.top
            ),
            NSLayoutConstraint(
                item: self, attribute: .trailing, relatedBy: .equal,
                toItem: view, attribute: .trailing, multiplier: 1.0,
                constant: attributes.trailing
            ),
            NSLayoutConstraint(
                item: self, attribute: .leading, relatedBy: .equal,
                toItem: view, attribute: .leading, multiplier: 1.0,
                constant: attributes.leading
            ),
            NSLayoutConstraint(
                item: self, attribute: .bottom, relatedBy: .equal,
                toItem: view, attribute: .bottom, multiplier: 1.0,
                constant: attributes.bottom
            )
        ]
    }
}
