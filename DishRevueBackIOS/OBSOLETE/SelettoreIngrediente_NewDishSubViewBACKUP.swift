//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI

// 04.03.2022 Selettore Ingrediente che usa i Generics per fa convivere sia il ModelloIngrediente che il BaseModelloIngrediente. Rivelatosi inutile, poichè invece di convertire il baseModello nel Modello ogni volta che un ingrediente base viene scelto, procediamo con una conversione di tutti i baseModello prima dell'init della View, ossia in fase di download del json

/*struct SelettoreIngrediente_NewDishSubViewBACKUP: View {
    
    @ObservedObject var propertyVM: PropertyVM
  //  @Binding var newDish: DishModel
 
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    @State private var switchList: Bool = false

    // Liste Temporanee come preListe manipolabili localmente
    
    @State private var temporarySelectionModelloIngrediente: [String:[ModelloIngrediente]] = ["IngredientiPrincipali":[], "IngredientiSecondari":[]]
    @State private var temporarySelectionBaseModIngrediente: [String:[BaseModelloIngrediente]] = ["IngredientiPrincipali":[], "IngredientiSecondari":[]]

    private var ingredientiPrincipaliCount:Int {
        
        temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.count + temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.count
        
    }
    
    private var ingredientiSecondariCount:Int {
        
        temporarySelectionModelloIngrediente["IngredientiSecondari"]!.count + temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.count
        
    }
    
    // Test
    @State private var testHover: Color = .white
    
  //  let action: (_ ingrediente: ModelloIngrediente) -> Void
    
    var body: some View {

        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                
                HStack{
                    
                    Text("Ingredienti Principali")
                        .fontWeight(.semibold)
                    Spacer()
                    
                    Text("(\(ingredientiPrincipaliCount))")
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    Image(systemName:"circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.mint)
        
                }._tightPadding()
            //    Divider()
                
                HStack {
                    
                    Text("Ingredienti Secondari")
                        .fontWeight(.semibold)
                    Spacer()
                    
                    Text("(\(ingredientiSecondariCount))")
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    Image(systemName:"circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.orange)
                     
                }._tightPadding()
                
            }
            .padding(.horizontal)
            .padding(.top)
            
    
            SwitchListeIngredienti(switchList: $switchList)
                .padding()
                .background(Color.cyan.opacity(0.5))

             ScrollView {
                
                VStack(alignment:.leading) {
                                
                             //   Divider()
            
                                if !switchList {
                                    
                                    MostraIngredientiGenerics(listaDaMostrare: propertyVM.listaBaseModelloIngrediente) {
                                                                    ingredient in
                        
                                            self.discoverIngredientAttribute(ingredient: ingredient).imageColor
                         
                                    } action: { ingredient in
                                        
                                        self.addIngredientsTemporary(ingredient: ingredient)
                                        
                                    }
                                    
                                } else {
                                    
                                    MostraIngredientiGenerics(listaDaMostrare: propertyVM.listaMyIngredients) { ingredient in
                                        
                                        self.discoverIngredientAttribute(ingredient: ingredient).imageColor
                                        
                                        
                                    } action: { ingredient in
                                        
                                       self.addIngredientsTemporary(ingredient: ingredient)
                                        
                                    }
                                    
                                }
                      
                            }.padding(.horizontal)
             }
            // .refreshable -> per aggiornare, ma forse funziona solo con List
            
            CSButton_2(title: "Aggiungi", accentColor: testHover, backgroundColor: Color.cyan.opacity(0.5), cornerRadius: 0.0) {
                
                // Action
            }
  
            
            
        }
        .background(Color.white.opacity(0.8).cornerRadius(20.0).shadow(radius: 5.0))
        .frame(width: (screenHeight * 0.40))
        .frame(height: screenHeight * 0.60 )
  
    }
    
    // Methodi
    
  /* @State private var temporarySelectionModelloIngrediente: [String:[ModelloIngrediente]] = ["IngredientiPrincipali":[], "IngredientiSecondari":[]]
   
    @State private var temporarySelectionBaseModIngrediente: [String:[BaseModelloIngrediente]] = ["IngredientiPrincipali":[], "IngredientiSecondari":[]] */
    
    private func fillNewDishIngredients() {
        
        
        
        
        
        
    }
    
    
    private func addIngredientsTemporary<G:IngredientConformation>(ingredient: G) {

        let((_,_),ingredientType,ingredientKey) = discoverIngredientAttribute(ingredient: ingredient)
      
        if ingredientType == "ModelloIngrediente" {
            
            if ingredientKey == "" {
                
                temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.append(ingredient as! ModelloIngrediente)
                
            }
            
            else if ingredientKey == "IngredientiPrincipali" {
                
            let index = temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.firstIndex(of: ingredient as! ModelloIngrediente)
                
                temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.remove(at: index!)
                temporarySelectionModelloIngrediente["IngredientiSecondari"]!.append(ingredient as! ModelloIngrediente)
                
            }
            
            else {
                
                let index = temporarySelectionModelloIngrediente["IngredientiSecondari"]!.firstIndex(of: ingredient as! ModelloIngrediente)
                temporarySelectionModelloIngrediente["IngredientiSecondari"]!.remove(at: index!)
                
            }
            
        } else if ingredientType == "BaseModelloIngrediente" {
            
            
            if ingredientKey == "" {
                
                temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.append(ingredient as! BaseModelloIngrediente)
                
            }
            
            else if ingredientKey == "IngredientiPrincipali" {
                
            let index = temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.firstIndex(of: ingredient as! BaseModelloIngrediente)
                
                temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.remove(at: index!)
                temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.append(ingredient as! BaseModelloIngrediente)
                
            }
            
            else {
                
                let index = temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.firstIndex(of: ingredient as! BaseModelloIngrediente)
                temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.remove(at: index!)
                
            }
                    
        }

    }
    
    
    private func discoverIngredientAttribute<G:IngredientConformation>(ingredient: G) -> (imageColor:(Color,String), type: String, key: String) {
    
        if let value = ingredient as? ModelloIngrediente {
            
            if temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.contains(value) {return ((Color.mint, "circle.fill"),"ModelloIngrediente","IngredientiPrincipali")}
            
            else if temporarySelectionModelloIngrediente["IngredientiSecondari"]!.contains(value) {return ((Color.orange, "circle.fill"),"ModelloIngrediente","IngredientiSecondari")}
            
            else {return ((Color.black, "circle"),"ModelloIngrediente","")}
  
        } else if let value = ingredient as? BaseModelloIngrediente {
            
            if temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.contains(value) {return ((Color.mint, "circle.fill"),"BaseModelloIngrediente","IngredientiPrincipali")}
            
            else if temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.contains(value) {return ((Color.orange,"circle.fill"),"BaseModelloIngrediente","IngredientiSecondari")}
            
            else {return ((Color.black, "circle"),"BaseModelloIngrediente","") }
                    
        } else { return ((Color.clear,"circle"),"","" )}
    
    }
      
}

