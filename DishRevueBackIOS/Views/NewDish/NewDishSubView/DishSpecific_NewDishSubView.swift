//
//  DishSpecific_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/07/22.
//

import SwiftUI

struct DishSpecific_NewDishSubView: View {
    
   // @Binding var newDish: DishModel
    @Binding var allDishFormats: [DishFormat]
    let generalErrorCheck: Bool
    
    @State private var formatsIn:Int = 0
    
  /*  init(newDish: Binding<DishModel>) {
        _newDish = newDish
        _allDishFormats = State(wrappedValue: newDish.pricingPiatto.wrappedValue)
    } */
    
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
                        
                      //  Spacer()
                        
                     /*   Text("\(self.formatsIn)/\(self.allDishFormats.count)")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("SeaTurtlePalette_3"))
                    
                        CSButton_image(
                            frontImage: "tray.and.arrow.down",
                            imageScale: .large,
                            frontColor:  Color("SeaTurtlePalette_3")) {
                                withAnimation {
                                    self.saveFormats()
                                }
                            } */
                        
                    }
        
                }

            createFormatRow()
            
        }
    }
    
    // Method Space
    
    @ViewBuilder private func createFormatRow() -> some View {

        VStack {
            
            ForEach(self.$allDishFormats, id:\.self) { $formato in
           
                PriceRow(formatoPiatto: $formato, checkError: generalErrorCheck,labelsCount: allDishFormats.count)  { formato in
                    self.reduceRow(formato: formato)
                }

                
            }
            
        }
      
    }
    
    private func reduceRow(formato:DishFormat) {
        
       let index = self.allDishFormats.firstIndex(of: formato)
       self.allDishFormats.remove(at: index!)
        
    }

  /* private func saveFormats() { // deprecated 14.07
        
        if self.allDishFormats.count == 1 {
            
            let format = self.allDishFormats[0]
            
            if csCheckDouble(testo: format.price) {
                
                self.newDish.pricingPiatto = self.allDishFormats
                
            } else { self.checkErrors = true }
     
        } else {
            
            var formatsOK:[DishFormat] = []
            
            for format in self.allDishFormats {
                
                if csCheckStringa(testo: format.label, minLenght: 3) && csCheckDouble(testo: format.price) {
                    
                    formatsOK.append(format)
                    
                } else {
                    self.checkErrors = true
                    return
                    
                }
            }
            
            self.newDish.pricingPiatto = formatsOK
            self.formatsIn = formatsOK.count
        }
    } */ // Deprecata 14.07

}

/* struct DishSpecific_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        DishSpecific_NewDishSubView()
    }
}
 */

struct PriceRow:View {
    
    @Binding var formatoPiatto: DishFormat
    let checkError: Bool
    let labelsCount:Int
    let delAction:(_ formato:DishFormat) -> Void
    
    @State private var label:String
    @State private var price:String
    
    init(formatoPiatto: Binding<DishFormat>, checkError:Bool, labelsCount: Int, delAction: @escaping (_: DishFormat) -> Void ) {
        
        _formatoPiatto = formatoPiatto
        self.checkError = checkError
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
                .overlay {
                    if labelsCount == 1 {
                        ZStack {
                            Color("SeaTurtlePalette_1").cornerRadius(5.0)
                            Text("Label Non Richiesta")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                        }
                    }
                }
                .csWarningModifier(isPresented: checkError) {
                    if labelsCount > 1 {
                        return !csCheckStringa(testo: self.label, minLenght: 3) } else {
                            return false}
                }
            
            CSTextField_6(
                textFieldItem: $price,
                placeHolder: "000.00",
                image: "eurosign.circle",
                keyboardType: .decimalPad,
                conformeA: .decimale) {
                    self.formatoPiatto.price = self.price
                }
                .fixedSize() // fixedSize significa che la view avrà una grandezza variabile che può eccedere quella in cui è contenuta. Viene impostato alla sua grandezza ideale. Per questo muterà se inseriamo, in questo caso, tante cifre. Dato che ipotizziamo che in un ristorante difficilmente supereremo le 5 cifre, lo impostiamo su questa linea. Dovesse comunque succedere non fa nulla :-)
                .csWarningModifier(isPresented: checkError) {
                    !csCheckDouble(testo: self.price)
                }
               /* .overlay(alignment:.topTrailing) {
                    if checkError {
                        
                        let error = !csCheckDouble(testo: self.price)
                        CS_ErrorMarkView(checkError: error)
                            .offset(x: 10, y: -10)
                        
                    }
                } */
            
            
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
                 //   self.delAction(formatoPiatto)
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
}
