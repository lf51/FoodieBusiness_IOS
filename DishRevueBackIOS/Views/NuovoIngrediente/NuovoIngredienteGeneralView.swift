//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//
import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct NuovoIngredienteGeneralView: View {

   // @EnvironmentObject var viewModel: AccounterVM
    @Environment(\.openURL) private var openURL

    @State private var nuovoIngrediente: IngredientModel
    let backgroundColorView: Color
    
    @State private var ingredienteArchiviato: IngredientModel // per il reset
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    
  //  @State private var isConservazioneOk: Bool = false
    @State private var areAllergeniOk: Bool = false
    @State private var wannaAddAllergeni: Bool = false
    
    // test
    
  //  @State private var idRiserva: String = "Niente"
    //
    
    init(nuovoIngrediente: IngredientModel,backgroundColorView: Color,destinationPath:DestinationPath) {
      // test 18.08
        
       // let new = IngredientModel()
      //  _nuovoIngrediente = State(wrappedValue: new)
        
        // chiusa Test
        _nuovoIngrediente = State(wrappedValue: nuovoIngrediente)
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
        
        _ingredienteArchiviato = State(wrappedValue: nuovoIngrediente)
       
    }
    
    // 17.02.23 Focus State
    @FocusState private var modelField:ModelField?
    
    var body: some View {
        
        CSZStackVB(title:self.nuovoIngrediente.intestazione == "" ? "Nuovo Ingrediente" : self.nuovoIngrediente.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                    
                   // CSDivider()
                ProgressView(value: self.nuovoIngrediente.countProgress) {
                    Text("Completo al: \(self.nuovoIngrediente.countProgress,format: .percent)")
                        .font(.caption)
                }//.csHpadding()
                    
                    ScrollView(showsIndicators: false) {
                      
                        VStack(alignment:.leading,spacing: .vStackBoxSpacing){
                            
                            IntestazioneNuovoOggetto_Generic(
                                itemModel: $nuovoIngrediente,
                                generalErrorCheck: generalErrorCheck,
                                minLenght: 3,
                                coloreContainer:.seaTurtle_3)
                            .focused($modelField, equals: .intestazione)
                               
                            BoxDescriptionModel_Generic(
                                itemModel: $nuovoIngrediente,
                                labelString: "Descrizione (Optional)",
                                disabledCondition: wannaAddAllergeni,
                                modelField: $modelField)
                            .focused($modelField, equals: .descrizione)
                            
                            // Origine
                            OrigineScrollView_NewIngredientSubView(
                                nuovoIngrediente: $nuovoIngrediente,
                                generalErrorCheck: generalErrorCheck)
                           
                            
                            // Allergeni
                            AllergeniScrollView_NewIngredientSubView(
                                nuovoIngrediente: self.$nuovoIngrediente,
                                generalErrorCheck: generalErrorCheck,
                                areAllergeniOk: $areAllergeniOk,
                                wannaAddAllergene: $wannaAddAllergeni)
                            
                            ConservazioneScrollView_NewIngredientSubView(
                            nuovoIngrediente: $nuovoIngrediente,
                            generalErrorCheck: generalErrorCheck)
                            
                            ProduzioneScrollView_NewIngredientSubView(
                                nuovoIngrediente: $nuovoIngrediente)
                            
                            ProvenienzaScrollView_NewIngredientSubView(
                                nuovoIngrediente: $nuovoIngrediente)

                            // Sostituto
                            
                           /* SostituzioneIngredienteView_NewIngredientSubView(nuovoIngrediente: $nuovoIngrediente) */ // Deprecato 06.08
                            
                            // end View Sostituto
                            
                            BottomViewGeneric_NewModelSubView(
                                itemModel: $nuovoIngrediente,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: ingredienteArchiviato,
                                destinationPath: destinationPath) {
                                    self.infoIngrediente()
                                } resetAction: {
                                    self.resetAction()
                                } checkPreliminare: {
                                    self.checkPreliminare()
                                } salvaECreaPostAction: {
                                    self.salvaECreaPostAction()
                                }

                        }//.padding(.horizontal)
                      
                    }
                    .scrollDismissesKeyboard(.immediately)
                  //  .zIndex(0)
                   // .opacity(wannaAddAllergeni ? 0.6 : 1.0)
                   // .disabled(wannaAddAllergeni)

                 /*   if wannaAddAllergeni {
               
                        SelettoreMyModel<_,AllergeniIngrediente>(
                            itemModel: $nuovoIngrediente,
                            allModelList: ModelList.ingredientAllergeniList,
                            closeButton: $wannaAddAllergeni,
                            backgroundColorView: backgroundColorView,
                            actionTitle: "Normativa") {
                                if let url = URL(string: "https://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2011:304:0018:0063:it:PDF") {
                                                openURL(url)
                                            }
                            }
                        
                    } */
                   
            //   CSDivider()
                    
                HStack {
                    Spacer()
                    Text(nuovoIngrediente.id)
                        
                    Image(systemName: nuovoIngrediente.id == ingredienteArchiviato.id ? "equal.circle" : "circle")
                }
                .font(.caption2)
                .foregroundColor(Color.black)
                .opacity(0.6)
              //  .padding(.horizontal)
                   
            }
            .csHpadding()
            //.padding(.horizontal,10)
            .popover(isPresented: $wannaAddAllergeni,attachmentAnchor: .point(.top),arrowEdge: .bottom) {
                VistaAllergeni_Selectable(
                    allergeneIn: $nuovoIngrediente.allergeni,
                    backgroundColor: backgroundColorView)
                .presentationDetents([.height(500)])
            }
    
       }
      // .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
    }
    // Method
    
    private func resetAction() {
        
        self.nuovoIngrediente = self.ingredienteArchiviato
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        
    }
    
    private func salvaECreaPostAction() {
        
        self.generalErrorCheck = false
        self.areAllergeniOk = false
      // self.isConservazioneOk = false
        
        let new = IngredientModel()
        
        self.nuovoIngrediente = new
        self.ingredienteArchiviato = new
    }
    
    private func infoIngrediente() -> Text {
       let string = csInfoIngrediente(areAllergeniOk: self.areAllergeniOk, nuovoIngrediente: self.nuovoIngrediente)
        return Text(string)
    }
    
  /*  private func infoIngrediente() -> Text {
        
        var stringaAlllergeni: String = "Presenza/assenza Allergeni non Confermata"
        var stringaCongeSurge: String = "\nMetodo di Conservazione non indicato"
        var metodoProduzione: String = ""
        
        if areAllergeniOk {
            
            if self.nuovoIngrediente.allergeni.isEmpty {
                stringaAlllergeni = "Questo ingrediente è privo di Allergeni."
            } else {
    
                let count = self.nuovoIngrediente.allergeni.count
                stringaAlllergeni = "Questo ingrediente contiene \(count > 1 ? "\(count) Allergeni" : "1 Allergene")."
            }
        }
        
        if self.nuovoIngrediente.conservazione != .defaultValue {
            
             stringaCongeSurge = "\nQuesto prodotto \( self.nuovoIngrediente.conservazione.extendedDescription())."
            
        }
        
        if self.nuovoIngrediente.produzione == .biologico {
            metodoProduzione = "\nProdotto BIO."
        }
        
        return Text("\(stringaAlllergeni)\(stringaCongeSurge)\(metodoProduzione)")
    } */ // Resa Pubblica - 04.10
    
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else {
            self.modelField = .intestazione
            return false }
        
        guard checkOrigine() else { return false }
        
        guard self.areAllergeniOk else { return false }
        
        guard checkConservazione() else { return false }
       // guard self.isConservazioneOk else { return false }
        
      //  guard checkEtichettaProduzione() else { return false }
        
      //  guard checkLuogoProduzione() else { return false }
        

        if self.nuovoIngrediente.optionalComplete() {
            self.nuovoIngrediente.status = .completo(.disponibile) }
        else {
            self.nuovoIngrediente.status = .bozza(.disponibile)
        }
        
      //  self.nuovoIngrediente.status = .completo(.archiviato)
        return true
    }
    
   /* private func checkLuogoProduzione() -> Bool {
        
        self.nuovoIngrediente.provenienza != .defaultValue
    } */
    
    private func checkOrigine() -> Bool {
        
         self.nuovoIngrediente.origine != .defaultValue
        
    }
    
    private func checkIntestazione() -> Bool {
    
         self.nuovoIngrediente.intestazione != ""
   
    }
    
   /* private func checkEtichettaProduzione() -> Bool {
        
        self.nuovoIngrediente.produzione != .defaultValue
    } */
    
    private func checkConservazione() -> Bool {
        
        self.nuovoIngrediente.conservazione != .defaultValue
    }
    
    /*
    @ViewBuilder private func vbScheduleANuovoIngrediente() -> some View {
        
        if self.ingredienteArchiviato.intestazione == "" {
            // crea un Nuovo Oggetto
            Group {
                
                Button("Salva e Crea Nuovo", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoIngrediente)
                self.nuovoIngrediente = IngredientModel()
                    
                }
                
                Button("Salva ed Esci", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoIngrediente,destinationPath: destinationPath)
                }
            }
        }
        
        else if self.ingredienteArchiviato.intestazione == self.nuovoIngrediente.intestazione {
            // modifica l'oggetto corrente
            
            Group { vbEditingSaveButton() }
        }
        
        else {
            
            Group {
                
                vbEditingSaveButton()
                
                Button("Salva come Nuovo Ingrediente", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoIngrediente,destinationPath: destinationPath)
                }
            }
        }
    }
    
    @ViewBuilder private func vbEditingSaveButton() -> some View {
        
        Button("Salva Modifiche e Crea Nuovo", role: .none) {
            
        self.viewModel.updateItemModel(itemModel: self.nuovoIngrediente)
        self.nuovoIngrediente = IngredientModel()
        }
        
        Button("Salva Modifiche ed Esci", role: .none) {
            
        self.viewModel.updateItemModel(itemModel: self.nuovoIngrediente, destinationPath: destinationPath)
        }
        
        
    } */
 
    
}

struct NuovoIngredienteGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationStack {
            
          //  ZStack {
                
              //  Color.cyan.ignoresSafeArea()
                NuovoIngredienteGeneralView(nuovoIngrediente: IngredientModel(), backgroundColorView: Color.seaTurtle_1, destinationPath: .ingredientList)
                  // .cornerRadius(20.0)
                    //.padding(.vertical)
                    
         //   }
            
        }
     
    }
}
