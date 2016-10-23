//
//  ViewController.swift
//  Timer
//
//  Created by Lukas Muller on 22/10/2016.
//  Copyright © 2016 Lukas Muller. All rights reserved.
//

import UIKit

class StopViewController: UIViewController {

  var laps: [String] = [] {
    didSet {
      print("Didset")
      tableView.reloadData()
    }
  }
  
  var timer = Timer()
  var minutes = 0
  var seconds = 0
  var fractions = 0
  
  var stopwatchString = ""
  
  var hasStarted = false
  var lappable = false
  
  let clockBg: UIView = {
    let bg = UIView()
    bg.backgroundColor = .white
    return bg
  }()
  
  let timeLabel: UILabel = {
    let timeLabel = UILabel()
    timeLabel.font = .systemFont(ofSize: 64, weight: UIFontWeightThin)
    timeLabel.textColor = .black
    timeLabel.text = "00:00.00"
    return timeLabel
  }()
  
  let lastLapLabel: UILabel = {
    let llLabel = UILabel()
    llLabel.font = .systemFont(ofSize: 18, weight: UIFontWeightRegular)
    llLabel.textColor = .lightGray
    llLabel.text = "00:00.00"
    return llLabel
  }()

  let bgView: UIView = {
    let bg = UIView()
    bg.backgroundColor = .lightGray
    return bg
  }()
  
  let tableView: UITableView = {
    let tv = UITableView(frame: .zero)
    tv.backgroundColor = .lightGray
    tv.separatorColor = .darkGray
    tv.allowsSelection = false
    return tv
  }()
  
  let leftButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .green
    button.frame = CGRect(x: 20, y: 20, width: 80, height: 80)
    button.layer.cornerRadius = button.frame.width / 2
    button.layer.masksToBounds = true

    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Stopwatch"
    
    tableView.dataSource = self
    tableView.register(StopTimeCell.self, forCellReuseIdentifier: StopTimeCell.identifier)
    
    view.backgroundColor = .black
    
    view.addSubview(clockBg)
    clockBg.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)

    clockBg.addSubview(timeLabel)
    timeLabel.frame = clockBg.frame
    clockBg.addSubview(lastLapLabel)
    lastLapLabel.frame = CGRect(x: 0, y: timeLabel.frame.origin.y - 120, width: view.frame.width, height: 400)
    
    view.addSubview(bgView)
    bgView.frame = CGRect(x: 0, y: clockBg.frame.height, width: view.frame.width, height: view.frame.height - clockBg.frame.height)
    
    leftButton.addTarget(self, action: Selector("leftAction:"), for: .touchUpInside)
    bgView.addSubview(leftButton)
    
    let rightButton = UIButton()
    rightButton.backgroundColor = .black
    //    rightButton.isEnabled = false
    rightButton.frame = CGRect(x: view.frame.width - 100, y: 20, width: 80, height: 80)
    rightButton.layer.cornerRadius = rightButton.frame.width / 2
    rightButton.layer.masksToBounds = true
    rightButton.addTarget(self, action: Selector("rightAction:"), for: .touchUpInside)
    bgView.addSubview(rightButton)
    
    bgView.addSubview(tableView)
    tableView.frame = CGRect(x: 0, y: 120, width: view.frame.width, height: view.frame.height - (clockBg.frame.height + 120))
    
  }
  
  func leftAction(_ sender: UIButton) {
    
    if hasStarted == false {
    
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: Selector("updateStopwatch"), userInfo: nil, repeats: true)
    
      hasStarted = true
      
      leftButton.backgroundColor = .red
      
      lappable = true
      
    } else {
      
      timer.invalidate()
      hasStarted = false
      
      leftButton.backgroundColor = .green
      
      lappable = false
      
      
    }
    
  }
  
  func rightAction(_ sender: UIButton) {
    
    if lappable {
      
      laps.insert(stopwatchString, at: 0)
      
      
    } else {
      
      lappable = false
      
      fractions = 0
      seconds = 0
      minutes = 0
      
      stopwatchString = "00:00.00"
      timeLabel.text = stopwatchString
      
      laps.removeAll(keepingCapacity: false)
      
    }
  }
  
  func updateStopwatch() {
    
    fractions += 1
    
    if fractions == 100 {
      seconds += 1
      fractions = 0
    }
    
    if seconds == 60 {
      minutes += 1
      seconds = 0
    }
    
    let fractionsString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
    let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
    let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
    
    stopwatchString = "\(minutesString):\(secondsString).\(fractionsString)"
    timeLabel.text = stopwatchString
    
  }
  
  
}

extension StopViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StopTimeCell.identifier, for: indexPath) as! StopTimeCell
    cell.textLabel?.text = laps[indexPath.row]
    cell.textLabel?.textColor = .black
    cell.backgroundColor = .lightGray
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return laps.count
  }
  
}

class StopTimeCell: UITableViewCell, ReusableIdentifier {
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

protocol ReusableIdentifier {}

extension ReusableIdentifier where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}
