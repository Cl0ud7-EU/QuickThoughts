//
//  MainView.swift
//  Quickthoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

//class HideBarViewModel: ObservableObject {
//    @Published var isHidden = false
//    @Published var NavBarState = States.isVisible
//
//    enum States: Int
//    {
//        case isVisible = 0
//        case isHidden = 1
//        case onlyBackButton = 2
//    }
//}

struct MainView: View {
    
    @StateObject var newQuickTViewModel = NewQuickTViewModel(text: "")
    @EnvironmentObject var auth: Authentication
    
//    @ObservedObject var vm = HideBarViewModel()
    @StateObject var navBarViewModel = NavBarViewModel()
    
    var body: some View {
        TabView {
            CustomNavigationView {
                TimelineView()
                .navBarTitle(title: "QuickT")
                .navBarBackButtonHidden(value: true)
            }
            .environmentObject(newQuickTViewModel)
            .tabItem {
                Text("Timeline")
            }
            CustomNavigationView {
                SearchView()
                .navBarTitle(title: "QuickT")
                .navBarHidden(value: false)
                .navBarBackButtonHidden(value: true)
                //.navBarState(value: )
                .navBarNewQuickTButtonHidden(value: true)
            }
            //.environmentObject(navBarViewModel)
            .environmentObject(newQuickTViewModel)
            .tabItem {
                    Text("Search")

            }
            Profile(viewModel: nil)
            .tabItem {
                    Text("Profile")
            }
        }
        //.edgesIgnoringSafeArea(.all)
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
    //static let user = User(id: 1, name: "Cl0ud7")
    static let auth = Authentication()

    static var previews: some View {
        MainView()
            .environmentObject(auth)
    }
}
