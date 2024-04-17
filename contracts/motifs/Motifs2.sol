// SPDX-License-Identifier: MIT
        pragma solidity ^0.8.0;

        import "../BasicMotif.sol";
        contract Motifs2 is IMotifData {
           

            function getMotifData(uint index) public pure returns (bytes memory) {
                string[5] memory motifs = [hex"526564526f636b00000000000000000000000000025d434cf9baa96500b400fa02757000000000000000050376013a007101080190646f776e00000000013c027e020800aa0206070064003c706174682066696c6c3d22234639423233332220643d224d302033313068313038307637373048307a222f3e3c706174682066696c6c3d22234639423233332220643d226d323430203239362d36362d31362d31342d3435682d31336c2d32372032382d34352d31342d3435203137682d353776343768313138397a222f3e3c672069643d22686f72697a6f6e5f627269676874222066696c6c3d2223464645423830223e3c7061746820643d226d313230203236332d34352d31342033372032327a6d343537203433203232382d3135203131392031387a6d2d3333372d31304837356c35332d31376835397a222f3e3c7061746820643d224d31363020323335683237763439682d32377a222f3e3c2f673e3c706174682066696c6c3d22234641433135432220643d226d2d32353020343934203437312d31332d3437312d33307a6d3734342d3732203432352d31367632337a4d2d3238203638306c3437312d31332d3437312d33307a6d31323134203132392d3437302d3133203437302d33307a222f3e3c706174682066696c6c3d22234635413433332220643d224d37363920323237682d3938763135682d3135763239682d397632376c2d3735203539683139377a222f3e3c706174682066696c6c3d22234641433835432220643d224d38343320333333762d3734682d32317635386c2d33342d3233762d3532682d35357635346c3336203631683131307a6d2d32353020352035342d32392d312d31312d34312032347a222f3e3c706174682066696c6c3d22676f6c642220643d224d313036342034303456323837682d33387638306c2d31352d3134762d3737682d33307634386c2d31312d3131762d3236682d32347634306c353820313736683136337a4d383633203236337635346c2d31342031332032392d3133762d35347a6d3338203132372d31322d3130563236336831327a4d373033203536327632316834317a6d2d3134392d33365632313548343130763233682d3435763236376c2d333720313133203234302031312035312d31387a222f3e3c706174682066696c6c3d22234637413930302220643d224d333539203633396836316c2d36312d33317a6d2d31322d333736763538682d333276313330682d31356c2d38332036312037372d312d3637203634203130312034332034382d3835563236337a6d3539392036342d353720353356323538682d31337635386c2d32372031347633386c2d3130312039362d3438203339683330347a222f3e3c706174682066696c6c3d22234632384430302220643d226d373438203436342d37372033396832397a6d3134312d37342035372d36332d35372034307a6d2d34302d32322d3130312039367633336c3130312d39357a4d323035203530336c2d34322032316834327a6d2d3932203336364c2d313420353232763334387a6d3439342d353536682d3232762d3237682d31356c312d3439682d36367634396832366c2d31203232362038392039362037332d33332d38352d39347a4d313436203836356832363776323537483134367a6d313130382d36384c39383720393839683236377a222f3e3c706174682066696c6c3d22234637413930302220643d224d3938372039383976373468323637762d37347a222f3e3c706174682066696c6c3d22676f6c642220643d226d333739203936342d35392d33352037342d32312031392d3435482d32337632323968323538762d34366c3134342d35357a222f3e3c706174682066696c6c3d22234646453736362220643d226d373930203938392d393320312d37312d3633483439346c2d35352036372d3133312035387634396c3830312d33762d3737483832327a4d3337203636316c2d35312d313339763135387a222f3e3c75736520687265663d222363616374757322207472616e73666f726d3d226d617472697828312e342030203020312e34203234322036343629222f3e3c75736520687265663d222363616374757322207472616e73666f726d3d226d6174726978282e373520302030202e373520313032312035353029222f3e3c75736520687265663d222363616374757322207472616e73666f726d3d226d6174726978282e343220302030202e3432203632352033393329222f3e3c75736520687265663d222363616374757322207472616e73666f726d3d226d6174726978282e3520302030202e35203232302033383229222f3e3c75736520687265663d222363616374757322207472616e73666f726d3d226d6174726978282e343420302030202e34342032382033393329222f3e3c706174682066696c6c3d22234632384430302220643d224d313531203734356132203220302030203120343420307a6d333537203130356134203420302030203120383420307a6d3136332d3435396132203220302030203120333020307a4d3533203433376132203220302030203120343020307a6d393439203138396132203220302030203120343020307a222f3e3c706174682066696c6c3d22233634393632342220643d224d3532203535386133203320302030203120363020307a222f3e3c706174682069643d226361637475735f736d616c6c222066696c6c3d22233634393632342220643d224d38303320393439682d3331762d3332682d3532763935683532762d33336833317a222f3e3c672069643d2263666c6f776572223e3c636972636c652063783d22373330222063793d223931372220723d223232222066696c6c3d2223453633333241222f3e3c636972636c652063783d22373330222063793d223931372220723d223130222066696c6c3d2223464646222f3e3c2f673e3c75736520687265663d222363666c6f77657222207472616e73666f726d3d227472616e736c61746528323735202d393629222f3e3c75736520687265663d222363666c6f77657222207472616e73666f726d3d226d6174726978282e363720302030202e36372033343320333729222f3e3c212d2d646f776e2d2d3e3c212d2d75702d2d3e3c75736520687265663d222363616374757322207472616e73666f726d3d226d617472697828352e312030203020352e31203734362036303229222f3e3c67207472616e73666f726d3d226d617472697828312e322030203020312e32203336322039303529223e3c212d2d666c6f7765722d2d3e3c2f673e",hex"53746f6e6568656e676500000000000000000000030ced5cffe421ed00b400fa027363656e65320000008701e0027b00e5010200c87363656e65310000008701e0027b00e50100006402000127001101200064003201230064004b012500490068012b0049008101260049009a0128004900ae012d003600c30131003600d6012e003600ea0134001f000201340036002201310036005a0131003674726565000000007472656500000000000130027b031301e0023f032001e000970164007800be01660096003c0156006e0345022c012c030b0263012c0416019d012c0387016c0078ffd903fb032a0017019b00fa00ee01df00fa009401d501400087044b01a4ffad0448032a037402980172627573680000000062757368000000003c646566733e3c636972636c652069643d22747265652220723d223236222066696c6c3d2223394242323234222f3e3c706174682069643d2262757368222066696c6c3d22233942423232342220643d224d3020306131203120302030203120323020307a222f3e3c2f646566733e3c672069643d226c656674223e3c212d2d747265652d2d3e3c2f673e3c75736520687265663d22236c65667422207472616e73666f726d3d226d6174726978282d312030203020312031303736203029222f3e3c706174682066696c6c3d22234639423233332220643d224d302033313068313038307637373048307a222f3e3c672066696c6c3d2223464244313835223e3c7061746820643d226d2d333233203830302034343720323139203339382d3137352d3537312d3237347a222f3e3c7061746820643d226d2d37203537382d372d31373520363130203330302032203231307a222f3e3c7061746820643d226d353339203531302d3333203433203230312038322d3136362039352d33312d3234203134332d37322d3139322d38322035302d3530222f3e3c7061746820643d226d3533392033343720323737203135203131392035392d3132312035332d3237342033362d3235332d34302d3134342d3439203131302d35377a222f3e3c2f673e3c212d2d627573682d2d3e3c706174682066696c6c3d22234246363645452220643d226d3336312033363420333520312d362d35302d323220317a6d343131203820333420342d312d3531682d32327a222f3e3c706174682066696c6c3d22233934303045332220643d226d3632342033373420323920312d352d34332d313820327a6d2d33362d3420323820312d342d34332d313920327a6d2d3133382d3920333920312d362d35382d323520327a6d3634203020333920312d362d35382d323520327a6d3230342032326833346c2d382d35382d323120337a6d2d343320306833346c2d322d3537682d32317a222f3e3c706174682066696c6c3d22233934303045332220643d224d363837203332386836326c322d32372d363720357a6d313634203535682d33326c372d34382031362d312031332031357a222f3e3c672066696c6c3d2223424636364545223e3c7061746820643d224d36343920343131682d31326c322d3130362031332d31386832336c313820313576313039682d31327a6d2d38342030682d31336c362d3131302031332d313820323320312031372031352d3220313132682d31337a222f3e3c7061746820643d226d3536322032393820362d32372032372d3268326c36322d3320372037203434203120332032357a6d32363020313039682d32326c2d31302d33352031392d377a6d2d3533382d33356833356c2d362d35312d323220327a6d2d333020306832306c352d35342d31382d322d372032347a222f3e3c7061746820643d224d33313120333235762d31376c2d33332d392d323020332d332032337a6d38382d382d322d31372d32382d342d313720342d3120313520323120357a222f3e3c7061746820643d224d333738203433316835386c2d312d313437682d33317a222f3e3c2f673e3c706174682066696c6c3d22233934303045332220643d226d323330203430332d33312d322031352d33342031342031397a6d383030203238682d36336c2d382d3137362032332d31302035352039387a6d2d3732372d3139762d38366c382d363020343620323220392036352d31382035397a6d3131342d3135302d34203431203134312031362035342d323020332d33372d35352d32317a222f3e3c706174682066696c6c3d22233934303045332220643d224d35323420343537683732563330306c2d35342d31327a6d2d3131342030683637563330346c2d34372d31367a6d3339332d3135682d34366c372d31383820372d322032322031397a6d3131322d3331682d35396c31312d32362034382031377a222f3e3c706174682066696c6c3d22234141373033352220643d224d3020353335763130356c38313920343430683139377a222f3e3c706174682066696c6c3d22234339383046312220643d224d34383920393138683776313236682d377a222f3e3c636972636c652063783d22343933222063793d223930312220723d223239222066696c6c3d2223463238443030222f3e3c212d2d7363656e65312d2d3e3c212d2d7363656e65322d2d3e3c67207472616e73666f726d3d227472616e736c617465283733302037313029223e3c212d2d666c6f7765722d2d3e3c2f673e",hex"54616a4d6168616c000000000000000000000000019ea41004a6d41c0000015e0004000124003d02250064009f0218004f00ef020d003f012d02070032015d02000028018501fc002003fb0225006403990218004f0349020d003f030b0207003202db0200002802b301fc00206275736800000000627573680000000000014800e701b0027000e70157020000e700de006f00e7011301a5013901d8020d0139018d01af01390127006f013901540162035101b00270035101570200035100de006f0351011301a502ff01d8020d02ff018d01af02ff0127006f02ff0154016201b80125006f0170015b006f019a015b006f02800125006f02c8015b006f029e015b006f021c006d0094021c009f00947475727265740000747572726574000000012a01b8014900a70280014900a7018401ca006f0184018d006f01b201ca006f01b2018d006f02b401ca006f02b4018d006f028601ca006f0286018d006f00e700f400640139013b0054035100f4006402ff013b0054726f6f660000000072726f6f6600000000010601cf013e006f0269013e006f747572726574320074757272657400003c646566733e3c672069643d2272726f6f66222066696c6c3d222342463636454522207472616e73666f726d3d227363616c652831202d3129223e3c7061746820643d224d2d31322d31376832345636682d32347a222f3e3c636972636c652063793d22352e352220723d223132222f3e3c2f673e3c672069643d22747572726574223e3c706174682066696c6c3d22233934303045332220643d224d2d312d336832762d37682d327a222f3e3c706174682066696c6c3d22234541434346392220643d224d2d332031306836562d36682d367a222f3e3c706174682066696c6c3d22233934303045332220643d224d2d342d326838762d31682d387a222f3e3c2f673e3c656c6c697073652069643d2262757368222063783d2230222063793d2230222066696c6c3d2223394242323234222072783d223330222072793d22313438222f3e3c2f646566733e3c706174682066696c6c3d22234644453041442220643d226d313333203531312d3134372d33302d3134362033307a222f3e3c706174682066696c6c3d22234644453041442220643d226d353538203531312d3238302d34382d3238302034387a6d36373820302d3238302d35342d3238302035347a222f3e3c706174682066696c6c3d22234641433135432220643d224d2d3520353036683130383976353734482d357a222f3e3c706174682066696c6c3d22234646453736362220643d224d2d3233203531356831313237763235482d32337a6d363435203235483435386c2d313239362036303468323735367a222f3e3c706174682066696c6c3d22234646453736362220643d226d2d373320363630203432372d313230682d36376c2d3336302035397a6d3132323620304c373236203534306836376c3336302035397a222f3e3c706174682066696c6c3d22234639423233332220643d224d35373620353430682d37324c353020393830683938307a222f3e3c706174682066696c6c3d2275726c28237761746572292220643d224d35373620353430682d37324c353020393830683938307a222f3e3c656c6c697073652063783d22353430222063793d22323535222066696c6c3d2223424636364545222072783d223731222072793d223835222f3e3c672066696c6c3d2223454143434639223e3c7061746820643d224d333634203335376833353176313331483336347a222f3e3c7061746820643d224d343639203238316831343276313533483436397a222f3e3c7061746820643d224d343537203332376831363576313630483435377a222f3e3c2f673e3c212d2d7475727265742d2d3e3c212d2d726f6f662d2d3e3c706174682066696c6c3d22234339383046312220643d224d3230312034383768363738763336483230317a222f3e3c706174682066696c6c3d22234434393946342220643d224d343833203335326831313376313335483438337a222f3e3c706174682066696c6c3d22234139333345392220643d224d35303020343132683830763736682d38307a222f3e3c636972636c652063783d22353430222063793d223431312220723d223430222066696c6c3d2223413933334539222f3e3c75736520687265663d2223726f756e64726f6f6622207472616e73666f726d3d227472616e736c6174652835343020343638297363616c6528312e313129222f3e3c672066696c6c3d2223393430304533223e3c636972636c652063783d223534302e32222063793d223132332e352220723d22362e38222f3e3c636972636c652063783d223534302e32222063793d223135332e362220723d22362e38222f3e3c636972636c652063783d223534302e32222063793d223133382e372220723d22392e36222f3e3c2f673e3c212d2d747572726574322d2d3e3c212d2d627573682d2d3e3c67207472616e73666f726d3d226d617472697828312e332030203020312e3320353430203130323529223e3c212d2d666c6f7765722d2d3e3c2f673e",hex"416d617a6f6e6173000000000000000000000000ffcd9dfffc62595a00b4015e037363656e6531000002ed00b901440104010b012c7363656e65320000000500f600bc008a010b00c87363656e65330000010e003f00870057010b00640100012d01f902600056038c029000ab032e02c900ab027502cb00840442033200dd0409030300b502f402f200ab02370265007c0084021a005600b902100044011b021000390155020600390297027d00560016028300ab002702260079627573683100000062757368310000003c646566733e3c636972636c652069643d22747265652d627573685f6461726b222063783d2230222063793d22302220723d223536222066696c6c3d2223363439363234222f3e3c636972636c652069643d22747265652d627573685f6d6964222063783d2230222063793d22302220723d223536222066696c6c3d2223394242323234222f3e3c672069643d22687574223e3c706174682066696c6c3d22234333394237322220643d226d33342d35382035203532682d37386c332d35327a222f3e3c706174682066696c6c3d22234334324433382220643d224d2d31352d31316833316c2d342d3437682d32347a222f3e3c706174682066696c6c3d22234141373033352220643d224d2d35302d313520322035356c34392d36367a222f3e3c2f673e3c2f646566733e3c75736520687265663d2223747265652d627573685f6d696422207472616e73666f726d3d226d6174726978282e383820302030202d2e3334203430362033383329222f3e3c75736520687265663d2223747265652d627573685f6461726b22207472616e73666f726d3d226d6174726978282e373520302030202d2e3435203338342033343729222f3e3c75736520687265663d2223747265652d627573685f6461726b22207472616e73666f726d3d226d6174726978282e373820302030202d2e3439203437392033363029222f3e3c656c6c697073652063783d22343236222063793d22333630222066696c6c3d2223363439363234222072783d2232312e3238222072793d223130222f3e3c706174682066696c6c3d223c212d2d7761746572636f6c6f722d2d3e2220643d224d302033383468313038307636393648307a222f3e3c706174682066696c6c3d2275726c28237761746572292220643d224d302033383468313038307636393648307a222f3e3c706174682066696c6c3d22676f6c642220643d226d343433203338352d34352032322d31352031362039342032382d33302039203137342032342031382032342034363820313220352d3133397a222f3e3c706174682066696c6c3d22676f6c642220643d226d32343420353033203133332d33302d34332d31362034392d31302d35302d32322034392d33312034342d31302d3132382d312d3332362d37763132367a222f3e3c706174682066696c6c3d22233942423232342220643d224d32393820343336203239203338346c2d3237302034357a6d3134382037372d3236372d36322d3237312033367a222f3e3c706174682066696c6c3d22233942423232342220643d226d323432203438392d3236372d36322d3237312033367a6d393736203131302d3335372d37342d3335362038307a222f3e3c75736520687265663d2223747265652d627573685f6d696422207472616e73666f726d3d226d617472697828322e313720302030202d312e3833203539332033363129222f3e3c75736520687265663d2223747265652d627573685f6d696422207472616e73666f726d3d226d617472697828322e313220302030202d312e3134203637362032373229222f3e3c706174682066696c6c3d22234646444231392220643d226d31353920353630203238372d34362d3138392d33312d31343920322d3133362d32327632316c2d34342d332d3820323534633320302032342d31352035302d33336c2d31203435203138322d34382d35342d33312037342d32332d37362d34342039302d32357a222f3e3c75736520687265663d2223747265652d627573685f6d696422207472616e73666f726d3d226d617472697828322e303920302030202d312e33312037392031373129222f3e3c75736520687265663d2223747265652d627573685f6d696422207472616e73666f726d3d226d617472697828312e3920302030202d2e3734203237322033333129222f3e3c75736520687265663d2223747265652d627573685f6d696422207472616e73666f726d3d226d617472697828312e313920302030202d2e3432203333362033363029222f3e3c75736520687265663d2223747265652d627573685f6d696422207472616e73666f726d3d226d617472697828312e313920302030202d2e3432203330392033383329222f3e3c75736520687265663d2223747265652d627573685f6461726b22207472616e73666f726d3d226d617472697828312e3620302030202d2e3935203235342032363129222f3e3c75736520687265663d2223747265652d627573685f6461726b22207472616e73666f726d3d226d617472697828312e323320302030202d2e3535203239392032393429222f3e3c706174682066696c6c3d22234233383034422220643d226d3239392031363820323520362d3330203135362d34322038312d32392d372034332d38347a6d3131203230326831376c31332039362d3130203534682d32306c31302d35367a222f3e3c706174682066696c6c3d22234233383034422220643d226d323039203333382032392d31203236203131382d31352036372d333420312031352d36397a6d363420386831386c3134203130322d3131203537682d32316c31312d35397a6d2d373320313539682d31326c2d31312d31303520372d35396831356c2d372036317a6d2d37332036682d31326c2d31312d31303520372d35396831356c2d372036317a222f3e3c706174682066696c6c3d22234233383034422220643d224d31363420353237682d32346c2d31352d3134322031362d37396832396c2d31372038327a6d3134302d3330362d31352031342d33372d34362d352d34302031382d313620362034317a6d2d333920393668396c372038362d35203438682d31306c352d34397a6d3238342036382033312d36203537203136317639366c2d33372037762d39397a6d31363320323530682d31366c2d31332d31353520392d38376831386c2d382038397a222f3e3c75736520687265663d2223747265652d627573685f6461726b22207472616e73666f726d3d226d617472697828312e3539202d2e3034202d2e3032202d2e3736203135382032323329222f3e3c75736520687265663d2223747265652d627573685f6461726b22207472616e73666f726d3d226d617472697828312e3520302030202d312e3039203230302032393429222f3e3c706174682066696c6c3d22233634393632342220643d224d33303120333137683130763631682d31307a6d2d34312d33306836763730682d367a222f3e3c7573652066696c6c3d22233634393632342220687265663d222363726f776e22207472616e73666f726d3d226d6174726978282e3420302030202d2e34203332302031383029222f3e3c706174682066696c6c3d22234646444231392220643d226d383038203535362d39302031352d32333520333820313238203138332034383020343220312d333720352d3231337a222f3e3c75736520687265663d222368757422207472616e73666f726d3d226d6174726978282e3720302030202d2e37203737312036343029222f3e3c212d2d62757368312d2d3e3c75736520687265663d222368757422207472616e73666f726d3d226d6174726978283120302030202d31203935382036373929222f3e3c672066696c6c3d2223414137303335223e3c7061746820643d226d3230203639332039342032382d352031362d39342d32387a222f3e3c7061746820643d226d323220373134203130302d3234203220392d3130302032347a6d34332d39352039372033342d3320382d39372d33347a222f3e3c7061746820643d226d3738203635302038362d3239203320392d38362032397a6d36342d35352d34322d31372d3220342034332031387a6d37362d35352d3432203139203220342034322d31397a6d2d36332032332d3437203520312031302034372d357a6d37363520313939683337762d3131682d33377a6d2d3232382d32312033372d32342d31302d31342d33372032347a6d3139322039322039392d33382d342d31322d39392033387a6d2d3239392d3136203131312d35342d372d31342d3131312035357a222f3e3c7061746820643d226d363737203736332034352033352031312d31342d34352d33357a222f3e3c7061746820643d226d373231203739382038342d35312d392d31352d38342035317a6d2d3235382d3230203133312d34372d352d31352d3133312034377a6d33302d38342039312d33322d352d31342d39312033327a222f3e3c7061746820643d224d34393120363532683936762d3135682d39367a222f3e3c7061746820643d226d343731203634382037312d32392d352d31322d37312032397a6d3138322039392d36362d33322d372031352036362033327a6d31363620313337203136322d36352d352d31322d3136322036357a222f3e3c7061746820643d226d3930342037383420363720363820392d382d36372d36387a222f3e3c2f673e3c7573652066696c6c3d22233942423232342220687265663d2223747265653122207472616e73666f726d3d226d6174726978282e3720302030202e37203130362032303029222f3e3c7573652066696c6c3d22233634393632342220687265663d2223747265653122207472616e73666f726d3d226d6174726978282d2e3620302030202e36203635302031343029222f3e3c672066696c6c3d2223363439363234223e3c672069643d22747265653122207472616e73666f726d3d226d6174726978283120302030202d3120313032302034393329223e3c706174682066696c6c3d22234141373033352220643d224d2d31302039322d37362d31336c2d33392035302d34382d364c2d35362d39396c2d323020312d313234203134332d382d32203132392d3136342033392d312031372d32352031302d39352d32352d3132332d33322d32342031382d3220313920392031312d313048356c31312031352031352d31346831336c2d3231203236203133203132332d3132203131342d323620333420323720343120382037324831354c342d34366c2d32332d32372d34362034394c2d342039327a222f3e3c672069643d2263726f776e223e3c7061746820643d224d3332382038316334382039352d3338203131342d3432203133342d3632203237382d353731203137392d3539342034352d3133332d36362d32342d3133302d32312d3133322d31342d31302d32312d3739203130362d3131342037382d3231203230392d332032303520332033372d3632203230312d3732203230332d363820362d35203330322032382031343320313332222f3e3c7061746820643d224d332d31393768313256323348337a6d2d333020383068313076323230682d31307a6d2d3133302039683132563132682d31327a222f3e3c2f673e3c7061746820643d224d2d3236332d3738683139563432682d31397a6d3231302d3830683132563132682d31327a222f3e3c2f673e3c2f673e3c706174682066696c6c3d22234642443138352220643d224d3531362031303537483135326c35312d3238683336347a222f3e3c706174682066696c6c3d22234237383535332220643d226d323433203130343720392d3233302d33392d31333620313231203139312d3238203137357a222f3e3c706174682066696c6c3d22234141373033352220643d226d3237372035363120392033302d32352036392d31392d342d352032372d32342d322035362031323720313020323339683133346c2d35362d3132362d322d3130302033392d3436563633356c32392d32362d352d362d34372032362d36203132332d32372031392d35302d3130392031382d38312d31302d32347a222f3e3c706174682066696c6c3d22234141373033352220643d226d3333312039323720313930203131322d32332d312d3137322d3130317a222f3e3c706174682066696c6c3d22234237383535332220643d226d31393720313034342039362d393720322031372d38302038317a222f3e3c67207472616e73666f726d3d226d617472697828312e322030203020312e32203333362037383029223e3c212d2d666c6f7765722d2d3e3c2f673e3c212d2d7363656e65312d2d3e3c212d2d7363656e65322d2d3e3c212d2d7363656e65332d2d3e",hex"45617374657249736c616e640000000000000000fe62155ef97c63260128015e00003c646566733e3c672069643d2274696b695f48656164223e3c706174682066696c6c3d22234246363645452220643d226d2d3537203237312031312d39332d3135372d3231352039302d34362d32382d35322033302d32352d35312d3130392032312d34314c3132302032337a222f3e3c706174682066696c6c3d22233934303045332220643d226d3131332d323437203632203539372d3134362034312d38362d3132302035312d38372d37332d3131392033372d3136302d39392d3231352031382d33322034362031362d32302d3635203235302038317a222f3e3c706174682066696c6c3d22234246363645452220643d226d3437203133302036352039372032352d342d39332d3335382d34342031377a222f3e3c2f673e3c2f646566733e3c706174682066696c6c3d22233942423232342220643d226d3132313720313132332d313236362034334c32203430346c3435342d3839203537372036397a222f3e3c706174682066696c6c3d22233942423232342220643d226d31333430203333342d3430302d36362d333839203131347a222f3e3c706174682066696c6c3d22676f6c642220643d226d2d322033393120313230312d35332036203131387a222f3e3c706174682066696c6c3d223c212d2d7761746572636f6c6f722d2d3e2220643d224d302033383268313038307631303748307a222f3e3c706174682066696c6c3d2275726c28237761746572292220643d224d302033383268313038307631303748307a222f3e3c706174682066696c6c3d22676f6c642220643d224d302034373368313230327631313848307a222f3e3c706174682066696c6c3d22233942423232342220643d226d2d3132372036303120313432362d3238362037203233397a222f3e3c706174682066696c6c3d22234238433836342220643d224d32323738203734312d343833203432366c2d35203331357a222f3e3c75736520687265663d222370616c6d3222207472616e73666f726d3d226d6174726978282e383120302030202e38312039302035373329222f3e3c75736520687265663d222370616c6d3222207472616e73666f726d3d226d6174726978282e3520302030202e35203139362035333629222f3e3c75736520687265663d222370616c6d3222207472616e73666f726d3d226d6174726978282e343320302030202e3433203238332035333929222f3e3c75736520687265663d222374696b695f4865616422207472616e73666f726d3d226d6174726978282e323620302030202d2e3236203431372035343929222f3e3c706174682066696c6c3d22233942423232342220643d224d313039332037353620343536203633306c2d363338203132367a222f3e3c706174682066696c6c3d22233942423232342220643d226d31373131203730342d3633382d3231342d363338203231347a222f3e3c75736520687265663d222374696b695f4865616422207472616e73666f726d3d226d6174726978282d2e3134202d2e33202d2e3331202e3137203336392037363229222f3e3c706174682066696c6c3d22233942423232342220643d224d313231372038313720353830203639312d3538203831377a222f3e3c75736520687265663d222374696b695f4865616422207472616e73666f726d3d226d6174726978282e343720302030202d2e3437203136342036363329222f3e3c706174682066696c6c3d22234238433836342220643d224d3634382031313939482d33306c31342d323836203234372d313135203330392032377a222f3e3c706174682066696c6c3d22234238433836342220643d226d35343020383636203233372d313034203332392d3632387631303635483634387a222f3e3c706174682066696c6c3d22233634393632342220643d224d313020313038306831303730563733376c2d36353120323933222f3e3c75736520687265663d222374696b695f4865616422207472616e73666f726d3d226d617472697828312e303820302030202d312e3038203738382035323529222f3e3c67207472616e73666f726d3d226d617472697828312e352030203020312e35203335352039313529223e3c212d2d666c6f7765722d2d3e3c2f673e"];
                return bytes(motifs[index]);
            }
        }