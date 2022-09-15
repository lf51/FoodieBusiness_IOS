//
//  PICKERTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/04/22.
//

import SwiftUI

struct PICKERTEST: View {
    
    @State var fastDish: DishModel = DishModel()
    @State var price: String = ""
    
    var body: some View {
        
        VStack(alignment:.leading) {
                   
            HStack {
                
                CSText_tightRectangle(testo: "fastDish.intestazione", fontWeight: .semibold, textColor: Color.white, strokeColor: Color.blue, fillColor: Color.yellow)
                
                Spacer()
                
              /*  CS_Picker(selection: $fastDish.categoriaMenuDEPRECATA, customLabel: "Scegli..", dataContainer: CategoriaMenu.allCases) */
            
                }


            HStack {
                
           /*     csVbSwitchImageText(string: fastDish.categoria.imageAssociated())
                    .font(.subheadline)
                
                Text(fastDish.categoria.simpleDescriptionSingolare())
                    .font(.system(.subheadline, design: .monospaced)) */
                    
                Spacer()
                
                CSTextField_5(textFieldItem: $price, placeHolder: "0,00", image: "eurosign.circle", showDelete: false, keyboardType: .numbersAndPunctuation) {
                    self.fastDish.intestazione = "Done"
                
                }.fixedSize()
               
                    }
                   
               }
        .padding()
        .background(Color.gray.cornerRadius(5.0))
        


    }
}

struct PICKERTEST_Previews: PreviewProvider {
    static var previews: some View {
        PICKERTEST()
    }
}
