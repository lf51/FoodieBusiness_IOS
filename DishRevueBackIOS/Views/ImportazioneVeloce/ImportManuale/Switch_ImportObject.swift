//
//  Switch_ImportObject.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/06/23.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct Switch_ImportObject: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let backgroundColorView: Color
    
    @State private var localChoice:SwitcherImport = .piattoEIngredienti
    @State private var disabilitaPicker:Bool = false
    
    var body: some View {
        
        CSZStackVB(title: "Importazione Veloce", backgroundColorView: backgroundColorView) {
            
        
            VStack(alignment:.leading) {
                
                Picker(selection: $localChoice) {
                    Text("Piatto con Ingredienti")
                        .tag(SwitcherImport.piattoEIngredienti)
                      
                    Text("Categorie Menu")
                        .tag(SwitcherImport.categorieMenu)
                } label: {
                    Text("")
                }
                .disabled(disabilitaPicker)
                .pickerStyle(.segmented)
                .csHpadding()
                
                vbImportSwitch()
                CSDivider()
              //  Spacer()
            }
            
        }
        .onAppear {
            
            if viewModel.db.allMyCategories.isEmpty {
                self.localChoice = .categorieMenu
                self.disabilitaPicker = true
            }
            
        }
    }
    
    @ViewBuilder private func vbImportSwitch() -> some View {
        
        switch localChoice {
            
        case .categorieMenu:
            FastImport_Categorie(backgroundColorView: self.backgroundColorView,disabilitaPicker: $disabilitaPicker)
        case .piattoEIngredienti:
            FastImport_MainView(backgroundColorView: self.backgroundColorView)
            
        }
    }
    
    private enum SwitcherImport {
        
        case piattoEIngredienti
        case categorieMenu
    }
    
}

struct Switch_ImportObject_Previews: PreviewProvider {
    static var user:UserRoleModel = UserRoleModel()
    static var previews: some View {
        NavigationStack {
            Switch_ImportObject(backgroundColorView: .seaTurtle_1)
                .environmentObject(AccounterVM(userAuthUID: "TEST_USER_UID"))
        }
    }
}
