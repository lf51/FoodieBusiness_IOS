//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
// Ultima pulizia codice 01.03.2022

struct SelectionPropertyDish_NewDishSubView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @Binding var newDish: DishModel
    
    @State private var mostraDescrizioneDieta: Bool = false
    @State private var descrizioneDieta: String = ""
    
    @State private var creaNuovaTipologia:Bool = false
    @State private var nuovaTipologia: String = ""
    
    @State private var creaNuovaCottura: Bool? = false
    @State private var nuovaCottura: String = ""
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_1Button(placeHolder: "Allergeni", imageNameOrEmojy: "exclamationmark.triangle", backgroundColor: Color.black)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                    
                    ForEach(newDish.allergeni) { allergene in

                        CSText_tightRectangle(testo: allergene.simpleDescription(), fontWeight: .light, textColor: Color.red, strokeColor: Color.red, fillColor: Color.clear)
                        
                    }
                }
                
            }
            
            Group {
                
             /*   CSLabel_1Button(placeHolder: "Categoria", imageNameOrEmojy: "list.bullet.below.rectangle", backgroundColor: Color.black, toggleBottone: $creaNuovaTipologia)
                
                    if !(creaNuovaTipologia ?? false) {
                        
                        EnumScrollCases(cases: DishCategoria.allCases, dishSingleProperty: self.$newDish.categoria, colorSelection: Color.green.opacity(0.8))
                    }
                    
                else {
                    
                    CSTextField_3(textFieldItem: $nuovaTipologia, placeHolder: "Aggiungi Tipologia") {

                        DishCategoria.allCases.insert(.tipologiaCustom(nuovaTipologia), at: 0)
                        self.nuovaTipologia = ""
                        self.creaNuovaTipologia = false
                        }
                    } */
                
                
              /*  CSLabel_1Button(placeHolder: "Categoria Menu", imageNameOrEmojy: "list.bullet.below.rectangle", backgroundColor: Color.black)*/
                
                CSLabel_conVB(placeHolder: "Categoria Menu", imageNameOrEmojy: "list.bullet.below.rectangle", backgroundColor: Color.black) {
                    
                    NavigationLink {
                        NuovaCategoriaMenu(backgroundColorView: Color("SeaTurtlePalette_1"))
                    } label: {
                        Image(systemName: "arrow.up.forward.app")
                            .imageScale(.medium)
                            .foregroundColor(Color.blue)
                            //.foregroundColor(Color("SeaTurtlePalette_4"))
                    }
                  /*  CSButton_image(frontImage: "arrow.up.forward.app", imageScale: .medium, frontColor: Color.white) {
                        self.creaNuovaTipologia.toggle()
                    } */

                        
                    
                }/*.popover(isPresented: $creaNuovaTipologia) {
                    NuovaCategoriaMenu(backgroundColorView: Color("SeaTurtlePalette_1")).padding(.top)
                } */
                
                
                PropertyScrollCases(cases:viewModel.categoriaMenuAllCases, dishSingleProperty: self.$newDish.categoriaMenu, colorSelection: Color.green.opacity(0.8))
                
                
               /* CSLabel_1Button(placeHolder: "A base di", imageNameOrEmojy: "lanyardcard", backgroundColor: Color.black)
                
                PropertyScrollCases(cases: OrigineIngrediente.allCases, dishSingleProperty: self.$newDish.aBaseDi, colorSelection: Color.indigo.opacity(0.8)) */
                
     
             /*   CSLabel_1Button(placeHolder: "Metodo di cottura", imageNameOrEmojy: "flame", backgroundColor: Color.black, toggleBottone: $creaNuovaCottura)
                
                    if !(creaNuovaCottura ?? false) {
                        
                        PropertyScrollCases(cases: DishCookingMethod.allCases, dishSingleProperty: self.$newDish.metodoCottura, colorSelection: Color.orange.opacity(0.8))
                    
                    } else {
                        
                        CSTextField_3(textFieldItem: $nuovaCottura, placeHolder: "Aggiungi Metodo di Cottura") {
                            
                            DishCookingMethod.allCases.insert(.metodoCustom(nuovaCottura), at: 1) // 1 per tenere sempre il Crudo come Prima Scelta
                            self.nuovaCottura = ""
                            self.creaNuovaCottura = false
                            
                        }
                    } */
            }
            
            Group {
                
                CSLabel_1Button(placeHolder: "Adatto alla dieta", imageNameOrEmojy: "person.fill", backgroundColor: Color.black)
                
                VStack(alignment:.leading) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack {
                            
                            ForEach(newDish.tipologiaDieta) { dieta in

                                CSText_tightRectangle(testo: dieta.simpleDescription(), fontWeight: .light, textColor: Color.white, strokeColor: Color.green, fillColor: Color.clear)
                                    .onTapGesture {
                                        self.descrizioneDieta = dieta.extendedDescription() ?? ""
                                        self.mostraDescrizioneDieta.toggle()
                                    }
                                
                            }
                        }
                        
                    }
                    
                    if self.mostraDescrizioneDieta {
                        
                        Text(descrizioneDieta)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .italic()
                            .foregroundColor(Color.black)
                        
                    }
                    
                }
                
              /*
                CSLabel_1Button(placeHolder: "Adatto alla dieta", imageNameOrEmojy: "person.fill", backgroundColor: Color.black)
                
             //   VStack(alignment:.leading) {
                    PropertyScrollCases(cases: DishTipologia.allCases, dishSingleProperty: self.$newDish.tipologia, colorSelection: Color.green.opacity(0.8))
                  /*  Text(self.newDish.tipologia.extendedDescription())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .italic()
                        .foregroundColor(Color.black) */
             //   }
                
                */
                CSLabel_1Button(placeHolder: "Adattabile alla dieta", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black)
                
                
                
                
                CSLabel_1Button(placeHolder: "Adattabile alla dieta", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black)
                
                PropertyScrollCases(cases: DishAvaibleFor.allCases, dishCollectionProperty: self.$newDish.avaibleFor, colorSelection: Color.blue.opacity(0.8))
         
                
              /*  CSLabel_1Button(placeHolder: "Allergeni Presenti", imageNameOrEmojy: "exclamationmark.triangle", backgroundColor: Color.black)
                
                EnumScrollCases(cases: Allergeni.allCases, dishCollectionProperty: self.$newDish.allergeni, colorSelection: Color.red.opacity(0.8)) */
                
            }
                       
        }
    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
