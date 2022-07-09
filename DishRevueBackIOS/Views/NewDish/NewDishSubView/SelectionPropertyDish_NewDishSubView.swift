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
    
    @State private var confermaDiete: Bool = false
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            VStack {
                
                CSLabel_1Button(placeHolder: "Allergeni Presenti", imageNameOrEmojy: "exclamationmark.triangle",imageColor: Color.yellow, backgroundColor: Color.black)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    if newDish.allergeni.isEmpty {
                        
                        Text("Nessun Allergene Indicato negli Ingredienti")
                            .italic()
                            .fontWeight(.light)
                            .font(.caption)
                            .foregroundColor(Color.black)
                        
                    } else {
                        
                        HStack {
                            
                            ForEach(newDish.allergeni) { allergene in
                                
                                CSText_tightRectangle(testo: allergene.simpleDescription(), fontWeight: .light, textColor: Color.red, strokeColor: Color.red, fillColor: Color.clear)
                                
                            }
                        }
                    }
                    
                }
                
            }
            
            VStack(alignment: .leading) {
                
                CSLabel_conVB(placeHolder: "Categoria Menu", imageNameOrEmojy: "list.bullet.below.rectangle", backgroundColor: Color.black) {
                    
                    NavigationLink(value: DestinationPathView.categoriaMenu) {
                        Image(systemName: "arrow.up.forward.app")
                            .imageScale(.medium)
                            .foregroundColor(Color("SeaTurtlePalette_3"))
                    }
                    
                }
                
                PropertyScrollCases(cases:viewModel.categoriaMenuAllCases, dishSingleProperty: self.$newDish.categoriaMenu, colorSelection: Color.green.opacity(0.8))
                
            }
            
            VStack {
                
              /*  CSLabel_1Button(placeHolder: "Adatto ad una dieta", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black) */
                CSLabel_conVB(placeHolder: "Dieta", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black) {
                 
                    Toggle(isOn: $confermaDiete) {
                      
                        HStack {
                           Spacer()
                            Image(systemName: confermaDiete ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(confermaDiete ? Color.green : Color.gray)
                               // .imageScale(.small)
                            Text(confermaDiete ? "Confermato" : "Non Confermato")
                        }
                       
                    }
                }
                
                DietScrollCasesCmpatibility(currentDish: newDish)
                
              /*  PropertyScrollCasesPlus(cases: DishTipologia.allCases, dishCollectionProperty: newDish.tipologiaDieta) */
                
                
                /*   ScrollView(.horizontal, showsIndicators: false) {
                 
                 HStack {
                 
                 ForEach(newDish.tipologiaDieta) { dieta in
                 
                 CSText_tightRectangle(testo: dieta.simpleDescription(), fontWeight: .light, textColor: Color.white, strokeColor: Color.gray, fillColor: Color.clear)
                 /*  .onTapGesture {
                  self.descrizioneDieta = dieta.extendedDescription() ?? ""
                  self.mostraDescrizioneDieta.toggle()
                  } */
                 
                 }
                 }
                 
                 } */
                
             /*   if self.mostraDescrizioneDieta {
                    
                    Text(descrizioneDieta)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .italic()
                        .foregroundColor(Color.black)
                    
                }*/
                
            }
            
          /*  VStack(alignment:.leading) {
                
                CSLabel_1Button(placeHolder: "Adattabile ad una dieta", imageNameOrEmojy: "person.fill", backgroundColor: Color.black)
                
                PropertyScrollCases(cases: DishAvaibleFor.allCases, dishCollectionProperty: self.$newDish.avaibleFor, colorSelection: Color.blue.opacity(0.8))
                
                showExtendedDescription()
            } */
            
            
        }
    }
    
   /* @ViewBuilder private func showExtendedDescription() -> some View {
        
        VStack(alignment:.leading) {
            
            ForEach(self.newDish.avaibleFor) { diet in
                
                Text(diet.extendedDescription() ?? "")
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundColor(Color.black)
                
            }
            
        }
        
    } */
    
}
/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
