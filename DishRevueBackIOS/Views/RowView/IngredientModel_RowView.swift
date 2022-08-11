//
//  IngredientModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/04/22.
//

import SwiftUI

struct IngredientModel_RowView: View {

    @EnvironmentObject var viewModel: AccounterVM
    let item: IngredientModel
    
    var body: some View {
                
        CSZStackVB_Framed {
        
            VStack(alignment:.leading) {
    
                VStack(alignment:.leading) {
                    
                    vbIntestazioneIngrediente()
                //    vbSubIntestazioneIngrediente()
                    
                }
             
                    .padding(.top,5)
                
                
          //     Spacer()
                
                HStack {
                    
                    CSText_tightRectangleVisual(fontWeight: .bold, textColor: Color("SeaTurtlePalette_4"), strokeColor: Color("SeaTurtlePalette_1"), fillColor: Color("SeaTurtlePalette_1")) {
                        HStack {
                            csVbSwitchImageText(string: self.item.origine.imageAssociated())
                            Text(self.item.origine.simpleDescription())
                        }
                    }
                    
                    CSText_tightRectangleVisual(fontWeight: .bold, textColor: Color("SeaTurtlePalette_1"), strokeColor: Color("SeaTurtlePalette_1"), fillColor: Color("SeaTurtlePalette_4")) {
                        HStack {
                            csVbSwitchImageText(string: self.item.provenienza.imageAssociated())
                            Text(self.item.provenienza.simpleDescription())
                        }
                    }
                }
                
             //   Spacer()
                
                VStack(spacing:3) {
                    
                    vbAllergeneScrollRowView(listaAllergeni: self.item.allergeni)
                    
                    vbConservazioneIngrediente()
                }
               .padding(.vertical,5)
     
            } // chiuda VStack madre
           // ._tightPadding()
            .padding(.horizontal)
          //  .padding(.vertical,5)
        } // chiusa Zstack Madre
        
    }
    
    // Method
    
    /* private func vbSubIntestazioneIngrediente() -> some View {
        
        let riserva = self.item.idIngredienteDiRiserva
        
        var string = "Nessun Ingrediente di Riserva"
        
        if let ingreDiRiserva:IngredientModel = self.viewModel.allMyIngredients.first(where: { $0.id == riserva }) { // usiamo l'optional binding perchè: Nel caso in cui l'ingrediente di riserva sia stato eliminato, l'ingrediente che ha il suo id come riserva, qui scopre che l'ingrediente non esiste più, e dunque non lo indica come riserva.
                
            string = "Sostituibile con --> \(ingreDiRiserva.intestazione)"
                
            }

      return Text(string)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(Color("SeaTurtlePalette_3"))
    } */
    
    @ViewBuilder private func vbConservazioneIngrediente() -> some View {
        
        HStack(spacing: 4.0) {
            
            csVbSwitchImageText(string: self.item.conservazione.imageAssociated(), size: .large)
                .foregroundColor(Color.white)
  
            ScrollView(.horizontal, showsIndicators: false) {
                
                Text(self.item.conservazione.extendedDescription())
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(Color.white)
                    .italic()
            }
            
        }
        
        
    }
    
    @ViewBuilder private func vbIntestazioneIngrediente() -> some View {
        
        HStack(alignment:.lastTextBaseline) {
            
            Text(self.item.intestazione)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundColor(Color.white)
                .overlay(alignment:.topTrailing) {
                    
                    if self.item.produzione == .biologico {
                        
                        Text("Bio")
                            .font(.system(.caption2, design: .monospaced, weight: .black))
                            .foregroundColor(Color.green)
                            .offset(x: 10, y: -4)
                    }
                }
            
            let isRiservaActive = self.item.idIngredienteDiRiserva != ""
            
            Image(systemName: "arrow.left.arrow.right.circle")
                .imageScale(.medium)
                .foregroundColor(isRiservaActive ? Color("SeaTurtlePalette_3") : Color("SeaTurtlePalette_1") )
                .overlay {
                    
                    if !isRiservaActive {
                        
                        Image(systemName: "circle.slash")
                            .imageScale(.medium)
                            .foregroundColor(Color("SeaTurtlePalette_1"))
                            .rotationEffect(Angle(degrees: 90.0))
                        
                    }
  
                }
            
            Spacer()
            
            vbEstrapolaStatusImage(itemModel: self.item)
            
        }
        
    }
    
}


struct IngredientModel_RowView_Previews: PreviewProvider {
    
    @StateObject static var viewModel: AccounterVM = {
        var viewM = AccounterVM()
        viewM.allMyIngredients = [ ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4
        
        ]
        return viewM
    }()
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .restoDelMondo,
        allergeni: [.glutine],
        origine: .carneAnimale,
        status: .completo(.archiviato),
        idIngredienteDiRiserva: "merluzzo"
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Merluzzo",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .convenzionale,
        provenienza: .italia,
        allergeni: [.pesce],
        origine: .pesce,
        status: .completo(.inPausa),
        idIngredienteDiRiserva: "guancialenero"
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .completo(.pubblico))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .latteAnimale,
        status: .vuoto,
        idIngredienteDiRiserva: "basilico")
    
    static var previews: some View {
        
        ZStack {
            
            Color("SeaTurtlePalette_1").ignoresSafeArea()
            
            VStack {
                
                IngredientModel_RowView(item: ingredientSample)
                IngredientModel_RowView(item: ingredientSample2)
                IngredientModel_RowView(item: ingredientSample3)
                IngredientModel_RowView(item: ingredientSample4)
                
            }
        }.environmentObject(viewModel)
    }
}
