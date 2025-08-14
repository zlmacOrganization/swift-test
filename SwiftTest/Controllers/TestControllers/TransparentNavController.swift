//
//  TransparentNavController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/2/25.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import EventKit

class TransparentNavController: BaseViewController {
    private var tableView: UITableView!
    private var topNavView: BaseNavBarView!
    
    private var collectionView: UICollectionView!
    private let weeks: [String] = ["日", "一", "二", "三", "四", "五", "六"]
    private var days: [String] = []
    
    private var firstDayOfMonth: Int = 1
    private var numberOfTheMonth: Int = 28
    private var month = 12
    private var year = 2021
    private var currentComps: DateComponents!
    
    private let myEventStore = EKEventStore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navTranslucent = true
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight - iphoneXBottomMargin))
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.zl_registerCell(UITableViewCell.self)
        view.addSubview(tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
//        tableView.snp.makeConstraints { (make) in
//            make.top.left.right.equalTo(0)
//            make.bottom.equalTo(-iphoneXBottomMargin)
//        }
        
//        navTopView()
        setupCollectionView()
    }
    
    private func navTopView() {
        topNavView = BaseNavBarView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kNavBarAndStatusBarHeight))
//        topNavView.backgroundColor = UIColor.white
        view.addSubview(topNavView)
    }
    
    private func setupCollectionView() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(previousMonth))
        let rightItem2 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nextMonth))
        navigationItem.rightBarButtonItems = [rightItem, rightItem2]
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: kMainScreenWidth/7, height: 45)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 360), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.zl_registerCell(CalendarCollectionCell.self)
        
        tableView.tableHeaderView = collectionView
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        currentComps = calendar.dateComponents([.year, .month, .day], from: Date())
        month = currentComps.month ?? 12
        year = currentComps.year ?? 2021
        
        firstDayOfMonth = getCountOfDaysInMonth(year: year, month: month).week
        numberOfTheMonth = getCountOfDaysInMonth(year: year, month: month).count
        
        setupDaysOfMonth()
    }
    
    private func transparentNav() {
        title = ""
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func getCountOfDaysInMonth(year: Int, month: Int) -> (count: Int, week: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        guard let date = dateFormatter.date(from: "\(year)-\(month)") else {
            return (0, 0)
        }
        let calendar = Calendar(identifier: .gregorian)
        let range = calendar.range(of: .day, in: .month, for: date)
        let week = calendar.component(.weekday, from: date)
        return (range?.count ?? 0, week)
    }
    
    private func setupDaysOfMonth() {
        days.removeAll()
        
        // 第一天之前的空白区域
        for _ in 0..<firstDayOfMonth - 1 {
            days.append("")
        }
        
        for num in firstDayOfMonth-1...firstDayOfMonth + numberOfTheMonth - 2 {
            days.append("\(num - firstDayOfMonth + 2)")
        }
        
        // 最后一天后的空白区域
        for _ in (firstDayOfMonth + numberOfTheMonth - 2)...41 {
            days.append("")
        }
        
        title = "\(year)-\(month)"
    }
    
    private func defaultNav() {
        title = "柳州二号"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    @objc private func previousMonth() {
        if month == 12 {
            year += 1
            month = 1
        }else {
            month += 1
        }
        
        firstDayOfMonth = getCountOfDaysInMonth(year: year, month: month).week
        numberOfTheMonth = getCountOfDaysInMonth(year: year, month: month).count
        
        setupDaysOfMonth()
        collectionView.reloadData()
    }
    
    @objc private func nextMonth() {
        if month == 1 {
            year -= 1
            month = 12
        }else {
            month -= 1
        }
        
        firstDayOfMonth = getCountOfDaysInMonth(year: year, month: month).week
        numberOfTheMonth = getCountOfDaysInMonth(year: year, month: month).count
        
        setupDaysOfMonth()
        collectionView.reloadData()
    }
    
    @objc private func backAction() {
        back()
    }
}

extension TransparentNavController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "item \(indexPath.row)"
//        cell.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        
        return cell
    }
}

