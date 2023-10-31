//
//  Switch_CloudImportObject.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/09/23.
//

import SwiftUI
import MyPackView_L0
/*
struct Switch_CloudImportObject: View {
    
   // @StateObject var importVM:CloudImportViewModel
    let backgroundColorView: Color
    
    @State private var localChoice:SwitcherImport = .moduloA
    @State private var disabilitaPicker:Bool = false
    
    init(backgroundColorView: Color/*, viewModel:AccounterVM*/) {
        print("[INIT]_Switch_CloudImportObject")
       /*_importVM = StateObject(wrappedValue: CloudImportViewModel(viewModel: viewModel))*/
        self.backgroundColorView = backgroundColorView
       
    }

    var body: some View {
        
        CSZStackVB(title: "Libreria Condivisa", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                Picker(selection: $localChoice) {
                    Text("Ingredienti")
                        .tag(SwitcherImport.moduloA)
                      
                    Text("Categorie")
                        .tag(SwitcherImport.moduloB)
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

    }
    
    @ViewBuilder private func vbImportSwitch() -> some View {
        
        switch localChoice {
            
        case .moduloA:
            CloudImportIngredientsView(backgroundColor: backgroundColorView)
        case .moduloB:
            CloudImportCategoriesView(backgroundColor: backgroundColorView)
            
        }
    }
    
    private enum SwitcherImport {
        
        case moduloA
        case moduloB
    }
    
} // deprecata 20_10_23

#Preview {
    Switch_CloudImportObject(backgroundColorView: .seaTurtle_1)
}*/
