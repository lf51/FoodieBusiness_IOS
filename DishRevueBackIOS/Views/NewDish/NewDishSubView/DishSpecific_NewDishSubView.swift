//
//  DishSpecific_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/07/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0
import MyFilterPackage

struct DishSpecific_NewDishSubView: View {
    
    @Binding var allDishFormats: [DishFormat]
    @Binding var openUploadFormat:Bool
    let generalErrorCheck: Bool

    var body: some View {
        
        VStack(alignment: .leading,spacing: .vStackLabelBodySpacing) {
            
            let placeHolder = priceStructureCount()
            
            CSLabel_conVB(
                placeHolder: placeHolder,
                imageNameOrEmojy: "dollarsign"/*"doc.text.magnifyingglass"*/,
                backgroundColor: Color.black) {
                    
                    HStack {
                        
                        CSButton_image(
                            frontImage: "plus.circle",
                            imageScale: .large,
                            frontColor:  .seaTurtle_3) {
                                withAnimation {
                                    addNewRow()
                                }
                            }
                        
                        Spacer()
                        
                        Button {
                            self.openUploadFormat.toggle()
                        } label: {
                            Text("Importa")
                                .fontWeight(.semibold)
                                .foregroundColor(.seaTurtle_3)
                        }
  
                    }
                    
                }
            
            createFormatRow()
            
        }

       
    }
    
    // Method Space
    
    private func priceStructureCount() -> String {
        
        let prices = self.allDishFormats.count
        let complete:Int = {
           
            if prices > 1 {
                return self.allDishFormats.filter({$0.label != "" && $0.price != ""}).count
            } else {
                return self.allDishFormats.filter({$0.price != ""}).count
            }
        }()
        
        return "Pricing \(complete)/\(prices)"
    }
    
    private func addNewRow() {
        
        let newFormat = DishFormat(
            type: .opzionale)
        self.allDishFormats.append(newFormat)
    }
    
    @ViewBuilder private func createFormatRow() -> some View {
        
        VStack {
            
            ForEach(self.$allDishFormats, id:\.self) { $formato in
                
                PriceRow(
                    formatoPiatto: $formato,
                    checkError: generalErrorCheck,
                    labelsCount: allDishFormats.count)  { formato in
                    self.reduceRow(formato: formato)
                }
                
                
            }
            
        }
        
    }
    
    private func reduceRow(formato:DishFormat) {
        
        if let index = self.allDishFormats.firstIndex(of: formato) {
            self.allDishFormats.remove(at: index)
        }
    }
}

