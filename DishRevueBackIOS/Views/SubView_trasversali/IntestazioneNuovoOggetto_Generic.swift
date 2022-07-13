//
//  IntestazioneNuovoOggetto.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/03/22.
//

import SwiftUI

struct IntestazioneNuovoOggetto_Generic<T:MyModelStatusConformity>: View {
    
    let placeHolderItemName: String
    let imageLabel: String
    var imageColor: Color? = nil
    let coloreContainer: Color
    
    @State private var nuovaStringa: String = ""
    @State private var editNuovaStringa: Bool = false
    
    @Binding var itemModel: T
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_1Button(placeHolder: placeHolderItemName, imageNameOrEmojy: imageLabel,imageColor: imageColor, backgroundColor: Color.black)
        
            if self.itemModel.intestazione == "" || self.editNuovaStringa {
                
                CSTextField_3(textFieldItem: self.$nuovaStringa, placeHolder: self.itemModel.intestazione == "" ? "Nuovo Nome" : "Cambia Nome") {
                    
                    let newText = csStringCleaner(string: self.nuovaStringa)
                    
                    guard csCheckStringa(testo: newText,minLenght: 5) else {
                        
                        self.nuovaStringa = ""
                        
                        return }
                    
                    self.itemModel.intestazione = newText
                    self.nuovaStringa = ""
                    self.editNuovaStringa = false
                   
                }
        
            }
            
            if self.itemModel.intestazione != "" {
                
                if !editNuovaStringa {
                    
                        CSText_tightRectangle(testo: self.itemModel.intestazione, fontWeight: .bold, textColor: Color.white, strokeColor: Color.blue, fillColor: coloreContainer)
                            .onLongPressGesture {
                                self.editNuovaStringa = true
                            }

                } else {
                        
                        CSText_RotatingRectangleDynamicDeletingFace(testo: self.itemModel.intestazione, fontWeight: .bold, textColor: Color.white, scaleFactor: 1.0, strokeColor: Color.blue, fillColor: coloreContainer.opacity(0.4), showDeleteImage: false)
                            .onTapGesture {
                                self.editNuovaStringa = false
                            }
                    }
                
                Text(editNuovaStringa ? "Click per annullare" : "Premi a lungo per modificare")
                    .font(.caption)
                    .fontWeight(.light)
                    .italic()
                
                }

        }
    }
}

/*struct IntestazioneNuovoOggetto_Previews: PreviewProvider {
    static var previews: some View {
        IntestazioneNuovoOggetto_Generic()
    }
} */
