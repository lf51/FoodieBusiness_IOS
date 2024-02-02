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
  //  @Environment(\.openURL) private var openURL

    @State private var nuovoIngrediente: IngredientModel
    let backgroundColorView: Color
    
    @State private var ingredienteArchiviato: IngredientModel // per il reset
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    @State private var areAllergeniOk: Bool = false
    @State private var wannaAddAllergeni: Bool = false

    @FocusState private var modelField:ModelField?
    
    init(
        nuovoIngrediente: IngredientModel,
        backgroundColorView: Color,
        destinationPath:DestinationPath) {
   
        _nuovoIngrediente = State(wrappedValue: nuovoIngrediente)
        _ingredienteArchiviato = State(wrappedValue: nuovoIngrediente)
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
       
    }
    
   @State private var scrollPosition:Int?
    
    var body: some View {
        
        CSZStackVB(title:self.nuovoIngrediente.intestazione == "" ? "Nuovo Ingrediente" : self.nuovoIngrediente.intestazione, backgroundColorView: backgroundColorView) {
            
           // let asProduct = self.nuovoIngrediente.type == .asProduct
           // let asProduct = self.viewModel.isASubOfReadyProduct(id: self.nuovoIngrediente.id) != nil
           /* let asProduct = self.nuovoIngrediente.getIngredientType(viewModel: self.viewModel) == .asProduct */
            let asProduct = self.nuovoIngrediente.ingredientType == .asProduct
            
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
                            .id(ModelField.intestazione.rawValue)
                            .focused($modelField, equals: .intestazione)
                            .opacity(asProduct ? 0.6 : 1.0)
                            .disabled(asProduct)
                               
                            BoxDescriptionModel_Generic(
                                itemModel: $nuovoIngrediente,
                                labelString: "Descrizione (Optional)",
                                disabledCondition: wannaAddAllergeni,
                                modelField: $modelField)
                            .focused($modelField, equals: .descrizione)
                            
                            // Origine
                            OrigineScrollView_NewIngredientSubView(
                                nuovoIngrediente: $nuovoIngrediente.values,
                                generalErrorCheck: generalErrorCheck)

                            // Allergeni
                            AllergeniScrollView_NewIngredientSubView(
                                nuovoIngrediente: self.$nuovoIngrediente.values,
                                generalErrorCheck: generalErrorCheck,
                                areAllergeniOk: $areAllergeniOk,
                                wannaAddAllergene: $wannaAddAllergeni)
                            
                            ConservazioneScrollView_NewIngredientSubView(
                                nuovoIngrediente: $nuovoIngrediente.values,
                            generalErrorCheck: generalErrorCheck)
                            
                            ProduzioneScrollView_NewIngredientSubView(
                                nuovoIngrediente: $nuovoIngrediente.values)
                            
                            ProvenienzaScrollView_NewIngredientSubView(
                                nuovoIngrediente: $nuovoIngrediente.values)
                            
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
                                    logMessage()
                                    return false
                                }
                            } primaryDialogAction: {
                                self.saveButtonDialogView()
                            }
                        }//.padding(.horizontal)
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $scrollPosition,anchor: .top)
                    .scrollDismissesKeyboard(.immediately)
      
                HStack {
                    Spacer()
                    Text(nuovoIngrediente.id)
                        
                    Image(systemName: nuovoIngrediente.id == ingredienteArchiviato.id ? "equal.circle" : "circle")
                }
                .font(.caption2)
                .foregroundStyle(Color.black)
                .opacity(0.6)
                   
            }
            .csHpadding()
            .popover(isPresented: $wannaAddAllergeni,attachmentAnchor: .point(.top),arrowEdge: .bottom) {
                VistaAllergeni_Selectable(
                    allergeneIn: $nuovoIngrediente.values.allergeni,
                    backgroundColor: backgroundColorView)
                .presentationDetents([.large])
            }
    
       }

    }
    // Method
    private func disableCondition() -> (general:Bool?,primary:Bool,secondary:Bool?) {
        
       let general = self.nuovoIngrediente == self.ingredienteArchiviato
       return (general,false,nil)
    }
    
    private func resetAction() {
        
        self.nuovoIngrediente = self.ingredienteArchiviato
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        
    }
    
    private func salvaECreaPostAction() {
        
        self.generalErrorCheck = false
        self.areAllergeniOk = false

        let new = IngredientModel()
        
        self.nuovoIngrediente = new
        self.ingredienteArchiviato = new
    }
    
    private func infoIngrediente() -> (breve:Text,estesa:Text) {
        
      let ingrediente = self.nuovoIngrediente
        
      let string = csInfoIngrediente(
        areAllergeniOk: self.areAllergeniOk,
        nuovoIngrediente: ingrediente.values)
       
        let incipit:String = {
            
            let origine = ingrediente.values.origine
            let isBio = ingrediente.values.produzione == .biologico
            let provenienza = ingrediente.values.provenienza
            
            var stringa = "Ingrediente"
            
            if origine != .noValue { stringa += " di Origine \(origine.simpleDescription())"}
            
            if isBio { stringa += " Bio" }
            if provenienza != .noValue {
                stringa += " \(provenienza.simpleDescription())"
            }

            return "\(stringa)."
        }()

      let description = Text("\(incipit)\n\(string)")
    
      return (description,description)
    }
    
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else {
            let field:ModelField = .intestazione
            withAnimation {
                self.modelField = field
                self.scrollPosition = field.rawValue
            }
            return false }
        
        guard checkOrigine() else { return false }
        
        guard self.areAllergeniOk else { return false }
        
        guard checkConservazione() else { return false }

       /* if self.nuovoIngrediente.optionalComplete() {
            self.nuovoIngrediente.status = .completo(.disponibile) }
        else {
            self.nuovoIngrediente.status = .bozza(.disponibile)
        } */
        self.viewModel.logMessage = "[ERRORE]_SVILUPPARE CAMBIO STATUS Ingrediente in CHECK_PRELIMINARE"
        return true
       
    }
    
    private func logMessage() {
        
        self.generalErrorCheck = true
        
        withAnimation {
               
                self.viewModel.logMessage = "[ERRORE]_Form Incompleto."
            }
    }
    
    private func checkOrigine() -> Bool {
        
        self.nuovoIngrediente.values.origine != .defaultValue
        
    }
    
    private func checkIntestazione() -> Bool {
    
         self.nuovoIngrediente.intestazione != ""
   
    }
    
    private func checkConservazione() -> Bool {
        
        self.nuovoIngrediente.values.conservazione != .defaultValue
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
                  //  Task {
                     /*  try await self.viewModel.createIngredient(item: self.nuovoIngrediente) { _ in }*/
                            
                        self.viewModel.createOrUpdateModelOnSub(itemModel: self.nuovoIngrediente)
                        self.salvaECreaPostAction()
                   // }
                }

            DialogButtonElement(
                label: .saveEsc) {
                    self.ingredienteArchiviato.intestazione == ""
                } action: {
                    
                   /* self.viewModel.createModel(
                        itemModel: self.nuovoIngrediente,
                        refreshPath: self.destinationPath)*/
                   // Task {
                      /* try await self.viewModel.createIngredient(
                            item: self.nuovoIngrediente,
                            refreshPath: self.destinationPath) { _ in }*/
                   // }
                    
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: self.nuovoIngrediente,
                        refreshPath: self.destinationPath)
                }
            
           // Modifica
            
            DialogButtonElement(
                label: .saveModNew) {
                    self.ingredienteArchiviato.intestazione != ""
                } action: {
                    
                   /* self.viewModel.updateModel(
                        itemModel: self.nuovoIngrediente)*/
                  /*  self.viewModel.updateIngredient(item: self.nuovoIngrediente)*/
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: self.nuovoIngrediente)
                    self.salvaECreaPostAction()
                }
            
            DialogButtonElement(
                label: .saveModEsc) {
                    self.ingredienteArchiviato.intestazione != ""
                } action: {
                    
                   /* self.viewModel.updateModel(
                        itemModel: self.nuovoIngrediente,
                        refreshPath: self.destinationPath)*/
                   /* self.viewModel.updateIngredient(
                        item: self.nuovoIngrediente,
                        refreshPath: self.destinationPath)*/
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: self.nuovoIngrediente,
                        refreshPath: self.destinationPath)
                }
            
            // nuovo da modifica
            
            DialogButtonElement(
                label: .saveAsNew,
                extraLabel: "Ingrediente") {
                    self.ingredienteArchiviato.intestazione != "" &&
                    self.nuovoIngrediente.intestazione != self.ingredienteArchiviato.intestazione
                } action: {
                    
                  //  Task {
                        var new = self.nuovoIngrediente
                        new.id = UUID().uuidString

                       /* self.viewModel.createModel(
                            itemModel: new,
                            refreshPath: self.destinationPath)*/
                      /* try await self.viewModel.createIngredient(item: new) { _ in }*/
                  //  }
                    
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: new,
                        refreshPath: self.destinationPath)
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
