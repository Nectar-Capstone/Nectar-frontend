//
//  Main.swift
//  Capstone
//
//  Created by Anuntaya Kitiporn on 30/3/2566 BE.
//

import SwiftUI



struct Organization: Codable, Hashable{
    let id: Int
    let type: String?
    let name: String
    let address: String?
    let telecom: String?
    let partOf: Int?
    let otherOrganization: [Organization]
    let practitioner: [Practitioner]
}

struct Patient:Codable, Hashable {
    let id : String?
    let uid: String
    let cid: String?
    let name: String
    let gender: String?
    let telecom: String?
    let contact_name: String?
    let contact_relationship: String?
    let contact_gender: String?
    let contact_telecom: String?
    //    let birthdate: Date?
    let isHaving : [IsHaving]?
    let isAllergic: [IsAllergic]?
    let isTaking: [IsTaking]?
}

struct Practitioner:Codable, Hashable {
    let id : String
    let did: String
    let name: String?
    let gender: String?
    let telecom: String?
    let oid: Int
    let since: Date?
    let until: Date?
    let code: String?
    let organization: Organization
    let credential: [Credential]
    let isAccess: [IsAccess]
}

struct Credential: Codable, Hashable {
    let id : String
    let username: String
    let password: String?
    let did: String?
    let updatedAt: Date
    let createdAt: Date?
    let practitioner: Practitioner?
}

struct IsAccess: Codable, Hashable {
    let id : String
    let uid: String
    let did: String
    let latitude: String?
    let longitude: String?
    let accessTime: Date?
}

struct IsTaking: Codable, Hashable {
    let id : String
    let uid: String
    let code: String
    let authoredOn: Date?
    let dosageInstruction: String?
    let note: String?
    
    struct Medication: Codable, Hashable {
        
        
        let id : String
        let code: String
        let display: String
        let isTaking: [IsTaking]
    }
}
struct IsHaving: Codable, Hashable {
    let id : String
    let uid: String
    let code: String
    let clinicalStatus: String?
    let verificationStatus: String?
    let category: String?
    let severity: String?
    let recordDate: Date?
    let conditionProblemDiagnosis: ConditionProblemDiagnosis
    
    struct ConditionProblemDiagnosis: Codable ,Hashable{
        let id : String
        let code: String
        let display: String
    }
}
struct IsAllergic: Codable, Hashable{
    let id : String
    let uid: String
    let code: String
    let clinicalStatus: String?
    let verificationStatus: String?
    let type: String?
    let category: String?
    let criticality: String?
    let recordDate: Date?
    let allergicIntoleranceSubstance: AllergicIntoleranceSubstance
    
    struct AllergicIntoleranceSubstance: Codable, Hashable {
        let id : String
        let code: String
        let display: String
        let isTaking: [IsTaking]
    }
}

class ViewModel: ObservableObject{
     @Published var Patient_only: Patient = Patient(id: "", uid: "", cid: "", name: "", gender: "", telecom: "", contact_name: "", contact_relationship: "", contact_gender: "", contact_telecom: "", isHaving: [], isAllergic: [], isTaking: [])
    
