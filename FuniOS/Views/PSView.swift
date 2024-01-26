//
//  PSView.swift
//  Fun
//
//  Created by 임준협 on 12/29/23.
//

import SwiftUI

struct PSView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Used to hide default back button
    @FocusState private var isEditing // Used to focus on TextField
    @State var isFirstAppear = true // Used to prevent reroll problem without solving/ skipping
    @State var problems = [Problem]() // Used to store problems
    @State private var shownP = [Int]() // Used to store shown problems' index
    @State private var p = "" // Used to store problem string
    @State private var ua = "" // Used to store user's answer
    @State private var a = [String]() // Used to store answer array
    @State private var sa = "" // Used to store answer string for UI
    @State var showP = false // Shows problem if true
    @State var showL = true // Shows loading if true
    @State var showA = false // Shows answer if true
    @State var disableBtns = false // Disables buttons if true
    @State var showC = false // Shows correct/ incorrect if true
    @State var correct = false // Shows correct if true
    @State private var score: String? = nil
    @State var showAccountScore = false
    var body: some View {
        ZStack {
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                
                HStack{
                    Spacer()
                }
                Spacer()
                if showL {
                    HStack {
                        Text("로딩 중")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.trailing, 13)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                    }
                }
                if showP {
                    
                    Text(p)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, -3)
                    if showA {
                        Text(sa)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    if showAccountScore {
                        Text("계정점수: \(score ?? "로딩 중")점")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    if showC {
                        if correct {
                            Capsule()
                                .frame(width: 130, height: 30)
                                .foregroundColor(.green)
                                .overlay(
                                    Label{
                                        Text("정답입니다!")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    } icon: {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                    }
                                )
                                .padding(.top, -5)
                        } else {
                            Capsule()
                                .frame(width: 130, height: 30)
                                .foregroundColor(.red)
                                .overlay(
                                    Label{
                                        Text("오답입니다!")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    } icon: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                    }
                                )
                                .padding(.top, -5)
                        }
                        
                    }
                    TextField(text: $ua, label: {
                        Text("정답을 입력하세요")
                    })
                    .animation(.easeOut, value: isEditing)
                    .padding([.horizontal, .bottom])
                    .textFieldStyle(fancyTextField(isEditing: isEditing))
                    .focused($isEditing)
                    .submitLabel(.done)
                    .onSubmit {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        setA()
                        checkAn()
                        //                    bStr()
                        withAnimation(.easeInOut(duration: 0.5)) {
                            //                        showAn()
                            showC = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            randomQuiz()
                            showA = false
                            showC = false
                        }
                    }
                    .disabled(disableBtns)
                    HStack{
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            setA()
                            bStr()
                            dS()
                            showAn()
                            //                        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                            //                            showA = false
                        }, label: {
                            HStack {
                                Image(systemName: "questionmark.app.fill")
                                Text("정답 보기")
                            }
                        })
                        .disabled(disableBtns)
                        .buttonStyle(fancyButton(bbtn: false))
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            setA()
                            checkAn()
                            //                        bStr()
                            withAnimation(.easeInOut(duration: 0.5)) {
                                //                            showAn()
                                showC = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                randomQuiz()
                                showA = false
                                showC = false
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("제출 하기")
                                    .fontWeight(.semibold)
                            }
                        })
                        .disabled(disableBtns)
                        .buttonStyle(fancyButton(bbtn: true))
                        //                    Button(action: {
                        //                        randomQuiz()
                        //                    }, label: {
                        //                        Text("rqz")
                        //                    })
                    }
                }
                Spacer()
            }
        }
        .background(Color("mode"))
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .center
            )
        .onTapGesture {
            isEditing = false
        }
        .navigationTitle("문제 풀이")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .onAppear {
            if isFirstAppear { // Prevent loading quiz again
                getQuests() { P in // Get Quiz from API
                    problems = P // Set Quiz
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Wait for 1 second
                        var rInt = Int.random(in: 0..<problems.count) // Random Int
                        if shownP.contains(rInt) {
                            rInt = Int.random(in: 0..<problems.count) // Reroll if shownP contains rInt
                        }
                        withAnimation {
                            showL = false // Hide Loading
                            p = problems[rInt].quiz // Set Problem
                        }
                        shownP.append(rInt) // Add rInt to shownP to prevent same quiz being shown again
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showP = true // Show Problem
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        withAnimation {
                            isEditing = true // Show Keyboard
                        }
                    }
                }
                if readKeyChain("sub") != "" {
                    cprint("Fetching Score.", "PSView_onAppear", false)
                    
                    sendGET(auth: generateToken(readKeyChain("sub")).out, endpoint: "getscore", sub: readKeyChain("sub")) { s in
                        print(s["score"])
                        if s["success"] as! Bool {
                            score = String(format: "%@", s["score"] as! CVarArg)
                            showAccountScore = true
                        } else {
                            score = "Error! \(s["error"] as! String)"
                            cprint(score, "PSView_onAppear", true)
                        }
                    }
                }
            }
            isFirstAppear = false // Set isFirstAppear to false
        }
    }
    func randomQuiz() { // Randomize Quiz
        disableBtns = false // Disable Buttons, TextField
        var rInt = Int.random(in: 0..<problems.count) // Random Int
        if shownP.contains(rInt) {
            rInt = Int.random(in: 0..<problems.count) // Reroll if shownP contains rInt
        }
        withAnimation {
            showP = false // Hide Problem
            p = problems[rInt].quiz // Set Problem
        }
        shownP.append(rInt)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                ua = "" // Clear TextField
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showP = true // Show Problem
//                isEditing = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
//                showP = true
                isEditing = true // Show keyboard
            }
        }
    }
    func setA() { // Set Answer
        var b = problems[shownP.last!].answer // Set b to answer array
        var c = "" // Set c to empty string
        b.forEach { i in
            if i.contains(" ") {
                c = String(i.replacingOccurrences(of: " ", with: "")) // Set c to answer string without space
            }
        }
        if !c.isEmpty {
            if !b.contains(c) {
                b.append(c) // Append answer without space to b
            }
        }
        a = b // Set a to b
//        print(problems[shownP.last!].answer)
//        print(a)
    }
    func showAn() { // Show Answer
        disableBtns = true // Disable Buttons, TextField
        withAnimation(.easeInOut(duration: 0.3)) {
            showA = true // Show Answer
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // After 2 seconds
            randomQuiz() // Randomize Quiz
            showA = false // Hide Answer
        }
    }
    func checkAn() { // Check if answer is correct
        disableBtns = true // Disable Buttons, TextField
        correct = false // Initialize 'correct'
        if a.contains(ua) || a.contains(ua.replacingOccurrences(of: " ", with: "")){
            correct = true // Set 'correct' to true if answer array contains user answer (answer is correct)
            if readKeyChain("sub") != "" {
                let aT = generateToken(readKeyChain("sub"))
                if aT.success {
                    sendPOST(auth: aT.out, endpoint: "addscore", sub: readKeyChain("sub")) { v in
                        if v["success"] as! Bool {
                            print(v)
                            cprint("Score Added: \(v["score"]!)", "checkAn", false)
                            score = String(format: "%@", v["score"] as! CVarArg)
                        } else {
                            cprint("Failed Adding Score", "checkAn", true)
                        }
                    }
                }
            }
        } else {
            bStr() // Set b to answer ex: a, b or a
            showAn() // Show Answer
            dS()
            correct = false // Set 'correct' to false if answer array doesn't contain user answer (answer is incorrect)
        }
    }
    func bStr() { // Set b to answer ex: a, b or a
        
        var b = "" // Set b to empty string
        if a.count == 1 { // If answer array has only one answer
            b = a[0] // Set b to answer
        } else { // If answer array has more than one answer
            a.forEach { a in
                b += "\(a), " // Append answer to b
            }
            b.removeLast() // Remove last space
            b.removeLast() // Remove last comma
        }
        sa = b // Set sa to b
    }
    func dS() {
        if readKeyChain("sub") != "" {
            let aT = generateToken(readKeyChain("sub"))
            if aT.success {
                sendPOST(auth: aT.out, endpoint: "downscore", sub: readKeyChain("sub"), params: ["score": 1]) { v in
                    if v["success"] as! Bool {
                        cprint("Score Downed: \(v["score"]!)", "checkAn", false)
                        score = String(format: "%@", v["score"] as! CVarArg)
                    } else {
                        cprint("Failed Downing Score", "checkAn", true)
                    }
                }
            }
        }
    }
}