struct DishFormatUploadLabel:View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var allDishFormat:[DishFormat]
    let backgroundColorView:Color
    
    @State private var formatChoice:[String]
    @State private var mandatoryLabel:String
    
    let archivioFormatChoice:[String]
    let archivioMandatoryLabel:String
    
    @State private var nothingChange:Bool = true
  //  @State private var disabilitaCreaModello:Bool = true
    
    init(allDishFormat: Binding<[DishFormat]>,
         backgroundColorView: Color) {
    
        _allDishFormat = allDishFormat
        let allDishFormatWrapped = allDishFormat.wrappedValue
        self.backgroundColorView = backgroundColorView
        
        let allLabel = allDishFormatWrapped.compactMap({$0.label}).filter({$0 != ""})
        _formatChoice = State(wrappedValue: allLabel)
        archivioFormatChoice = allLabel
        
       let theMandatoryOne = allDishFormatWrapped.first(where: {$0.type == .mandatory})?.label ?? ""
        _mandatoryLabel = State(wrappedValue: theMandatoryOne)
        self.archivioMandatoryLabel = theMandatoryOne
    }
    
    var body: some View {
        
        CSZStackVB(
            title: "Importa Etichette",
            titlePosition: .bodyEmbed([.horizontal,.top]),
            backgroundColorView: backgroundColorView) {
            
                VStack(alignment:.leading) {
                    
                   /* HStack(spacing:10) {
                        
                        Text("Singola")
                        
                        Text("Gruppo")
                    } */

                        ScrollView(showsIndicators: false) {
                            
                            let allLabels = Array(self.viewModel.allDishFormatLabel).sorted(by: <)
                            
                            ForEach(allLabels,id:\.self) { label in
                                
                                if label != "" {
                                
                                        LabelUpRow(formatChoice: $formatChoice, label: label,mandatoryLabel: $mandatoryLabel)

                                }
                            }
   
                        }// chiusa scroll
                        
                    HStack {
                        
                        Spacer()
                        
                        CSButton_tight(
                            title: "Importa",
                            fontWeight: .semibold,
                            titleColor: .white,
                            fillColor: .seaTurtle_1) {
                                self.aggiungiAction()
                                self.dismiss.callAsFunction()
                            }
                            .opacity(nothingChange ? 0.6 : 1.0)
                            .disabled(nothingChange)
                        
                        
                        
                        CSButton_tight(
                            title: "Crea Modello",
                            fontWeight: .semibold,
                            titleColor: .white,
                            fillColor: .seaTurtle_1) {
                                creaModelloAction()
                            }
                            .opacity(disabilitaCreaModello ? 0.6 : 1.0)
                            .disabled(disabilitaCreaModello)
                        
                    }
                }

            }// chius zstack
            .onChange(of: self.mandatoryLabel) { newValue in
                
                let conditionOne = self.formatChoice == self.archivioFormatChoice
                let conditionTwo = newValue == self.archivioMandatoryLabel
                
                self.nothingChange = conditionOne && conditionTwo
               
            }
            .onChange(of: self.formatChoice) { newValue in
                
                let conditionOne = newValue == self.archivioFormatChoice
                let conditionTwo = self.mandatoryLabel == self.archivioMandatoryLabel
                
                self.nothingChange = conditionOne && conditionTwo
            }
           
        
    } // chiusa Body
    
    var disabilitaCreaModello:Bool {
        
        self.nothingChange || self.mandatoryLabel == "" || self.formatChoice.count < 2
        
    }
    
  /*  var disabilitaCreaModello:Bool {
        
        var conditionOne:Bool
        var conditionTwo:Bool
        
        if let modelloCorrente = DishFormat.modelloCorrente {
            
            let labelsModello = modelloCorrente.map({$0.label})
            let labelMandatoryModello = modelloCorrente.first(where: {$0.type == .mandatory})?.label ?? ""
            
            conditionOne = (self.mandatoryLabel == labelMandatoryModello) || (self.mandatoryLabel == "")
            conditionTwo = (self.formatChoice == labelsModello) || (self.formatChoice.count < 2)
            return conditionOne && conditionTwo
            
        } else {
            
            conditionOne = self.mandatoryLabel == ""
            conditionTwo = self.formatChoice.count < 2
            return conditionOne || conditionTwo
            
        }
        
    } */
    
    private func creaModelloAction() {
        
        var modello:[DishFormat] = []
        
        for label in self.formatChoice {
            
            let value:DishFormatType = self.mandatoryLabel == label ? .mandatory : .opzionale
            
            let new = DishFormat(label: label, type: value)
            modello.append(new)
        }
        
        DishFormat.modelloCorrente = modello
        self.aggiungiAction()
        self.dismiss.callAsFunction()
        
    }
    
    
    private func aggiungiAction() {
        
        var allLabelsString = self.formatChoice
        if self.mandatoryLabel == "" { allLabelsString.append("")}
    
        let formats:[DishFormat] = allLabelsString.map({
            
            let type:DishFormatType = $0 == self.mandatoryLabel ? .mandatory : .opzionale
            return DishFormat(label: $0, type: type)
        })
        
        self.allDishFormat = formats.sorted(by: {
            ($0.type.orderAndStorageValue(),$0.label ) < ($1.type.orderAndStorageValue(),$1.label)
                                             
        })
        
    }

}

struct LabelUpRow:View {
    
    @Binding var formatChoice:[String]
    @Binding var mandatoryLabel:String
    let label:String
    
    private var isSelected:Bool = false