struct SelettoreIngrediente_NewDishSubViewBACKUP_Previews: PreviewProvider {
    
    static var propertyVM: PropertyVM = PropertyVM()
    
    static var previews: some View {
        
        ZStack {
            Color.cyan.opacity(0.8)
            Group{
                VStack{
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                }
                .padding()
                .foregroundColor(Color.white)
        
            }
        
            SelettoreIngrediente_NewDishSubViewBACKUP(propertyVM: propertyVM)
               
            
            /*{ ingrediente in
                //
            } */
        }.onTapGesture {
            SelettoreIngrediente_NewDishSubViewBACKUP_Previews.test()
        }
       
    }
    
    static func test() {
        
        for x in 1...20 {
            
        var ingrediente = ModelloIngrediente()
            
            ingrediente.nome = "\(x.description)' ingredient"
            
            propertyVM.listaMyIngredients.append(ingrediente)
            
        }
        
    }
    
}

struct MostraIngredientiGenericsBACKUP<G:IngredientConformation>:View {
    
    var listaDaMostrare: [G]
    
    let attributeIngredient: (_ ingredient: G) -> (colore: Color,image: String)
    let action: (_ ingredient: G) -> Void
    
    var body: some View {
        
        
        ForEach(listaDaMostrare) { ingrediente in

            HStack {
                
                Text(ingrediente.nome)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
     
               Spacer()
                
                Image(systemName: self.attributeIngredient(ingrediente).image)
                    .imageScale(.large)
                    .foregroundColor(self.attributeIngredient(ingrediente).colore)
                    .onTapGesture {
                        
                        withAnimation {
                            action(ingrediente)
                        }
           
                    }
  
            }
            ._tightPadding()

            Divider()
    
        }
  
    }
}

struct SwitchListeIngredientiBACKUP: View {
    
    @Binding var switchList: Bool
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Text("Miei Ingredienti")
                .fontWeight(switchList ? .bold : .light)
                .onTapGesture {
                    
                    withAnimation(.easeOut) {
                        self.switchList = true
                    }
                }
            
            Spacer()
            
            Text("Altro")
                .fontWeight(switchList ? .light : .bold)
                .onTapGesture {
                
                    withAnimation(.easeOut) {
                        self.switchList = false
                    }
                }
            
            Spacer()
        }
       
    }
}

*/
