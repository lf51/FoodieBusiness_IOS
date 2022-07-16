//
//  BoxDescriptionModel_Generic.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/07/22.
//

import SwiftUI

struct BoxDescriptionModel_Generic<M:MyModelProtocol>: View {
    
    @Binding var itemModel:M
    let labelString: String
    let disabledCondition: Bool?
    @State private var wannaAddDescription: Bool? = false
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_1Button(
                placeHolder: labelString,
                imageNameOrEmojy: "scribble",
                backgroundColor: Color.black,
                toggleBottone: $wannaAddDescription,
                disabledCondition: disabledCondition)
                                    
            if wannaAddDescription ?? false {

                CSTextField_ExpandingBox(itemModel: $itemModel, maxDescriptionLenght: 300)
                                            
            } else {
                
                Text(itemModel.descrizione == "" ? "Nessuna descrizione inserita. Press [+] " : itemModel.descrizione)
                    .italic()
                    .fontWeight(.light)
            }
            
        }
        
    }
    
}

/*
struct BoxDescriptionModel_Generic_Previews: PreviewProvider {
    static var previews: some View {
        BoxDescriptionModel_Generic()
    }
}
*/
