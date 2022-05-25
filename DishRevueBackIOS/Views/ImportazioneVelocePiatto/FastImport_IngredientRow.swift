//
//  FastImport_IngredientRow.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import SwiftUI

struct FastImport_IngredientRow: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var ingredient: IngredientModel
    @State private var openAllergeni: Bool? = false
    
    var body: some View {
        
        ZStack {
                
                VStack(alignment:.leading) {
                    
                    HStack(alignment:.center) {
                        
                      /* Image(systemName: "thermometer.snowflake")
                            .imageScale(.medium)
                            .foregroundColor(Color.gray) */
                        
                       vbMainRow()
             
                       vbOrigineRow()
                       vbConservazioneRow()
                       vbAllergeneCheck()
                        
                        
                        Spacer()
                        
                    /*
                        vbOrigineRow()
                        CS_Picker(selection: $ingredient.origine, customLabel: "Origine..", dataContainer: DishBase.allCases)
                        
                        
                        Text("Open")
                            .onTapGesture {
                                self.openAllergeni?.toggle()
                            } */
                        
                    }//.padding(.bottom,10)
                
                   /* HStack {
                        
                        vbOrigineRow()
                        
                    } */
                    
                    HStack {
                        
                        CS_Picker(selection: $ingredient.origine, customLabel: "Origine..", dataContainer: DishBase.allCases, backgroundColor: Color.brown, opacity: 0.2)
                        
                        CS_Picker(selection: $ingredient.conservazione, customLabel: "Conservazione..", dataContainer: ConservazioneIngrediente.allCases, backgroundColor: Color.mint, opacity: 0.6)
   
                        Image(systemName: "allergens")
                            .imageScale(.large)
                            .onTapGesture {
                                self.openAllergeni?.toggle()
                            }
                        
                        
                    }
                    
                    HStack(alignment:.bottom) {
                        
                        Image(systemName: "allergens")
                            .imageScale(.small)

                            vbAllergeneRow()

                    }
                    
                  /*  HStack {
                        
                        Image(systemName: "thermometer.snowflake")
                             .imageScale(.small)
       
                       vbConservazioneRow()
                        
                    }

                    HStack {
                        
                        Image(systemName: "allergens")
                            .imageScale(.small)
                       
                        ScrollView(showsIndicators: false){
                            vbAllergeneRow()
                        }
 
                    } */
                  
                }
                .padding(.top,10) // o .Vertical

            
            if self.openAllergeni! {
                
                SelettoreMyModel<_,AllergeniIngrediente>(
                    itemModel: $ingredient,
                    allModelList: [
                        .viewModelContainer("Elenco Allergeni", \.allergeni,.fonte),
                        .itemModelContainer("Allergeni \(ingredient.intestazione)", \IngredientModel.allergeni, .destinazione(Color.red, grado: .principale))
                    
                    ],
                    closeButton: $openAllergeni)
                
            }
            
            
            
        }
            
    }
    
    // Method

    @ViewBuilder private func vbOrigineRow() -> some View {
        
        if let image = self.ingredient.origine.imageAssociated() {
            
            csVbSwitchImageText(string: image, size: .large)
            
        } else {EmptyView()}
       
        
     
      /*  if  let description = self.ingredient.origine.extendedDescription() {
            
            Text(description)
                .fontWeight(.light)
                .font(.caption2)
            
        } else {
            
            Text("Origine non Specificata")
                .fontWeight(.light)
                .font(.caption2)
            
        } */
        
    }
    
    @ViewBuilder private func vbConservazioneRow() -> some View {
        
        switch ingredient.conservazione {
            
        case .congelato, .surgelato:
            let image = ingredient.conservazione.imageAssociated()
            csVbSwitchImageText(string: image, size: .small)
                .foregroundColor(Color.white)
            
        default:
            EmptyView()
        }
        
        
      /* if ingredient.conservazione.extendedDescription() != nil {
            
            Text(ingredient.conservazione.extendedDescription()!)
                .fontWeight(.semibold)
                .font(.caption2)
            
        } */
  
    }
    
    @ViewBuilder private func vbAllergeneCheck() -> some View {
        
        if ingredient.allergeni.isEmpty { EmptyView() }
        else {
            Image(systemName: "allergens")
                .imageScale(.small)
                .foregroundColor(Color.black.opacity(0.8))
        }
        
    }
    
    @ViewBuilder private func vbAllergeneRow() -> some View {
        
        if ingredient.allergeni.isEmpty {
             Text("Nessun Allergene Specificato")
                .fontWeight(.semibold)
                .font(.caption2)
                .foregroundColor(Color.black.opacity(0.8))
            
        } else {
      
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(alignment:.bottom) {
                    
                    ForEach(ingredient.allergeni) { allergene in
                        
                        Text(allergene.simpleDescription())
                            .italic()
                            .fontWeight(.light)
                            .font(.caption2)
                            .foregroundColor(Color.black)
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    
    @ViewBuilder private func vbMainRow() -> some View {
        
        let isIngredientOld = viewModel.checkExistingIngredient(item: ingredient).0
       
        if isIngredientOld {

            Text(ingredient.intestazione)
                .fontWeight(.light)
                .font(.title3)
                .foregroundColor(Color.black)
                .opacity(0.5)
           /* CSText_tightRectangle(testo: ingredient.intestazione, fontWeight: .light, textColor: Color.black, strokeColor: Color.clear, fillColor: Color.clear)
                    .opacity(0.5) */
              
        } else {
            
            Text(ingredient.intestazione)
                .fontWeight(.light)
                .font(.title3)
                .foregroundColor(Color.black)
                .overlay(alignment:.topTrailing) {
                    Text("New")
                        .font(.caption2)
                        .foregroundColor(Color.white)
                        .offset(x: 10, y: -10)
                      
                        
                }
            
              /*  CSText_tightRectangle(testo: ingredient.intestazione, fontWeight: .light, textColor: Color.black, strokeColor: Color.clear, fillColor: Color.clear)
                    .overlay(alignment:.topTrailing) {
                        Text("New")
                            .font(.caption2)
                            .foregroundColor(Color.white)
                            
                    }*/
       
        }
    }
    
    
}

/*
struct FastImport_IngredientRow_Previews: PreviewProvider {
    
    
    @State static var ingredient = IngredientModel(nome: "Pepe Nero")
    
    static var previews: some View {
        FastImport_IngredientRow(ingredient:$ingredient )
            .environmentObject(AccounterVM())
            
    }
} */
