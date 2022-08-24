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
    let checkError: Bool
    let isIngredientOld: Bool
    
  //  private var isOrgineDefault: Bool = false
  //  private var isConservazioneDefault: Bool = false

    init(ingredient:Binding<IngredientModel>,checkError:Bool,isIngredientOld:Bool) {
        
        _ingredient = ingredient
        
        self.checkError = isIngredientOld ? false : checkError
        self.isIngredientOld = isIngredientOld
        
       // self.isIngredientOld = isIngredientOld
        
      /*  if checkError && !isIngredientOld {
            
            self.isOrgineDefault = ingredient.origine.id == OrigineIngrediente.defaultValue.id
            self.isConservazioneDefault = ingredient.conservazione.id == ConservazioneIngrediente.defaultValue.id
        } */
        
        print("Init -> FastImport_IngredientRow")
    }
    
    var body: some View {
        
     //   ZStack {
                
                VStack(alignment:.leading) {
                    
                    HStack(alignment:.center) {
                        
                       vbMainRow()
             
                       vbOrigineIcon()
                       vbConservazioneIcon()
                       vbAllergeneCheck()
                        
                        
                        Spacer()
                        
                        Text("Principale/secondario")
                        
                    }
        
                    HStack {
                        
                        VStack(alignment:.leading) {
                            
                            CS_Picker(selection: $ingredient.origine, customLabel: "Origine", dataContainer: OrigineIngrediente.allCases, backgroundColor: Color.white, opacity: 0.5)
                                .csWarningModifier(isPresented: checkError) {
                                    self.ingredient.origine == .defaultValue
                                }.fixedSize()


                            CS_Picker(selection: $ingredient.conservazione, customLabel: "Conservazione", dataContainer: ConservazioneIngrediente.allCases, backgroundColor: Color.white, opacity: 0.5)
                                .csWarningModifier(isPresented: checkError) {
                                    self.ingredient.conservazione == .defaultValue
                                }.fixedSize()
                            
                            CS_Picker(selection: $ingredient.produzione, customLabel: "Produzione", dataContainer: ProduzioneIngrediente.allCases, backgroundColor: Color.white, opacity: 0.5)
                                .csWarningModifier(isPresented: checkError) {
                                    self.ingredient.produzione == .defaultValue
                                }.fixedSize()
                            
                            CS_Picker(selection: $ingredient.provenienza, customLabel: "Provenienza", dataContainer: ProvenienzaIngrediente.allCases, backgroundColor: Color.white, opacity: 0.5)
                                .csWarningModifier(isPresented: checkError) {
                                    self.ingredient.provenienza == .defaultValue
                                }.fixedSize()
                          
                            
                        }
                      
 
                        Spacer()
                        
                        CSMenu_MultiSelection(ingredient: $ingredient)
                            ._tightPadding()
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                                    .shadow(radius: 5.0)
                            )
                        
                        
                    }
                    
                    VStack(alignment:.leading,spacing:0) {
                        
                        HStack(alignment:.bottom) {
                            
                            Image(systemName: "thermometer.snowflake")
                                .imageScale(.small)
                            
                            Text(ingredient.conservazione.extendedDescription())
                                .italic()
                                .fontWeight(.light)
                                .font(.caption2)
                                .foregroundColor(Color.black)
                            
                        }
                        
                        HStack(alignment:.bottom) {
                            
                            Image(systemName: "allergens")
                                .imageScale(.small)

                            ScrollView(.horizontal,showsIndicators: false) {
                                
                                HStack(alignment:.bottom) { vbAllergeneBottomRow() }
                                
                                }
                        }                        
                    }
                }
                .padding(.top,10) // o .Vertical
  
      //  }
     
    }
    
    // Method

    @ViewBuilder private func vbOrigineIcon() -> some View {
        
        let image = self.ingredient.origine.imageAssociated()
        
        csVbSwitchImageText(string: image, size: .large)
     /*   if let image = self.ingredient.origine.imageAssociated() {
            
            csVbSwitchImageText(string: image, size: .large)
            
        } else {EmptyView()} */
        
    }
    
    @ViewBuilder private func vbConservazioneIcon() -> some View {
        
        switch ingredient.conservazione {
            
        case .congelato, .surgelato:
            let image = ingredient.conservazione.imageAssociated()
            csVbSwitchImageText(string: image, size: .small)
                .foregroundColor(Color.white)
            
        default:
            EmptyView()
        }
  
    }
    
    @ViewBuilder private func vbAllergeneCheck() -> some View {
        
        if ingredient.allergeni.isEmpty { EmptyView() }
        else {
            Image(systemName: "allergens")
                .imageScale(.small)
                .foregroundColor(Color.black.opacity(0.8))
        }
        
    }
    
    @ViewBuilder private func vbAllergeneBottomRow() -> some View {
        
        if ingredient.allergeni.isEmpty {
         
                Text("Nessun Allergene Specificato")
                   .fontWeight(.semibold)
                   .font(.caption2)
                   .foregroundColor(Color.black.opacity(0.8))
        
        } else {
            
            let listaAllergeni:[String] = estrapolaListaAllergeni()
            
            Text(listaAllergeni,format: .list(type: .and))
                .italic()
                .fontWeight(.light)
                .font(.caption2)
                .foregroundColor(Color.black)
  
            }
        
    }
    
    private func estrapolaListaAllergeni() -> [String] {
        
        var listaAllergeni:[String] = []
        
        for allergene in self.ingredient.allergeni {
            
            let allergeneName = allergene.simpleDescription()
            listaAllergeni.append(allergeneName)
            
        }
        
        return listaAllergeni
    }
    
    
    @ViewBuilder private func vbMainRow() -> some View {

        if self.isIngredientOld {

            Text(ingredient.intestazione)
                .fontWeight(.light)
                .font(.title3)
                .foregroundColor(Color.black)
                .opacity(0.8)
 
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
