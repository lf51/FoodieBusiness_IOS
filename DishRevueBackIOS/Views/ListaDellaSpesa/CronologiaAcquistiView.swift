//
//  CronologiaAcquistiView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 30/12/23.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import Combine
import Firebase

struct CronologiaAcquistiView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @StateObject private var localViewModel:CloudStaticGenericViewModel = CloudStaticGenericViewModel<BollaAcquisto>()
    let ingrediente:IngredientModel
    let backgroundColorView: Color
    
    var body: some View {
        
        CSZStackVB(title: ingrediente.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                let logDate = buildArray()
                let logDateEnumerated = logDate.enumerated()
                
                HStack {
                    
                    Text("Validazione Acquisti")
                        .italic()
                        .fontWeight(.light)
                        .font(.title2)
                        .foregroundStyle(Color.seaTurtle_4)
                  
                    Spacer()
                }

                ScrollView(showsIndicators:false) {
                    
                    ForEach(Array(logDateEnumerated),id:\.element) { position,stamp in
                        
                        let timeStamp = timeStamp(from: stamp.data)
                        
                       /* let(time,note) = self.viewModel.currentProperty.inventario.splitDateFromNote(stringa: stamp)*/
                        
                        VStack(alignment:.leading,spacing:5) {
                            
                            HStack(alignment:.lastTextBaseline) {
                                
                                Text("\(position + 1).")
                                    .font(.system(.subheadline, design: .monospaced, weight: .bold))
                                    .foregroundStyle(Color.gray)
                                   // .foregroundStyle(Color.seaTurtle_4)
                                
                                Text(timeStamp.giorno)
                                   // .italic()
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color.black.opacity(0.7))
                                
                                Text("(h:\(timeStamp.ora))")
                                   // .italic()
                                    .font(.system(.body, design: .rounded, weight: .light))
                                    .foregroundStyle(Color.black.opacity(0.7))
                                
                              /*  if position == 0 {
                                    
                                    Text("ultimo acquisto")
                                        .italic()
                                        .font(.callout)
                                        .foregroundStyle(Color.seaTurtle_3)
                                    
                                }*/
                                Spacer()
                                
                                Text(stamp.user ?? "no user")
                                    .italic()
                                    .font(.system(.subheadline, design: .default, weight: .light))
                                    .foregroundStyle(Color.seaTurtle_3.opacity(0.8))
                              
                            }
                            
                            Text(stamp.nota ?? "nessuna nota")
                                .italic()
                                .font(.system(.subheadline, design: .default, weight: .light))
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.black.opacity(0.8))
                            
                            Divider()
                        }
                       
                        
                    }
                    
                    
                }
                
              //  Spacer()

            }
            .csHpadding()
           // .padding(.horizontal)
        }
        .onAppear {
            print("[ON_APPEAR]_CronologiaAcquistiView_publisher:\(self.localViewModel.cancellables.count)")
            
            Task {
                
                let customDecoder:Firestore.Decoder = {
                    
                    let decoder = Firestore.Decoder()
                    decoder.userInfo[BollaAcquisto.codingInfo] = MyCodingCase.subCollection
                    return decoder
                }()
                let field = BollaAcquisto.CodingKeys.rif.rawValue
               
                do {
                    
                    try self.viewModel.subCollectionManager
                        .fetchStaticFromSubCollection(
                            sub: .archivioBolleAcquisto,
                            field: field,
                            value: self.ingrediente.id,
                            publisher: self.localViewModel.publisher,
                            decoder: customDecoder)
                    
                } catch let error {
                    
                    self.viewModel.logMessage = error.localizedDescription
                }
               
                
                
            }
           
        }
    }
    // Method
    
    private func timeStamp(from data:Date?) -> (giorno:String,ora:String) {
        
        guard let data else { return ("[ddmmyy]Record Error","-") }
        
        let day = csTimeFormatter().data.string(from: data)
        let hour = csTimeFormatter().ora.string(from: data)
        return (day,hour)
        
    }
    
    private func buildArray() -> [BollaAcquisto] {
        
        guard let array = self.localViewModel.cloudContainer else {
            return []
        }
        
        return array.sorted(by: {$0.data ?? Date() > $1.data ?? Date()})
 
    }

}

/*#Preview {
   // CronologiaAcquistiView()
}*/
