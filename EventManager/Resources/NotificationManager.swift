//
//  NotificationManager.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
    
    override init() {
        super.init()
        requestPermission()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("we have permission to send notifications")
                UNUserNotificationCenter.current().delegate = self
            } else if let error = error {
                print("error obtaining permissions: \(error)")
            }
        }
    }
    
    // MARK: - Add/Remove Notifications
    
    static func addNotification(for event: Event, at eventNotificationTime: EventNotificationTime) {
        guard let notificationDate = eventNotificationTime.notificationDate(for: event) else { return }
        
        let notificationId = eventNotificationTime.notificationId(for: event)
        let (notificationTitle, notificationBody) = eventNotificationTime.notificationInfo(for: event)
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = .default
        content.userInfo = [Strings.notificationIdKey: notificationId]
        content.categoryIdentifier = Strings.notificationCategoryIdentifier
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("There was an error setting up the notification for \(event.name): \(error.localizedDescription)")
            }
        }
    }
    
    static func removeNotification(for event: Event, at eventNotificationTime: EventNotificationTime) {
        let notificationId = eventNotificationTime.notificationId(for: event)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
    }
    
    static func removeNotifications(for event: Event) {
        for eventNotificationTime in EventNotificationTime.allCases {
            removeNotification(for: event, at: eventNotificationTime)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound, .badge, .banner])
    }
}
