//
//  VistaRecensioniEspansa_SingleDish.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/02/23.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

enum TimeSchedule:Hashable {
    
    static var allCases:[TimeSchedule] = [.all,.last,.new]
    
    case all
    case last
    case new
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .all: return "all"
        case .last: return "last"
        case .new: return "new"
        }
    }
}

struct VistaRecensioniEspansa_SingleDish: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    let backgroundColorView:Color
    
    let rifDish:String
    let navigationPath:DestinationPath
  //  @State private var rowSize:RowSize = .sintetico
    
    @State private var sign:ComparableSign = .major
    @State private var secondCompare:Int = 0
    @State private var firstCompare:Int = 0
    
    @State private var timeSchedule:TimeSchedule = .all
    @State private var lastCount:Int = 10

    enum ComparableSign:String,Hashable {
        
        static var allCases:[ComparableSign] = [.equal,.major,.minor,.middle]
        
        case major = ">"
        case minor = "<"
        case equal = "=="
        case middle = "fra"
        
        func shortSign() -> String {
            
            switch self {
                
            case .middle: return "e"
            case .minor: return "di"
            case .major: return "di"
            case .equal: return "a"
                
            }
        }
        
        func minimumAndMax(firstCompare:Int,secondCompare:Int) -> (min:Double,max:Double) {
            
            let min = Double(firstCompare)
            let max = Double(secondCompare)
            
            switch self {
                
            case .middle: return (min,max)
            case .minor: return (0.0,max)
            case .major: return (max,10.0)
            case .equal: return (max,max)
                
            }
            
        }
        
        func secondCompareRange(firstCompare:Int) -> ClosedRange<Int> {
            
            switch self {
                
            case .middle: return (firstCompare + 1)...10
            case .minor: return 1...10
            case .major: return 0...9
            case .equal: return 0...10
                
            }
            
        }
        
    }
    
    var body: some View {
        
        CSZStackVB(title: "Esplora Recensioni", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {
                
                if let currentDish = self.viewModel.modelFromId(id: rifDish, modelPath: \.db.allMyDish) {
                    
                  //  let rifReviews = currentDish.rifReviews
                   //let allDishrev = self.viewModel.reviewValue(rifReviews: rifReviews)
                    let rifReviews = self.viewModel.reviewFilteredByDish(idPiatto: currentDish.id).rif
                    let allDishrev = self.viewModel.filtroRecensioni(rifReviews: rifReviews, filter: self.timeSchedule,lastCount: self.lastCount)
        
                    ReviewStatMonitor(
                        singleDishRif: rifReviews) {
                      
                            Menu {
                                
                                Button(role:.destructive) {

                                    self.viewModel[keyPath: navigationPath.vmPathAssociato()].append(DestinationPathView.piatto(currentDish,.ridotto))
                                    
                                } label: {
                                    
                                    Text("Edit")
                                    
                                }
                            } label: {
                                ProductModel_RowView(item: currentDish, rowSize: .sintetico)
                                    .csOverlayModelChange(rifModel: rifDish)
                            }

                          
                        } extraContent:{
                           
                            vbBarraExtra()
                            
                        } mL10CalcoloDinamico: {
                            // calcola la media degli elementi filtrati nel caso si voglia la media last10/5/15
                            if self.timeSchedule == .last {
                                return  (csCalcoloMediaRecensioni(elementi: allDishrev),allDishrev.count)
                            } else { return nil }
                            
                        }
                        .fixedSize()
                    
                        ScrollView(showsIndicators: false) {
                            
                            VStack(spacing:.vStackBoxSpacing) {
                                
                                let (min,max) = self.sign.minimumAndMax(firstCompare: firstCompare, secondCompare: secondCompare)
                                
                                ForEach(allDishrev,id:\.self) { review in

                                    if review.isVoteInRange(min: min, max: max) {
                                    
                                        DishRating_RowView(
                                            rating: review,
                                            backgroundColorView: .seaTurtle_1)
                                        
                                   }
                                }
                            }

                        }
                    
                    CSDivider()
                } else {
                    
                    Text("Errore - Piatto non Trovato")
                }
            
                
                
               
             /*   CSDivider()
                
                ScrollViewReader { proxy in
                
                    ScrollView(showsIndicators:false) {
     
                        VStack(alignment:.leading) {
                            
                            Menu {
                                let conditionOne = self.rowSize == .sintetico
                                let conditionTwo = self.rowSize == .normale
                                
                                Button {
                                    self.rowSize = .sintetico
                                } label: {
                                    HStack{
                                        Text("Sintetico")
                                        if conditionOne {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }.disabled(conditionOne)
                                
                                Button {
                                    self.rowSize = .normale
                                } label: {
                                    HStack{
                                        Text("Esteso")
                                        if conditionTwo {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }.disabled(conditionTwo)
                                
                                Button(role:.destructive) {
                                    
                                    self.viewModel.addToThePath(
                                        destinationPath: navigationPath,
                                        destinationView: currentDish.pathDestination())
                                } label: {
                                    HStack{
                                        Text("Modifica")
                                        Image(systemName: "gear")
                                    }
                                }
                                

                            } label: {
                                ProductModel_RowView(item: currentDish, rowSize: rowSize)
                            }
                            
                            ReviewStatMonitor(
                                singleDishRif: rifReviews) {
                              
                                    Text("Statistica Recensioni")
                                          .font(.system(.headline, design: .monospaced, weight: .black))
                                          .foregroundStyle(Color.seaTurtle_2)
                                  
                            } extraContent:{ EmptyView() }
                        }// vstack
                        .id(0)

                    let allDishrev = self.viewModel.reviewValue(rifReviews: rifReviews)

                            VStack(spacing:.vStackBoxSpacing) {
                                    
                                    ForEach(allDishrev) { review in

                                        DishRating_RowView(
                                            rating: review,
                                            backgroundColorView: .seaTurtle_1)
                                       
                                    }

                                }.id(1)
                    }
                  
                    .onAppear{ proxy.scrollTo(0,anchor: .bottom) }
                    
                }
                
             //   Spacer()
                CSDivider() */
            }
            .csHpadding()
           /* .onChange(of: self.lastCount) { newValue in
                self.timeSchedule = .last(newValue)
            }*/

        }
        
        
    }
    
    // Method
    
    @ViewBuilder private func vbBarraExtra() -> some View {
        
        let conditionOne = self.sign != .middle
        let conditionTwo = self.timeSchedule != .last

        let startCondition:Bool = {
            self.timeSchedule == .all &&
            self.sign == .major &&
            self.secondCompare == 0
        }()
        
        ScrollViewReader { proxy in
            
            ScrollView(.horizontal, showsIndicators: false) {
                    
                HStack(spacing:5) {
                    
                    Button {
                        withAnimation {
                            self.resetAction()
                        }
                    } label: {
                        Image(systemName: "x.circle")
                            .imageScale(.large)
                            .foregroundStyle(startCondition ? Color.seaTurtle_1 : Color.seaTurtle_3)
                    }
                    .id(0)
                    .disabled(startCondition)
                    
                    HStack(spacing:-15) {
                        
                        Picker(selection: $timeSchedule) {
                            
                            ForEach(TimeSchedule.allCases,id:\.self) { schedule in
                                
                                Text(schedule.simpleDescription())
                                    .tag(schedule)
                                
                            }
                        
                        } label: {
                            Text("")
                        }
                        
                        .accentColor(.seaTurtle_4)
                        .pickerStyle(MenuPickerStyle())
                        
                        let lastRange = conditionTwo ? [5] : [5,10,15]
                        
                        Picker(selection: $lastCount) {
                            
                            ForEach(lastRange,id:\.self) { count in
                                
                                Text("\(count)")
                                    .tag(count)
                                
                            }
                            
                        } label: {
                            Text("")
                        }
                        .accentColor(.seaTurtle_3)
                        .pickerStyle(MenuPickerStyle())
                        .disabled(conditionTwo)
                        
                       /* if self.timeSchedule == .last {
                            let media = calcoloMedia()
                            Text("\(media,specifier: "%.1f")")
                                .fontWeight(.black)
                                .foregroundStyle(Color.seaTurtle_2)
                                .padding(.leading,15)
                                .padding(.trailing,5)
                        }*/
                      
                        
                    }
                    .id(1)
                    .background {
                        Color.seaTurtle_1
                            .cornerRadius(5.0)
                            .opacity(0.6)
                    }
                    
                    HStack(spacing:-15) {
                        
                        Picker(
                            selection: $sign) {
                                
                                ForEach(ComparableSign.allCases,id:\.self) { sign in
                                    
                                    Text(sign.rawValue)
                                        .bold()
                                        .tag(sign)
                                    
                                }
                            } label: {
                                Text("")
                            }
                        
                            .accentColor(.seaTurtle_4)
                            .pickerStyle(MenuPickerStyle())
                        
                        Picker(selection: $firstCompare) {
                            
                            ForEach(0...9,id:\.self) { number in
                                let double = Double(number)
                                Text("\(double,specifier: "%.1f")")
                                    .tag(number)
                                
                            }
                            
                        } label: {
                            Text("")
                        }
                        .accentColor(.seaTurtle_3)
                        .pickerStyle(MenuPickerStyle())
                        .disabled(conditionOne)
                        
                        
                        Text("\(sign.shortSign())")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal,15)
                        
                        let range = self.sign.secondCompareRange(firstCompare: firstCompare)
                        
                        Picker(selection: $secondCompare) {
                            
                            ForEach(range,id:\.self) { number in
                                let double = Double(number)
                                Text("\(double,specifier: "%.1f")")
                                    .tag(number)
                            }
                            
                        } label: {
                            Text("")
                        }
                        .accentColor(.seaTurtle_3)
                        .pickerStyle(MenuPickerStyle())
                        
                    }
                    .id(2)
                    .background {
                        Color.seaTurtle_1
                            .cornerRadius(5.0)
                            .opacity(0.6)
                    }
                    
                }
 
            }
            .onAppear { proxy.scrollTo(1,anchor: .leading) }
            
        }
    }
    
    private func resetAction() {
        
        self.timeSchedule = .all
        self.sign = .major
        self.secondCompare = 0
            
    }
}
/*
struct VistaRecensioniEspansa_SingleDish_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationStack {
            VistaRecensioniEspansa_SingleDish(
                backgroundColorView: .seaTurtle_1,
                rifDish: dishItem4_Test.id,
                navigationPath: .homeView)
        }
        .environmentObject(testAccount)
    }
}*/
