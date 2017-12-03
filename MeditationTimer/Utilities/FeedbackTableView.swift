//
//  FeedbackTableView.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 03.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class FeedbackTableView: UITableView {

    var viewController: FeedbackTableViewController?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        viewController?.closeKeyboards()
    }

}
