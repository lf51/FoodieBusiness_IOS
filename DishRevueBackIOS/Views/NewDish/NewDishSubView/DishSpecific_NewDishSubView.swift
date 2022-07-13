//
//  DishSpecific_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
// Ultima pulizia codice 01.03.2022

struct DishSpecific_NewDishSubView: View {
    
    @Binding var newDish: DishModel
    @State private var allDishFormats: [DishFormat]
    
    init(newDish: Binding<DishModel>) {
        _newDish = newDish
        _allDishFormats = State(wrappedValue: newDish.pricingPiatto.wrappedValue)
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            CSLabel_conVB(
                placeHolder: "Prezzatura",
                imageNameOrEmojy: "doc.text.magnifyingglass",
                backgroundColor: Color.black) {
                                 
                    HStack {
                        
                        CSButton_image(
                            frontImage: "plus.circle",
                            imageScale: .large,
                            frontColor:  Color("SeaTurtlePalette_3")) {
                                withAnimation {
                                    let newFormat = DishFormat(type: .opzionale)
                                    self.allDishFormats.append(newFormat)
                                }
                            }
                        
                        Text("LabelCount:\(self.allDishFormats.count)") // Temporary
                      
                        CSButton_image(
                            frontImage: "tray.and.arrow.down",
                            imageScale: .large,
                            frontColor:  Color("SeaTurtlePalette_3")) {
                                withAnimation {
                                    self.saveFormats()
                                }
                            }
                        
                    }
        
                }

            createFormatRow()
            
        }
    }
    
    // Method Space
    
    @ViewBuilder private func createFormatRow() -> some View {

        VStack {
            
            ForEach(self.$allDishFormats, id:\.self) { $formato in
           
                PriceRow(formatoPiatto: $formato,labelsCount: allDishFormats.count)  { formato in
                    self.reduceRow(formato: formato)
                }

                
            }
            
        }
      
    }
    
    private func reduceRow(formato:DishFormat) {
        
       let index = self.allDishFormats.firstIndex(of: formato)
       self.allDishFormats.remove(at: index!)
        
    }

    private func saveFormats() {
        
       self.newDish.pricingPiatto = self.allDishFormats
        
        for format in self.newDish.pricingPiatto {
            
            print("formato label:\(format.label) price:\(format.price)")
            
        }
        
    }

}

/* struct DishSpecific_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        DishSpecific_NewDishSubView()
    }
}
 */

struct PriceRow:View {
    
    @Binding var formatoPiatto: DishFormat
    let labelsCount:Int
    let delAction:(_ formato:DishFormat) -> Void
  //  let submitAction:(_ formato:DishFormat) -> Void
    @State private var label:String
    @State private var price:String
    
    init(formatoPiatto: Binding<DishFormat>, labelsCount: Int, delAction: @escaping (_: DishFormat) -> Void ) {
        
        _formatoPiatto = formatoPiatto
        _label = State(wrappedValue: formatoPiatto.wrappedValue.label)
        _price = State(wrappedValue: formatoPiatto.wrappedValue.price)
        self.labelsCount = labelsCount
        self.delAction = delAction
        
    }
        
    var body: some View {
     
        HStack {
            
            
            CSTextField_6(
                textFieldItem: $label,
                placeHolder: "labelNew",
                image: "rectangle.dashed.and.paperclip",
                keyboardType: .default,
                conformeA: .stringa(minLenght: 3)) {
                    self.formatoPiatto.label = self.label
                }
            
            
           /* CSTextField_4b(
                textFieldItem: $label,
                placeHolder: "label",
                showDelete: false,
                keyboardType: .default) {
                    csVisualCheck(testo: self.label, imagePrincipal: "rectangle.dashed.and.paperclip", conformeA: .stringa(minLenght: 3))
                } */
                .overlay {
                    if labelsCount == 1 && formatoPiatto.type == .mandatory {
                        ZStack {
                            Color("SeaTurtlePalette_1").cornerRadius(5.0)
                            Text("Label Non Richiesta")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                        }
                  
                    }
                }
            
          /*  CSTextField_4b(
                textFieldItem: $price,
                placeHolder: "000.00",
                showDelete: false,
                keyboardType: .decimalPad) {
                    csVisualCheck(testo: price, imagePrincipal: "eurosign.circle", conformeA: .decimale)
                } */
            
            CSTextField_6(
                textFieldItem: $price,
                placeHolder: "000.00",
                image: "eurosign.circle",
                keyboardType: .decimalPad,
                conformeA: .decimale) {
                    self.formatoPiatto.price = self.price
                }
            
                .fixedSize() // fixedSize significa che la view avrà una grandezza variabile che può eccedere quella in cui è contenuta. Viene impostato alla sua grandezza ideale. Per questo muterà se inseriamo, in questo caso, tante cifre. Dato che ipotizziamo che in un ristorante difficilmente supereremo le 5 cifre, lo impostiamo su questa linea. Dovesse comunque succedere non fa nulla :-)
                        
            if formatoPiatto.type == .opzionale {
                
                CSButton_image(frontImage: "trash", imageScale: .medium, frontColor: Color.white) {
                    withAnimation {
                        self.delAction(formatoPiatto)
                        }
                    }
                    ._tightPadding()
                    .background(
                        Circle()
                            .fill(Color.red.opacity(0.5))
                            .shadow(radius: 5.0)
                    )
           
            } else {
                
                CSButton_image(frontImage: "trash", imageScale: .medium, frontColor: Color.white) {
                    self.delAction(formatoPiatto)
                    }
                    ._tightPadding()
                    .background(
                        Circle()
                            .fill(Color.red.opacity(0.5))
                            .shadow(radius: 5.0)
                    )
                    .hidden()
                    .overlay {
                        Image(systemName: "circle")
                            .foregroundColor(Color.green)
                      
                    }
                
            }
            
        }
     
    }
    
    // Method
    
    
}
