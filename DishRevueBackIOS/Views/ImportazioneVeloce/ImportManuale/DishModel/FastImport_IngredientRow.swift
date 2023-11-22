//
//  FastImport_IngredientRow.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct FastImport_IngredientRow: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var ingredient: IngredientModel
    @Binding var areAllergeniOk: Bool
    let checkError: Bool
    let isIngredientOld: Bool
    
    let isSecondary:(_:String) -> Bool
    @State private var isSecondario: Bool = false

    init(ingredient:Binding<IngredientModel>,areAllergeniOk:Binding<Bool>,checkError:Bool,isIngredientOld:Bool,isSecondary:@escaping (_:String) -> Bool) {
        
        _ingredient = ingredient
        _areAllergeniOk = areAllergeniOk
        
        self.checkError = isIngredientOld ? false : checkError
        self.isIngredientOld = isIngredientOld
        self.isSecondary = isSecondary

        print("Init -> FastImport_IngredientRow")
    }
    
    var body: some View {
        
     //   ZStack {
                
                VStack(alignment:.leading) {
                    
                  //  let isDiSistema = self.ingredient.status == .bozza()
                    
                    HStack(alignment:.center,spacing: 4) {
                        
                       vbMainRow()
                            .lineLimit(1)
                          //  .fixedSize()
            
                        HStack(spacing: 2) {
                            vbOrigineIcon()
                            vbConservazioneIcon()
                            vbProduzioneCheck()
                        }
                        //.lineLimit(1)
                      //  .fixedSize()
                        
                        Spacer()
                        
                      //  if !isDiSistema {
                            
                            HStack(spacing: 2) {
                                
                                CSInfoAlertView(
                                    title: "Info",
                                    message: .ingredienteSecondario)
                               
                                Text("Minore")
                                    .underline(isSecondario)
                                    .font(.callout)
                                    .foregroundStyle(Color.black)
                                   // .fixedSize()
                                 
                                Button {
                                    
                                    withAnimation {
                                        isSecondario = isSecondary(ingredient.id)
                                    }
                                    
                                } label: {
                                    Image(systemName: "circle")
                                        .imageScale(.medium)
                                        .foregroundStyle(Color.black)
                                        .opacity(isSecondario ? 0.6 : 1.0)
                                        .overlay {
                                            if isSecondario {
                                                Image(systemName: "checkmark")
                                                    .imageScale(.large)
                                                    .bold()
                                                    .foregroundStyle(Color.seaTurtle_3)
                                            }
                                        }
                                }

                            }
                      /* } else {
                            Text("Prodotto di terzi")
                                .italic()
                                .font(.callout)
                                .foregroundStyle(Color.seaTurtle_3)
                        }*/
                        
                    }
        
                    VStack(alignment:.leading) {

                        HStack {
                            
                            CS_Picker(selection: $ingredient.conservazione, customLabel: "Conservazione", dataContainer: ConservazioneIngrediente.allCases, backgroundColor: Color.white, opacity: 0.5)
                                .csWarningModifier(isPresented: checkError) {
                                    self.ingredient.conservazione == .defaultValue
                                }//.fixedSize()
                            
                            CS_PickerWithDefault(selection: $ingredient.produzione, customLabel: "Produzione(?)", dataContainer: ProduzioneIngrediente.allCases, backgroundColor: Color.white, opacity: 0.5)
                              /*  .csWarningModifier(isPresented: checkError) {
                                    self.ingredient.produzione == .defaultValue
                                }//.fixedSize()*/
                        }
                        
                        HStack {
                            
                            CS_Picker(selection: $ingredient.origine, customLabel: "Origine", dataContainer: OrigineIngrediente.allCases, backgroundColor: Color.white, opacity: 0.5)
                                .csWarningModifier(isPresented: checkError) {
                                    self.ingredient.origine == .defaultValue
                                }//.fixedSize()


                            CS_PickerWithDefault(selection: $ingredient.provenienza, customLabel: "Provenienza(?)", dataContainer: ProvenienzaIngrediente.allCases, backgroundColor: Color.white, opacity: 0.5)
                                .fixedSize()
                             /*   .csWarningModifier(isPresented: checkError) {
                                    self.ingredient.provenienza == .defaultValue
                                }//.fixedSize() */
                          Spacer()
                            
                            CSMenuAllergeni_MultiSelection(ingredient: $ingredient)
                                ._tightPadding()
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(isIngredientOld ? 0.2 : 0.5))
                                        .shadow(radius: isIngredientOld ? 0.0 : 5.0)
                                )
                            
                        }
                    }
                    .disabled(isIngredientOld)
                    //.blur(radius: isIngredientOld ? 0.8 : 0.0)
                    
                    VStack(alignment:.leading,spacing:4) {
                        
                        HStack(alignment:.center) {
                            
                            Image(systemName: "thermometer.snowflake")
                                .imageScale(.small)
                            
                            if self.ingredient.conservazione == .defaultValue {
                                
                                Text("Metodo di conservazione non indicato")
                                    .italic()
                                    .fontWeight(.semibold)
                                    .font(.caption)
                                    .foregroundStyle(Color.black)
                            } else {
                                Text(ingredient.conservazione.extendedDescription())
                                    .italic()
                                    .fontWeight(.semibold)
                                    .font(.caption)
                                    .foregroundStyle(Color.black)
                            }
                            
                        }
                        
                        vbAllergeneScrollRowView(listaAllergeni: self.ingredient.allergeni)
                      /*  HStack(alignment:.bottom) {
                            
                            Image(systemName: "allergens")
                                .imageScale(.small)

                            ScrollView(.horizontal,showsIndicators: false) {
                                
                                HStack(alignment:.bottom) { vbAllergeneScrollRowView(listaAllergeni: self.ingredient.allergeni) }
                                
                                }
                        } */
                    }
                }
                .onChange(of: self.ingredient.allergeni) {
                    self.areAllergeniOk = false
                }
                .padding(.top,10) // o .Vertical
  
      //  }
     
    }
    
    // Method

   @ViewBuilder private func vbOrigineIcon() -> some View {
        
       let allergeni = self.ingredient.allergeni ?? []
    
       if self.ingredient.origine != .defaultValue {
           
           if allergeni.isEmpty {
               let image = self.ingredient.origine.imageAssociated()
               csVbSwitchImageText(string: image, size: .large)
               
           } else {
               let image = iterateAllergeni()
               csVbSwitchImageText(string: image, size: .large)
               Image(systemName: "allergens")
                   .imageScale(.small)
                   .foregroundStyle(Color.black)
           }
           
       } else { EmptyView() }
    }
    
    private func iterateAllergeni() -> String {
        
        let allergeni = self.ingredient.allergeni ?? []
        var image = self.ingredient.origine.imageAssociated()
        
        if allergeni.contains(.latte_e_derivati) { image = "🥛"}
        else if allergeni.contains(where: {
            $0 == .pesce || $0 == .crostacei || $0 == .molluschi
        }) { image = "🐟"}
        
        return image
    }
    
    @ViewBuilder private func vbConservazioneIcon() -> some View {
        
        switch ingredient.conservazione {
            
        case .congelato, .surgelato:
            let image = ingredient.conservazione.imageAssociated()
            csVbSwitchImageText(string: image, size: .large)
                .foregroundStyle(Color.white)
            
        default:
            EmptyView()
        }
  
    }
    
  /*  @ViewBuilder private func vbAllergeneCheck() -> some View {
        
        if ingredient.allergeni.isEmpty { EmptyView() }
        else {
            Image(systemName: "allergens")
                .imageScale(.small)
                .foregroundStyle(Color.black.opacity(0.8))
        }
        
    } */ // deprecata 24.08
    
    @ViewBuilder private func vbProduzioneCheck() -> some View {
        
        switch self.ingredient.produzione {
            
        case .biologico:
            Text("Bio")
                .font(.system(.caption2, design: .monospaced, weight: .black))
                .foregroundStyle(Color.green)
        default:
            EmptyView()
            
        }
        
    }
    
    /*
    @ViewBuilder private func vbAllergeneBottomRow() -> some View {
        
        if ingredient.allergeni.isEmpty {
         
                Text("Nessun Allergene Specificato")
                   .fontWeight(.semibold)
                   .font(.caption2)
                   .foregroundStyle(Color.black.opacity(0.8))
        
        } else {
            
            let listaAllergeni:[String] = estrapolaListaAllergeni()
            
            Text(listaAllergeni,format: .list(type: .and))
                .italic()
                .fontWeight(.light)
                .font(.caption2)
                .foregroundStyle(Color.black)
  
            }
        
    }
    
    private func estrapolaListaAllergeni() -> [String] {
        
        var listaAllergeni:[String] = []
        
        for allergene in self.ingredient.allergeni {
            
            let allergeneName = allergene.simpleDescription()
            listaAllergeni.append(allergeneName)
            
        }
        
        return listaAllergeni
    } */
    
    
    @ViewBuilder private func vbMainRow() -> some View {

        if self.isIngredientOld {

            Text(ingredient.intestazione)
                .fontWeight(.light)
                .font(.title3)
                .foregroundStyle(Color.black)
                .opacity(0.8)
 
        } else {
            
            Text(ingredient.intestazione)
                .fontWeight(.light)
                .font(.title3)
                .foregroundStyle(Color.black)
                .overlay(alignment:.topTrailing) {
                    Text("New")
                        .font(.caption2)
                        .foregroundStyle(Color.white)
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
