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

    @EnvironmentObject var viewModel: AccounterVM
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
                            
                           /* BottomViewGeneric_NewModelSubView(
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
                                }*/
                            
                            BottomDialogView {
                                self.infoIngrediente()
                            } disableConditions: {
                                self.disableCondition()
                            } secondaryAction: {
                                self.resetAction()
                            } preDialogCheck: {
                                let check = checkPreliminare()
                                if check { return check }
                                else {
                                    self.generalErrorCheck = true
                                    return false 
                                }
                            } primaryDialogAction: {
                                self.saveButtonDialogView()
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
                .foregroundStyle(Color.black)
                .opacity(0.6)
              //  .padding(.horizontal)
                   
            }
            .csHpadding()
            //.padding(.horizontal,10)
            .popover(isPresented: $wannaAddAllergeni,attachmentAnchor: .point(.top),arrowEdge: .bottom) {
                VistaAllergeni_Selectable(
                    allergeneIn: $nuovoIngrediente.allergeni,
                    backgroundColor: backgroundColorView)
                .presentationDetents([.large])
            }
    
       }
      // .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
    }
    // Method
    private func disableCondition() -> (general:Bool?,primary:Bool,secondary:Bool?) {
        
       let general = self.nuovoIngrediente == self.ingredienteArchiviato
        return (general,false,false)
    }
    
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
    
    private func infoIngrediente() -> (breve:Text,estesa:Text) {
        
       let string = csInfoIngrediente(
        areAllergeniOk: self.areAllergeniOk,
        nuovoIngrediente: self.nuovoIngrediente)
        
        return (Text("breve"),Text(string))
    }
    
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else {
            self.modelField = .intestazione
            return false }
        
        guard checkOrigine() else { return false }
        
        guard self.areAllergeniOk else { return false }
        
        guard checkConservazione() else { return false }

        if self.nuovoIngrediente.optionalComplete() {
            self.nuovoIngrediente.status = .completo(.disponibile) }
        else {
            self.nuovoIngrediente.status = .bozza(.disponibile)
        }

        return checkNotExistSimilar()
       // return true
    }
    
    private func checkNotExistSimilar() -> Bool {
        
        if self.viewModel.checkModelNotInVM(itemModel: nuovoIngrediente) { return true }
        else {
            self.viewModel.alertItem = AlertModel(
                 title: "Controllare",
                 message: "Hai già creato un Ingrediente con questo nome e caratteristiche")
             
           return false
            }
    }
    
    private func checkOrigine() -> Bool {
        
         self.nuovoIngrediente.origine != .defaultValue
        
    }
    
    private func checkIntestazione() -> Bool {
    
         self.nuovoIngrediente.intestazione != ""
   
    }
    
    private func checkConservazione() -> Bool {
        
        self.nuovoIngrediente.conservazione != .defaultValue
    }
    
    // ViewBuilder
    
    @ViewBuilder private func saveButtonDialogView() -> some View {

        csBuilderDialogButton {
          
            // nuovo ingrediente
            DialogButtonElement(
                label: .saveNew) {
                    self.ingredienteArchiviato.intestazione == ""
                } action: {
                    
                   /* self.viewModel.createModel(
                        itemModel: self.nuovoIngrediente)*/
                    Task {
                       try await self.viewModel.createIngredient(item: self.nuovoIngrediente) { _ in }
                            
                        self.salvaECreaPostAction()
                    }
                }

            DialogButtonElement(
                label: .saveEsc) {
                    self.ingredienteArchiviato.intestazione == ""
                } action: {
                    
                   /* self.viewModel.createModel(
                        itemModel: self.nuovoIngrediente,
                        refreshPath: self.destinationPath)*/
                    Task {
                       try await self.viewModel.createIngredient(
                            item: self.nuovoIngrediente,
                            refreshPath: self.destinationPath) { _ in }
                    }
                }
            
           // Modifica
            
            DialogButtonElement(
                label: .saveModNew) {
                    self.ingredienteArchiviato.intestazione != ""
                } action: {
                    
                   /* self.viewModel.updateModel(
                        itemModel: self.nuovoIngrediente)*/
                    self.viewModel.updateIngredient(item: self.nuovoIngrediente)
                    self.salvaECreaPostAction()
                }
            
            DialogButtonElement(
                label: .saveModEsc) {
                    self.ingredienteArchiviato.intestazione != ""
                } action: {
                    
                   /* self.viewModel.updateModel(
                        itemModel: self.nuovoIngrediente,
                        refreshPath: self.destinationPath)*/
                    self.viewModel.updateIngredient(
                        item: self.nuovoIngrediente,
                        refreshPath: self.destinationPath)
                }
            
            // nuovo da modifica
            
            DialogButtonElement(
                label: .saveAsNew,
                extraLabel: "Ingrediente") {
                    self.ingredienteArchiviato.intestazione != "" &&
                    self.nuovoIngrediente.intestazione != self.ingredienteArchiviato.intestazione
                } action: {
                    
                    Task {
                        var new = self.nuovoIngrediente
                        new.id = UUID().uuidString

                       /* self.viewModel.createModel(
                            itemModel: new,
                            refreshPath: self.destinationPath)*/
                       try await self.viewModel.createIngredient(item: new) { _ in }
                    }
                    
                    
                }
            
            
        } // chiusa result builder
        
        
        
        
    }
 
    
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
