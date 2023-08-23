//
//  EncouragingThingsManager.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/08/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct EncouragingThingsManager {
    let encouragingThingsCollection = Firestore.firestore().collection("encouraging")
    let strEncouraging = "encouraging"
    
    func setEncouragingThings() async throws {
        let encouragingThingsRef = encouragingThingsCollection.document(strEncouraging)
        
        let newEncouragingThings = [
            EncouragingWordsAndImage(score: .spendOver100, words: ["파.산.", "대체 뭘 하면 이렇게 돼...?", "분리수거를 기다리는 중입니다"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F46893D4F-D0D1-4820-9AD2-160A9F53C5ED.png?alt=media&token=4ec7b206-cec0-4a63-91bb-59b987f8c307"),
            EncouragingWordsAndImage(score: .spendOver50, words: ["허공에 돈 뿌리기!"], image: "https://console.firebase.google.com/u/0/project/poorguys-ad187/storage/poorguys-ad187.appspot.com/files/~2Fencouraging_Images?hl=ko"),
            EncouragingWordsAndImage(score: .spendOver50, words: ["앱한테 욕먹는중", "UserNickName{야/아}...?"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F772EFD1E-CBF9-4DA6-8545-F5E276E1ED80.png?alt=media&token=4cf66bf3-01ba-4590-9030-9a4509582738"),
            EncouragingWordsAndImage(score: .spendOver50, words: ["불 태웠다...", "늘 우는 건 미래의 나...", "KIJUL"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F9B265A03-FE16-4B75-AAAA-C85297B1D7EE.png?alt=media&token=b8877bde-2d06-4cd6-b1d3-0a1f7303ada2"),
            EncouragingWordsAndImage(score: .spendOver20, words: ["차비조차 없는 UserNickName...", "꾸웨엑"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"),
            EncouragingWordsAndImage(score: .spendOver20, words: ["0이 1..2..3개가 넘어?", "어디 썼더라..."], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F68B46693-EE7D-4B10-9D88-F067B1B3D153.png?alt=media&token=970fef12-e06c-4ead-ad09-880770d9b55f"),
            EncouragingWordsAndImage(score: .spendOver20, words: ["내일 뭐먹으려구!!!", "그렇게 쓸 때 알아봤다ㅋ"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F7C76072D-BBB6-4BF2-AEE9-EEDC416F2637.png?alt=media&token=f882249f-031f-400e-9e3b-211d0e525aef"),
            EncouragingWordsAndImage(score: .spendOver20, words: ["UserNickName{는/이는} 하루살이"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2FFC6782E2-D427-4843-97A8-5C7B8BB68186.png?alt=media&token=4cc389aa-d8f7-4082-b1ee-1c1a59baca28"),
            EncouragingWordsAndImage(score: .spendOver5, words: ["아...떨굼ㅎ", "UserNickName: 실수로 낭비한 척 하는 중"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42B72BE8-F7AB-44F0-98DB-E01DCAC8AC19.png?alt=media&token=9c4f302f-1ca5-4287-93a8-fb41afd1fe09"),
            EncouragingWordsAndImage(score: .spendOver5, words: ["UserNickName{야/아} 장난해?", "니 무하노?"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F7947A133-629F-4387-99E7-B89CB98391BC.png?alt=media&token=d7aaa018-ba3e-4e4a-86c0-85c334a262cf"),
            EncouragingWordsAndImage(score: .spendOver5, words: ["네 돈... 납치된거야", "저기요 뭐하세요?"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F900726C2-8623-428E-9D1A-9CF914E5B011.png?alt=media&token=94fafbca-2bd9-4c13-97b5-1d8cac6747af"),
            EncouragingWordsAndImage(score: .spendSome, words: ["에라잇", "낭비는 한장까지 봐주겠음", "부자까지 9999+1 걸음"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F6037C1F7-FC44-406C-A5ED-FEC1C05E2EA0.png?alt=media&token=719cdc07-5999-461d-856b-b2736bd0b658"),
            EncouragingWordsAndImage(score: .spendSome, words: ["에라잇", "힝..내 돈", "아직 까진 그래도 돈이 있네", "부자까지 9999+1 걸음"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F7D90C101-717E-4A51-AEAC-49EEBB96C958.png?alt=media&token=210f0d92-4cd2-4404-b119-9521e74e2373"),
            EncouragingWordsAndImage(score: .spendSome, words: ["이거...뭐냐...", "소비와의 전적 1패", "부자까지 9999+1 걸음"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F8D17B482-FF93-4BCB-B046-7CB6E9189D4B.png?alt=media&token=89f5781b-4c94-4cc8-9f1e-228449e2ebb1"),
            EncouragingWordsAndImage(score: .zero, words: ["쓸 것인가 말것인가 그것이 문제로다", "0원? 낫베드"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F66641B96-2E1B-4AE4-8475-E5C0EC1CF799.png?alt=media&token=18b2775c-864b-4ea6-95a3-5f4fed8e432b"),
            EncouragingWordsAndImage(score: .zero, words: ["그냥 아껴!", "분발하자", "너도 아낄 수 있어!"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2FEDFCC0E9-D3A4-40BE-8559-22F29FD729CF.png?alt=media&token=6e96745b-0126-4486-ace6-a9840389c86c"),
            EncouragingWordsAndImage(score: .saveSome, words: ["물컵 아니고 지폐 2장!"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc"),
            EncouragingWordsAndImage(score: .saveSome, words: ["UserNickName 굿!", "올ㅋ"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"),
            EncouragingWordsAndImage(score: .saveSome, words: ["돈이 솟는다!!", "화이팅!!", "돈크업!"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2FC463F5CA-7D04-4A02-B73B-EBEE07760F81.png?alt=media&token=7c208558-bdcf-485a-a694-70998c2662ce"),
            EncouragingWordsAndImage(score: .saveOver5, words: ["UserNickName{/이} 짱이다~", "우쭈쭈 잘했쪄", "참 잘했어요!"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F6B0FE968-FF1E-4B06-A2FC-67789E37AE16.png?alt=media&token=15e7466b-440a-4f2e-aaa7-92c7e9002883"),
            EncouragingWordsAndImage(score: .saveOver5, words: ["돈 맛을 알아버린 UserNickName", "아끼는 게 채고야~"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2FC8CDA30A-6174-44AD-8268-7407F6B69632.png?alt=media&token=e7f24f1d-208b-4467-bb8e-18f7d89b9e6e"),
            EncouragingWordsAndImage(score: .saveOver5, words: ["너 절약 좀 친다?", "쩌ㄴ다!"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2FACC4698E-2156-47A5-8E27-62471DA405B0.png?alt=media&token=847c0345-c64c-43e2-a9a2-1fe403392678"),
            EncouragingWordsAndImage(score: .saveOver20, words: ["UserNickName 폼 미쳤다"], image: "https://console.firebase.google.com/u/0/project/poorguys-ad187/storage/poorguys-ad187.appspot.com/files/~2Fencouraging_Images?hl=ko"),
            EncouragingWordsAndImage(score: .saveOver20, words: ["간절히 바라면 온 우주가 돈을!!"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0C064499-2148-418F-8EE7-7EEF68935056.png?alt=media&token=72aabb22-2461-4abe-8c1c-e5311d090df4"),
            EncouragingWordsAndImage(score: .saveOver20, words: ["이 정도면 돈 덮고 자도 될듯", "많이 아껴 행복한 UserNickName🥰"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F7D03C9C4-6C9C-400C-B99F-56568CBEC9F6.png?alt=media&token=6102f620-b9fc-4352-a664-e48a3f00282d"),
            EncouragingWordsAndImage(score: .saveOver20, words: ["짝짝짝짝!!!", "아낌 앵콜! 앵콜!"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2FCFF9C23C-8EBB-4AA7-8CF9-2F385440B59E.png?alt=media&token=448ac14e-c713-49e5-bb25-80132cc81f4f"),
            EncouragingWordsAndImage(score: .saveOver50, words: ["❤️"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F34B35ED8-E79F-4A59-B5B5-D64F03CC70C2.png?alt=media&token=95d3d132-12e0-41e8-97e5-d660f3705667"),
            EncouragingWordsAndImage(score: .saveOver50, words: ["돈다발 맛이 어때?"], image: "https://console.firebase.google.com/u/0/project/poorguys-ad187/storage/poorguys-ad187.appspot.com/files/~2Fencouraging_Images?hl=ko"),
            EncouragingWordsAndImage(score: .saveOver50, words: ["UserNickName{/이} 돈 만세!"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2FE5EB3508-494D-4352-A4A5-D293293FBDDA.png?alt=media&token=35e24d60-9bfd-40d9-a915-5dc81d7a9446"),
            EncouragingWordsAndImage(score: .saveOver100, words: ["역시 돈이 제일 따뜻해", "돈 복사 어렵지 않지?😎", "헤헤 돈 복사"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F03F6F7EE-3B3C-47CD-8462-E7214F0CE46A.png?alt=media&token=c75b68fb-4314-418d-9d98-41d3be962226"),
            EncouragingWordsAndImage(score: .saveOver100, words: ["UserNickName재용", "UserNickName 머스크"], image: "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F83DC5324-78B0-4CB8-91E2-A96C9372E6FD.png?alt=media&token=c9b7521e-059b-4cf3-950f-1dbb9bd8ca6e")
        ]
        
        let newEncouragingThingsData: [[String: Any]] = newEncouragingThings.map { $0.asDictionary() }
        
        try await encouragingThingsRef.setData([strEncouraging : newEncouragingThingsData])
    }
    
    func fetchAllEncouragingThings() async throws -> [EncouragingWordsAndImage] {
        let encouragingThingsRef = encouragingThingsCollection.document(strEncouraging)
        let documentSnapshot = try await encouragingThingsRef.getDocument()
        
        guard var data = documentSnapshot.data(), documentSnapshot.exists else { throw FirebaseError.documentNotFound }
        
        if let encouragingThingsArray = data[strEncouraging] as? [[String: Any]] {
            let encouragings = encouragingThingsArray.compactMap { dict -> EncouragingWordsAndImage? in
                guard let strScore = dict["score"] as? String,
                      let words = dict["words"] as? [String],
                      let image = dict["image"] as? String else {
                          return nil
                      }
                
                return EncouragingWordsAndImage(score: ConsumptionScore(rawValue: strScore) ?? ConsumptionScore.unknownData, words: words, image: image)
            }
            
            return encouragings
        } else {
            return []
        }
    }
}
