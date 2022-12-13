//
//  MainView.swift
//  Quickthoughts
//
//  Created by Cl0ud7.
//

import SwiftUI


struct MainView: View {
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        TabView {
            NavigationView {
            }
            .tabItem {
                    Text("Search")

            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            let attributesSelected = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.black
                ]

            UITabBar.appearance().isOpaque = false
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.systemMint.withAlphaComponent(1)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributesSelected
            appearance.backgroundEffect = UIBlurEffect(style: .regular)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
extension UITabBarController {
    override open func viewDidLoad() {
        super.viewDidLoad()

    }
}

struct ContentView_Previews: PreviewProvider {
    static let auth = Authentication()

    static var previews: some View {
        MainView()
            .environmentObject(auth)
    }
}