    init(formatChoice:Binding<[String]>,label:String,mandatoryLabel:Binding<String> ) {
        
        _formatChoice = formatChoice
        self.label = label
        _mandatoryLabel = mandatoryLabel
        
        self.isSelected = formatChoice.wrappedValue.contains(label)
 
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                HStack(spacing:10) {
                    
                    CSButton_image(
                     activationBool: isSelected,
                     frontImage: "checkmark.circle.fill",
                     backImage: "circle",
                     imageScale: .large,
                     backColor: .seaTurtle_2,
                     frontColor: .gray) {
                         addLabel(
                             label: label,
                             alreadyIn: isSelected)
                     }
               
                    Divider()
                    
                    Text(label)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.8))
                }
                
                    Spacer()
                
              //  HStack(spacing:20) {
                    
                    CSButton_image(
                     activationBool: mandatoryLabel == label,
                     frontImage: "bookmark.fill",
                     backImage: "bookmark",
                     imageScale: .large,
                     backColor: .seaTurtle_4,
                     frontColor: .gray) {
                      addMandatoryOption(label: label)
                     }
                     .opacity(isSelected ? 1.0 : 0.5)
                     .disabled(!isSelected)
                    
                //    Divider()
                     
                    
             //   }
 
            }
            Divider()
        }
       // .padding(.vertical,5)
        
        
        
        
    }
    
    private func addMandatoryOption(label:String) {
        
        if self.mandatoryLabel == label { self.mandatoryLabel = "" }
        else { self.mandatoryLabel = label }
    }
    
    private func addLabel(label:String,alreadyIn:Bool) {

        if alreadyIn {
            self.formatChoice.removeAll(where: {$0 == label})
            if self.mandatoryLabel == label { self.mandatoryLabel = "" }
        } else {
            self.formatChoice.append(label)
        }
    }
    
    
}