extension TransparentNavController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return weeks.count
        }
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zl_dequeueReusableCell(CalendarCollectionCell.self, indexPath: indexPath)
        
        if indexPath.section == 0 {
            cell.titleLabel.text = weeks[indexPath.row]
        }else {
            if indexPath.row < days.count {
                let day = days[indexPath.row]
                cell.titleLabel.text = day
                
                if currentComps.month ?? 0 == month && String(currentComps.day ?? 0) == day {
                    cell.titleLabel.textColor = UIColor.white
                    cell.titleLabel.backgroundColor = UIColor.purple
                }else {
                    cell.titleLabel.textColor = UIColor.darkGray
                    cell.titleLabel.backgroundColor = UIColor.white
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        calendarAuthority(.event)
//        calendarAuthority(.reminder)
//        removeCalendarEvent()
    }
}

extension TransparentNavController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let alpha = offsetY/64
//
//        topNavView.backgroundColor = UIColor(white: 1, alpha: alpha)
//
//        if alpha < 1 {
//            topNavView.titleLabel.text = ""
//        }else {
//            topNavView.titleLabel.text = "柳州二号"
//        }
        
        
//        let maxOffset: CGFloat = 64
//        let alpha = 1 - (maxOffset - offsetY)/maxOffset
//
//        navigationController?.navigationBar.shadowImage = UIImage()
//
//        navigationController?.navigationBar.setBackgroundImage(CommonFunction.pureImageWith(color: UIColor.white.withAlphaComponent(alpha)), for: .default)
//
//        if alpha < 1 {
//            title = ""
//        }else {
//            title = "柳州二号"
//        }
    }
    
    private func calendarAuthority(_ type: EKEntityType) {
        let status = EKEventStore.authorizationStatus(for: type)
        if status == .notDetermined {
            myEventStore.requestAccess(to: type) { allow, error in
                if allow {
                    print("allowed ++++")
                    if type == .event {
                        self.addEventAlarm()
                    }else {
                        self.addEventReminder()
                    }
                }else {
                    print("denied ++++")
                }
            }
        }else if status == .denied {
            CommonFunction.showAlertController(title: "未开启日历/提醒访问权限", message: nil, controller: self, cancelAction: nil, sureAction: nil, isShowCancel: false)
        }else {
            if type == .event {
                addEventAlarm()
            }else {
                addEventReminder()
            }
        }
    }
    
    private func checkEvent() {
//        let calendar = Calendar.current
//        var oneDayAgoComponents = DateComponents()
//        oneDayAgoComponents.day = -1
//        let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date())
//
//        var oneMonthFromNowComponents = DateComponents()
//        oneMonthFromNowComponents.month = 1
//
//        let oneMonthFromNow = calendar.date(byAdding: oneMonthFromNowComponents, to: Date())
//        let predicate = myEventStore.predicateForEvents(withStart: oneDayAgo, end: oneMonthFromNow, calendars: <#T##[EKCalendar]?#>)
    }
    
    private func addEventAlarm() {
        let event = EKEvent(eventStore: self.myEventStore)
        event.title = "test title"
        event.location = "event location"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = formatter.date(from: "2021-10-28 15:15:00")
        let startDate = Date(timeInterval: -60, since: date!)
        let endDate = Date(timeInterval: 60, since: date!)
        
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = false
        
        let elarm2 = EKAlarm(relativeOffset: -20)
        event.addAlarm(elarm2)
//        let elarm = EKAlarm(relativeOffset: -10)
//        event.addAlarm(elarm)
        
        event.calendar = self.myEventStore.defaultCalendarForNewEvents
        
        do {
            try self.myEventStore.save(event, span: .thisEvent)
            ZLUserDefaultManager.setLocalDataString(value: event.eventIdentifier, key: "my_eventIdentifier")
        } catch  {
            print("save event failed ++++")
        }
    }
    
    private func addEventReminder() {
        let event = EKEvent(eventStore: myEventStore)
        event.title = "reminder title"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = formatter.date(from: "2021-10-28 16:05:00")
        let startDate = Date(timeInterval: -60, since: date!)
        let endDate = Date(timeInterval: 60, since: date!)
        
        event.startDate = startDate
        event.endDate = endDate
        event.addAlarm(EKAlarm(absoluteDate: date!))
        event.calendar = myEventStore.defaultCalendarForNewEvents
        
        do {
            try self.myEventStore.save(event, span: .thisEvent)
            ZLUserDefaultManager.setLocalDataString(value: event.eventIdentifier, key: "my_eventIdentifier")
        } catch  {
            print("save event failed ++++")
        }
        
        let reminder = EKReminder(eventStore: myEventStore)
        reminder.title = "reminder title"
        reminder.calendar = myEventStore.defaultCalendarForNewReminders()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dateComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        dateComp.timeZone = TimeZone.current
        
        reminder.startDateComponents = dateComp
        reminder.dueDateComponents = dateComp
        reminder.priority = 1
        
        let elarm = EKAlarm(absoluteDate: date!)
        reminder.addAlarm(elarm)
        
        do {
            try myEventStore.save(reminder, commit: true)
        } catch  {
            print("save reminder failed ++++")
        }
        
        //添加重复
//        EKRecurrenceRule
    }
    
    private func removeCalendarEvent() {
        guard let event = myEventStore.event(withIdentifier: ZLUserDefaultManager.getLocalString(key: "my_eventIdentifier")) else {
            return
        }
//        let event = EKEvent(eventStore: myEventStore)
        do {
            try myEventStore.remove(event, span: .thisEvent, commit: true)
        } catch  {
            print("remove event failed ++++")
        }
    }
}

class CalendarCollectionCell: UICollectionViewCell {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.darkGray, textAlignment: .center)
        titleLabel.layer.cornerRadius = 15
        titleLabel.clipsToBounds = true
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
}
