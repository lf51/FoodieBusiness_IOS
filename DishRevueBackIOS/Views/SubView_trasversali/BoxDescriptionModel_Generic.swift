//
//  BoxDescriptionModel_Generic.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/07/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct BoxDescriptionModel_Generic<M:MyProDescriptionPack_L0>: View {
    // 15.09 passa da MyProModelPack a MyProToolPack
    
    @Binding var itemModel:M
    let labelString: String
    let disabledCondition: Bool
    var backgroundColor: Color = Color.black
    @State private var wannaAddDescription: Bool? = false
    
    // Upgrade 17.02.23
    
    @FocusState.Binding var modelField:ModelField?
    
    var body: some View {
        
        VStack(alignment:.leading,spacing:5.0) {
            
            CSLabel_1Button(
                placeHolder: labelString,
                imageNameOrEmojy: "scribble",
                backgroundColor: backgroundColor,
                disabledCondition: disabledCondition,
                toggleBottone: $wannaAddDescription)
                                    
            if wannaAddDescription ?? false {

               CSTextField_ExpandingBox(
                itemModel: $itemModel,
                dismissButton: $wannaAddDescription,
                modelField: $modelField,
                maxDescriptionLenght: 150)
                  //  .focused($modelField, equals: .descrizione)
              
                                            
            } else {
                
                Text(itemModel.descrizione == "" ? "Nessuna descrizione inserita. Press [+] " : itemModel.descrizione)
                    .italic()
                    .fontWeight(.light)
            }
            
        }
        
    }
    
}

/*
struct BoxDescriptionModel_Generic<M:MyProDescriptionPack_L0>: View {
    // 15.09 passa da MyProModelPack a MyProToolPack
    
    @Binding var itemModel:M
    let labelString: String
    let disabledCondition: Bool
    var backgroundColor: Color = Color.black
    @State private var wannaAddDescription: Bool? = false
    
    // Upgrade 17.02.23
    
  //  @FocusState.Binding var modelField:ModelField?
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_1Button(
                placeHolder: labelString,
                imageNameOrEmojy: "scribble",
                backgroundColor: backgroundColor,
                disabledCondition: disabledCondition,
                toggleBottone: $wannaAddDescription)
                                    
            if wannaAddDescription ?? false {

               CSTextField_ExpandingBox(itemModel: $itemModel, dismissButton: $wannaAddDescription, maxDescriptionLenght: 150)
                  //  .focused($modelField, equals: .descrizione)
              
                                            
            } else {
                
                Text(itemModel.descrizione == "" ? "Nessuna descrizione inserita. Press [+] " : itemModel.descrizione)
                    .italic()
                    .fontWeight(.light)
            }
            
        }
        
    }
    
}*/
// 17.02.23 Versione deprecata per ugrade con FocusState

/*
struct BoxDescriptionModel_Generic_Previews: PreviewProvider {
    static var previews: some View {
        BoxDescriptionModel_Generic()
    }
}

*/
