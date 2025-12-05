//
//  Grey_physics_boxApp.swift
//  Grey physics box

import SwiftUI

@main
struct Grey_physics_boxApp: App {
    @UIApplicationDelegateAdaptor(GreyPhysicsAppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            GreyPhysicsGameInitialView()
        }
    }
}
