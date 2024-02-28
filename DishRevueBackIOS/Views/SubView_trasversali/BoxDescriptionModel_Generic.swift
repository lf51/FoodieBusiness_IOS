//
//  BoxDescriptionModel_Generic.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/07/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

/// Se passiamo un generalErrorCheck, tornerà un alert di errore se la descrizione resta su nil o vuota
struct BoxDescriptionModel_Generic<M:MyProDescriptionPack_L0>: View {
    // 15.09 passa da MyProModelPack a MyProToolPack
    
    @Binding var itemModel:M
    let labelString: String
    let disabledCondition: Bool
    var generalErrorCheck:Bool = false
    var backgroundColor: Color = Color.black
    @State private var wannaAddDescription: Bool? = false
    
    // Upgrade 17.02.23
    
    @FocusState.Binding var modelField:ModelField?
        
    var body: some View {
        
        VStack(alignment:.leading,spacing:5.0) {

            CSLabel_conVB(
                placeHolder: labelString,
                imageNameOrEmojy: "scribble",
                backgroundColor: backgroundColor) {
                    
                    HStack {
                        
                        let error = self.itemModel.descrizione == nil || self.itemModel.descrizione == ""
    
                        CSButton_image(
                            activationBool: wannaAddDescription,
                            frontImage: "minus.circle",
                            backImage:"square.and.pencil",
                            imageScale: .large,
                            backColor: .white,
                            frontColor: .seaTurtle_3){
                                withAnimation(.default) {
                                    self.wannaAddDescription?.toggle()
                                  
                                }

                            }.disabled(disabledCondition)

                        CS_ErrorMarkView(
                            generalErrorCheck: generalErrorCheck,
                            localErrorCondition: error)
                    }
                }
            
            if self.wannaAddDescription ?? false {

               CSTextField_ExpandingBox(
                itemModel: $itemModel,
                dismissButton: $wannaAddDescription,
                modelField: $modelField,
                maxDescriptionLenght: 150)
                  //  .focused($modelField, equals: .descrizione)
              
                                            
            } else {
                
                Text(itemModel.descrizione == nil ? "Nessuna descrizione inserita" : itemModel.descrizione!)
                    .italic()
                    .fontWeight(.light)
            }
            
        } // chiusa VStack Madre
        
    }
    
}

/*
struct BoxDescriptionModel_Generic_Previews: PreviewProvider {
    static var previews: some View {
        BoxDescriptionModel_Generic()
    }
}

*/
