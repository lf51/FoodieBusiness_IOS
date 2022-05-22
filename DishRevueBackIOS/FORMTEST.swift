//
//  PICKERTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/04/22.
//

import SwiftUI

struct FormTEST: View {
    
    @State var fastDish: DishModel

    
    var body: some View {
        
        NavigationView {
            Form {
                
                
              //  Section {
                    
                    Picker(
                        selection: $fastDish.categoria) {
                           ForEach(DishCategoria.allCases) { categoria in
                               
                               Text(categoria.simpleDescriptionSingolare())
                                  .tag(categoria.returnTypeCase())
                               
                           }
                       } label: {
                           CSText_tightRectangle(testo: "Spaghetti a Carbonara", fontWeight: .semibold, textColor: Color.white, strokeColor: Color.clear, fillColor: Color.yellow)
                       }
                    
              //  }
                
             //   VStack(alignment:.leading) {
                    
                /*    CSText_tightRectangle(testo: fastDish.intestazione, fontWeight: .semibold, textColor: Color.white, strokeColor: Color.blue, fillColor: Color.yellow) */

                  /*  Text(fastDish.categoria.simpleDescriptionSingolare())
                        .font(.caption2) */
                    
            //    }
           
            }
        }



    }
}

struct FormTEST_Previews: PreviewProvider {
    static var previews: some View {
        FormTEST(fastDish: DishModel())
    }
}
