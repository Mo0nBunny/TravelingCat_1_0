//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Sirin on 10/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
   
        
    @IBOutlet weak var todayTableView: UITableView!
    
    var coreDataStack = CoreDataStack()
    var todayTripArray = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayTableView.delegate = self
        todayTableView.dataSource = self
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0, height: 280)
        } else {
            preferredContentSize = maxSize
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayTripArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WidgetTableViewCell
        let todayTrip = todayTripArray[indexPath.row]
        cell.tripWidgetLabel.text = todayTrip.tripTitle
        cell.dateWidgetLabel.text = todayTrip.tripDate
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        try? fetchData()
    }
    
    func fetchData() throws {
        let context = coreDataStack.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        print(calendar.timeZone)
        let dateFrom = calendar.startOfDay(for: Date())
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)!
        
        let datePredicate = NSPredicate(format: "(%@ <= tripRemind) AND (tripRemind < %@)", argumentArray: [dateFrom, dateTo])
        request.predicate = datePredicate
        print ("now \(Date())")
        
        do {
            
            let results = try context.fetch(request)
            todayTripArray = results as! [Trip]
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
        
//        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//        let todayPredicate =  predicateForToday()
//        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [todayPredicate, predicateNotCompleted()])
//        let dueDateSort = NSSortDescriptor(key: #keyPath(Task.dueDate), ascending: true)
//        let titleSort = NSSortDescriptor(key: #keyPath(Task.title), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
//        fetchRequest.sortDescriptors = [dueDateSort, titleSort]
//        do {
//            todayTasks = try coreDataStack.managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            os_log("Error when fetch from coreData from Widget: %@", error.debugDescription)
//            throw error
//        }
    }
    
    //    private func predicateForToday() -> NSPredicate {
    //        let now = Date()
    //        let startOfDay = now.startOfDay as NSDate
    //        let endOfDay = now.endOfDay as NSDate
    //        return NSPredicate(format: "dueDate >= %@ AND dueDate <= %@ ", startOfDay, endOfDay)
    //    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        do {
            try fetchData()
        } catch {
            completionHandler(NCUpdateResult.failed)
            return
        }
        guard !todayTripArray.isEmpty else {
            completionHandler(NCUpdateResult.noData)
            return
        }
        todayTableView.reloadData()
        completionHandler(NCUpdateResult.newData)
    }
    
}