    func fetch(){
        guard let url = URL(string: "http://localhost:3000/users/patient?uid=d0ce62c70b8b95d14fd335165663d1718b95d3df83710e4a48990a602720d053") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(" Bearer "+jwttoken, forHTTPHeaderField: "Authorization")
        print("request with " + jwttoken )
        
        let task = URLSession.shared.dataTask(with: request) { [weak self]
            data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let patients = try JSONDecoder().decode(Patient.self, from: data)
                DispatchQueue.main.async {
                    self?.Patient_only = patients
                  
                }
                print(patients)
            }
            catch{
                print(error)
                
            }
        }
        task.resume()
    }
}
struct NectarMain: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 255 / 255, green: 227 / 255, blue: 227 / 255, opacity: 1).edgesIgnoringSafeArea(.all)
                VStack {
                    
                    
                }    .padding(.horizontal)
                    .frame(width:353,height:667)
                    .background(Color(.white))
                    .cornerRadius(16).offset(y:25.0)
                
                VStack {
                    HStack {
                        VStack(spacing :30){
                            BackgroundColor(backgroundColor:Color( red: 148 / 255, green: 215 / 255, blue: 255 / 255, opacity: 1))
                            BackgroundColor(backgroundColor:Color( red: 251 / 255, green: 119 / 255, blue: 151 / 255, opacity: 1))
                            BackgroundColor(backgroundColor:Color( red: 240 / 255, green: 215 / 255, blue: 125 / 255, opacity: 1))
                            BackgroundColor(backgroundColor:Color( red: 148 / 255, green: 215 / 255, blue: 255 / 255, opacity: 1))
                            BackgroundColor(backgroundColor:Color( red: 128 / 255, green: 197 / 255, blue: 116 / 255, opacity: 1))
                            Spacer()
                        }.padding(.top,70)
                    }
                    .padding(.horizontal)
                    .frame(width:353,height:667)
                    .cornerRadius(16)
                }.offset(x:5.0,y:25.0)
                VStack {
                    HStack {
                        VStack(spacing :30){
                            DetailsCard(title: "Patient Name", details: viewModel.Patient_only.name, action: "more info", destination: PatientDetails())
                            DetailsCard(title: "Relative (Emergency Contact)", details: viewModel.Patient_only.telecom ?? "", action: "more info", destination: Relative())
                            DetailsCard(title: "Current Medications", details: "Metformin, Antihistamines, ....", action: "more info",destination: CurrentMedication())
                            DetailsCard(title: "Allergy", details: "Pollen", action: "more info",destination: Allergies())
                            DetailsCard(title: "Underlying Disease", details: "Resolved asthma", action: "more info",destination: UnderlyingDisease())
                            Spacer()
                    
                        }.padding(.top,70)
                        
                        
                    }
                    .padding(.horizontal)
                    .frame(width:353,height:667)
                    .cornerRadius(16)
                }.offset(y:25.0)
                Image("bloodIcon").offset(x: 0, y: -320.0)
            }
        }  .navigationBarBackButtonHidden(true)
        
            .onAppear{
                viewModel.fetch()
            }
        
    }
}

struct NectarMain_Previews: PreviewProvider {
    static var previews: some View {
        NectarMain()
    }
}

struct DetailsCard<Content : View>: View {
    var title : String
    var details : String
    var action : String
    var destination : Content
    var body: some View {
        NavigationLink(destination: destination, label:{
            HStack{
                HStack{
                    VStack{
                        Text(title)
                            .font(.system(size: 14, weight:.semibold))
                            .padding(.bottom,2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(details)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    } .padding(.horizontal,5) .foregroundColor(.black)
                    Spacer()
                    Button{
                        print(action)
                    }
                label:{Text("+")
                        .frame(width: 25, height: 25)
                        .font(.system(size: 22, weight:.bold))
                        .foregroundColor(Color(red: 140 / 255, green: 16 / 255, blue: 16 / 255, opacity: 1))
                        .background(Color(red: 227 / 255, green: 156 / 255, blue: 155 / 255, opacity: 1))
                        .clipShape(Circle())
                }
                }
            }   .padding(.horizontal)
                .frame(width:287,height:75)
                .background(Color(red: 236 / 255, green: 241 / 255, blue: 244 / 255, opacity: 1))
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.3), radius: 15, x: 0, y: 12)
            
            
            
        })
    }
}
struct BackgroundColor: View {
    var backgroundColor: Color
    var body: some View {
        HStack{
            HStack{
                VStack{
                    
                } .padding(.horizontal,5)
                Spacer()
                
            }
            
        }
        .padding(.horizontal)
        .frame(width:287,height:75)
        .background(backgroundColor)
        .cornerRadius(16)
        
    }
}