struct PriceRow:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var formatoPiatto: DishFormat
    let checkError: Bool
    let labelsCount:Int
    let delAction:(_ formato:DishFormat) -> Void
    
    @State private var label:String
    @State private var price:String

    @FocusState private var fieldInFocuse:PriceField?
    
    init(
        formatoPiatto: Binding<DishFormat>,
        checkError:Bool,
        labelsCount: Int,
        delAction: @escaping (_: DishFormat) -> Void ) {
        
        _formatoPiatto = formatoPiatto
        self.checkError = checkError
        _label = State(wrappedValue: formatoPiatto.wrappedValue.label)
        _price = State(wrappedValue: formatoPiatto.wrappedValue.price)
        self.labelsCount = labelsCount
        self.delAction = delAction
        
    }
    
    enum PriceField:Hashable { case label,price }
        
    var body: some View {
     
        HStack {
            
            CSTextField_4b(
                textFieldItem: $label,
                placeHolder: "label - Ex: 1/2 Pinta",
                keyboardType: .default) {
                    csVisualCheck(
                        testo: self.label,
                        staticImage: "rectangle.dashed.and.paperclip",
                        editingImage: "rectangle.dashed.and.paperclip",
                        conformeA: .stringa(minLenght: 3))
                        .padding(.leading,5)
                }
                .focused($fieldInFocuse, equals: .label)
                .onSubmit {
                    self.fieldInFocuse = .price
                }
                .overlay {
                    if labelsCount == 1 {
                        ZStack {
                            Color.seaTurtle_1
                                .cornerRadius(5.0)
                              //  .opacity(0.6)
                            Text("Label Non Richiesta")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                        }
                    }
                }
                .csWarningModifier(isPresented: checkError) {
                    if labelsCount > 1 {
                        return !csCheckStringa(testo: self.label, minLenght: 3) } else {
                            return false}
                }
  
            CSTextField_4b(
                textFieldItem: $price,
                placeHolder: "100.00",
                keyboardType: .decimalPad) {
                    csVisualCheck(
                        testo: self.price,
                        staticImage: "eurosign.circle",
                        editingImage: "eurosign.circle",
                        conformeA: .decimale)
                    .padding(.leading,5)
                }
                .focused($fieldInFocuse, equals: .price)
                .disabled(labelsCount != 1 && self.label.count < 3)
               /* .onSubmit {
                    let newPrice = self.price.replacingOccurrences(of: ",", with: ".")
                    self.formatoPiatto.price = newPrice
                } */
                .fixedSize() // fixedSize significa che la view avrà una grandezza variabile che può eccedere quella in cui è contenuta. Viene impostato alla sua grandezza ideale. Per questo muterà se inseriamo, in questo caso, tante cifre. Dato che ipotizziamo che in un ristorante difficilmente supereremo le 5 cifre, lo impostiamo su questa linea. Dovesse comunque succedere non fa nulla :-)
                
                .csWarningModifier(isPresented: checkError) {
                   // !csCheckDouble(testo: self.price)
                    !csCheckDouble(testo: self.formatoPiatto.price)
                }
               /* .onTapGesture {
                    if self.price.count > 0 { csHideKeyboard() }
                }*/
   
            if formatoPiatto.type == .opzionale {
                
                CSButton_image(frontImage: "trash", imageScale: .medium, frontColor: Color.white) {
                    withAnimation {
                        self.delAction(formatoPiatto)
                        }
                    }
                    ._tightPadding()
                    .background(
                        Circle()
                            .fill(Color.red.opacity(0.5))
                            .shadow(radius: 5.0)
                    )
           
            } else {
                
                CSButton_image(frontImage: "trash", imageScale: .medium, frontColor: Color.white) {
                 //   self.delAction(formatoPiatto)
                    // Abbiamo rimesso il buttonTrash per nasconderlo, di modo da riservare lo stesso spazio e non avere disallineamenti. Il visualizzato sarà l'overlay
                    }
                    ._tightPadding()
                    .background(
                        Circle()
                            .fill(Color.red.opacity(0.5))
                            .shadow(radius: 5.0)
                    )
                    .hidden()
                    .overlay {
                        Image(systemName: "bookmark.fill")
                            .imageScale(.large)
                            .foregroundColor(.seaTurtle_4)
                            .onTapGesture {
                                self.viewModel.alertItem = AlertModel(
                                    title: "Prezzo in evidenza",
                                    message: "Questo sarà il primo prezzo mostrato al cliente.")
                            }
                    }
            }
        }
        .toolbar {
            
            if self.fieldInFocuse == .label &&
                !self.price.isEmpty {
                
                ToolbarItem(placement: .keyboard) {
                    
                    vbKeyboardToolBar {
                        self.formatoPiatto.label = self.label
                    }
                    
                   /* HStack {
                        
                        Text("\(self.label):")
                        Text(self.price)
                        
                        Spacer()
                        
                        Button {
                            self.formatoPiatto.label = self.label
                            
                        } label: {
                            Text("Salva")
                                .bold()
                                .foregroundColor(.green)
                            }
                        } */
                }
                
            }
            
            
            if self.fieldInFocuse == .price {
                
                ToolbarItem(placement: .keyboard) {
                    
                    vbKeyboardToolBar {
                        let newPrice = self.price.replacingOccurrences(of: ",", with: ".")
                        self.formatoPiatto.label = self.label
                        self.formatoPiatto.price = newPrice
                        
                    }
                    
                   /* HStack {
                        
                        Text("\(self.label):")
                        Text(self.price)
                        
                        Spacer()
                        
                        Button {
                            self.formatoPiatto.label = self.label
                            let newPrice = self.price.replacingOccurrences(of: ",", with: ".")
                            self.formatoPiatto.price = newPrice
                            
                        } label: {
                            Text("Salva")
                                .bold()
                                .foregroundColor(.green)
                            }

                        
                        } */
                    }
                
                }
            }
    }
    
    // method
    
    @ViewBuilder private func vbKeyboardToolBar(action:@escaping () -> Void ) -> some View {

            HStack {
                
                Text("\(self.label):")
                Text(self.price) // quando trasformato in double aggiungere la currency
                
                Spacer()
                
                Button {
                   action()
                    
                } label: {
                    Text("Salva")
                        .bold()
                        .foregroundColor(.green)
                    }
                }
    }
}
