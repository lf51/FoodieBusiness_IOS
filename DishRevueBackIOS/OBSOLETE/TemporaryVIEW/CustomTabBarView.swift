//
//  CustomTabBarView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 28/01/22.
//

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    let backgroundColor: Color
    @Binding var selection: TabBarItem
    
    var body: some View {
        
        HStack {
            
            ForEach(tabs, id:\.self) { tab in
            
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
           
            }
        }
        .padding(6)
        .background(backgroundColor.edgesIgnoringSafeArea(.bottom).opacity(0.6))
        
        
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    
    static let backgroundColor = Color.brown
    static let tabs: [TabBarItem] = [
        TabBarItem(iconName: "house", title: "Home", fontColor: .cyan, backgroundColor: .cyan),
        
        TabBarItem(iconName: "plus.app", title: "New Dish", fontColor: .cyan, backgroundColor: .cyan),
        
        TabBarItem(iconName: "list.bullet.rectangle.portrait", title: "Dish List", fontColor: .cyan, backgroundColor: .cyan)
    
    ]
    
    static var previews: some View {
        
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, backgroundColor: backgroundColor, selection: .constant(tabs[0]))
        }
    }
}

extension CustomTabBarView {
    
    private func tabView(tab: TabBarItem) -> some View {
        
        VStack {
            
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
            
        }
        .foregroundColor(selection == tab ? tab.fontColor : Color.gray)
        .padding(.vertical,8)
        .frame(maxWidth:.infinity)
        .background(selection == tab ? tab.backgroundColor.opacity(0.2) : Color.clear)
        .cornerRadius(10)

    }
    
    private func switchToTab(tab: TabBarItem) {
        
        withAnimation(.easeInOut) {
            selection = tab
        }
      
    }
    
    
}

struct TabBarItem: Hashable {
    
    let iconName: String
    let title: String
    let fontColor: Color
    let backgroundColor: Color
    
    // let cornerRadius
    //let backgroundColor
    // let fontSize
}
