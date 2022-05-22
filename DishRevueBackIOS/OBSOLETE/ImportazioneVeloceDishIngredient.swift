//
//  ImportazioneVeloceDishIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/05/22.
//

import SwiftUI
/* // BACKUP 21.05
struct ImportazioneVeloceDishIngredient: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var fastDish: DishModel = DishModel()
    
    let backgroundColorView: Color
    @State private var text: String = ""
    
    @State private var isUpdateDisable: Bool = true
    @State private var showSubString: Bool = false
    
    var isCreationDisabled:Bool {
        
        self.fastDish.categoria == .defaultValue
        
    }
    
    var body: some View {
        
        CSZStackVB(title: "Importazione Rapida", backgroundColorView: backgroundColorView) {
            
            VStack {
                
                CSDivider(isVisible: true)
                
                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading) {

                        CSDivider(isVisible: true) // senza il testo del texeditor va su e si disallinea
                      
                        TextEditor(text: $text)
                            .font(.system(.body,design:.rounded))
                            .foregroundColor(Color.black)
                            .autocapitalization(.sentences)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                            .csTextEditorBackground {
                                Color.white.opacity(0.2)
                            }
                            .cornerRadius(5.0)
                            .frame(height: 150)
                            .onChange(of: text) { _ in
                             self.isUpdateDisable = false
                            }
                
                        HStack {
                            
                            CSButton_tight(title: "Estrai", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.mint) {
                                estrapolaStringhe()
                                csHideKeyboard()
                                self.isUpdateDisable = true
                                withAnimation {
                                    showSubString = true
                                }
                            }
                            .opacity(self.isUpdateDisable ? 0.6 : 1.0)
                            .disabled(self.isUpdateDisable)
 
                            Spacer()
                            
                            CSButton_tight(title: "Salva", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                                fastImport()
                            }
                            .opacity(self.isCreationDisabled ? 0.6 : 1.0)
                            .disabled(self.isCreationDisabled)
                            
                        } // Barra dei Bottoni
                        
                        if showSubString {
                            
                            CorpoImportazioneVeloce(fastDish: $fastDish)
                        }
                       
                        
                Spacer()
                       // Text("\(manipolaStringa())")
                    }.padding(.horizontal)
                    
                }
                
              //  Spacer()
                
                
                
            }
            
           
            
            
        }
        
   
        
        
    }
    
    // Method
    
    private func fastImport() { // METODO PER FASE TEST -> DA ELIMINARE
        
        viewModel.allMyDish.append(self.fastDish)
        viewModel.allMyIngredients.append(contentsOf: self.fastDish.ingredientiPrincipali)
        
    }
    
    private func estrapolaStringhe() {
         
     let step_1 = self.text.replacingOccurrences(of: "  ", with: " ")
     let step_2 = step_1.replacingOccurrences(of: ", ", with: ",")
     let step_3 = step_2.replacingOccurrences(of: " ,", with: ",")
     let step_3b = step_3.replacingOccurrences(of: "*", with: "")
     var step_4 = step_3b.split(separator: ",")
    
     let dishTitle = String(step_4[0])
     step_4.remove(at: 0)
     var step_5:[IngredientModel] = []
    
     for subString in step_4 {
      
      let string = String(subString)
      let ingredient = IngredientModel(nome: string)
      step_5.append(ingredient)
      
      }
     
    self.fastDish = {
        
        var dish = DishModel()
        
        dish.intestazione = dishTitle
        dish.ingredientiPrincipali = step_5
        return dish
    
    }()
        print("Dentro EstrapolaStringhe")
     
    }
    
    
    
}

struct ImportazioneVeloceDishIngredient_Previews: PreviewProvider {
    static var previews: some View {
    
        NavigationView {
            ImportazioneVeloceDishIngredient(backgroundColorView: Color.cyan)
                
        }
         //   Color.cyan
    
    }
}

struct RapidEntryRow: View {

    @Binding var ingredient: IngredientModel
    let wannaAddAllergeni: Bool
    @State private var openAllergeni: Bool? = false
    
    var body: some View {
        
        ZStack {
                
                VStack(alignment:.leading) {
                    
                    HStack {
                        
                        CSText_tightRectangle(testo: ingredient.intestazione, fontWeight: .light, textColor: Color.black, strokeColor: Color.clear, fillColor: Color.clear)
                        
                        Spacer()
                        
                        Text("Open")
                            .onTapGesture {
                                self.openAllergeni?.toggle()
                            }.disabled(!wannaAddAllergeni)
                        
                    }
                    
                    HStack {
                        
                        Image(systemName: "allergens")
                            .imageScale(.small)
                        
                        ForEach(ingredient.allergeni) { allergene in
                            
                            Text(allergene.simpleDescription())
                                .font(.caption2)
                            
                        }
                        
                    }
                    
                }

            
            if self.openAllergeni! {
                
                SelettoreMyModel<_,Allergeni>(
                    itemModel: $ingredient,
                    allModelList: [
                        .viewModelContainer("Elenco Allergeni", \.allergeni,.fonte),
                        .itemModelContainer("Allergeni \(ingredient.intestazione)", \IngredientModel.allergeni, .destinazione(Color.red, grado: .principale))
                    
                    ],
                    closeButton: $openAllergeni)
                
            }
            
            
            
        }
    
        
    }
    
}

struct CorpoImportazioneVeloce:View {
    
    @Binding var fastDish: DishModel
    @State private var wannaAddAllergeni: Bool = false

    var body: some View {
        
        VStack(alignment:.leading) {

                CSLabel_1Button(placeHolder: "Nome Piatto", imageNameOrEmojy: "fork.knife.circle", backgroundColor: Color.black)
  
                VStack(alignment:.leading) {
                           
                    HStack {
                        
                        CSText_tightRectangle(testo: fastDish.intestazione, fontWeight: .semibold, textColor: Color.white, strokeColor: Color.blue, fillColor: Color.yellow)
                        
                        Spacer()
                        
                        CS_Picker(selection: $fastDish.categoria, dataContainer: DishCategoria.allCases)
         
                        }

                    HStack {
                        
                        csVbSwitchImageText(string: fastDish.categoria.imageAssociated())
                            .font(.subheadline)
                        
                        Text(fastDish.categoria.simpleDescriptionSingolare())
                            .font(.system(.subheadline, design: .monospaced))
                            
                        
                            }
                           
                       }

            CSLabel_1Button(placeHolder: "Ingredienti:", imageNameOrEmojy: "leaf", backgroundColor: Color.black)
            
            CSLabel_conVB(placeHolder: "Ingredienti:",imageNameOrEmojy: "leaf", backgroundColor: Color.black) {
               
                Toggle(isOn: $wannaAddAllergeni) {
                    Text("Allergeni")
                }
               
            }
            
            
                
            ForEach($fastDish.ingredientiPrincipali) { $ingredient in
                     
                    RapidEntryRow(ingredient: $ingredient, wannaAddAllergeni: wannaAddAllergeni)
                    Divider()
                     
                    }
         
            }

    }
    
}
 */
