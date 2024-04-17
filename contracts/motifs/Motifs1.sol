// SPDX-License-Identifier: MIT
        pragma solidity ^0.8.0;

        import "../BasicMotif.sol";
        contract Motifs1 is IMotifData {
           

            function getMotifData(uint index) public pure returns (bytes memory) {
                string[7] memory motifs = [hex"4368726973740000000000000000000000000000fea1c900fd6ca76c0069015e000200010c0133041a003e01f5048d003e01c50404003e010f047e003e70616c6d3200000070616c6d3200000000000c0286043a0171037201d4035601da03dd034a043a041c03f5627573683100000062757368310000003c672069643d22736561223e3c706174682066696c6c3d223c212d2d7761746572636f6c6f722d2d3e2220643d224d302034343468313038307636333548307a222f3e3c706174682066696c6c3d2275726c28237761746572292220643d224d302034343468313038307636333548307a222f3e3c2f673e3c672069643d2269736c616e64735f6e61636b222066696c6c3d2223394242323234223e3c7061746820643d226d353039203438312d3134362d33322d3134372033327a222f3e3c7061746820643d224d32333620343833203639203433356c2d3136382034387a222f3e3c7061746820643d226d333930203438332d3133342d33382d3133332033387a222f3e3c7061746820643d226d353534203438332d3130342d33302d3130342033307a222f3e3c7061746820643d226d343636203438332d34382d34392d34392034397a6d2d3233302d31352d37352d31392d37352031397a6d3432322034312d33362d31312d33382031317a6d2d3434372033304c3435203439316c2d3136362034387a222f3e3c7061746820643d226d323931203533392d37312d32302d37312032307a222f3e3c2f673e3c672069643d2269736c616e6473223e3c706174682066696c6c3d22234146433135302220643d226d2d31303120363738203138312d34322031312d34352032372d33386831386c3136203230203532203130327a222f3e3c706174682066696c6c3d22234646444231392220643d226d323630203638372033302031302d38312031392d3132392d31307a4d2d3234203534356c3334372d362d3334372d367a222f3e3c706174682066696c6c3d22234646444231392220643d226d323034203637352031322032332d3331372d32307a222f3e3c2f673e3c672069643d2268696c6c5f626165616368223e3c706174682066696c6c3d22676f6c642220643d224d302038343868313135317631363448307a222f3e3c706174682066696c6c3d22234146433135302220643d226d33383420383331203236302d31313520353436203234397a222f3e3c706174682066696c6c3d22233942423232342220643d226d333935203737352034322d36322033342d313020313920313720333520332036312033342034373820323732203132352039312d313330372d36203437322d3332397a4d3830203730366c35332d36392034362d313320323320332035382036302d36302031347a6d3433312d35372036362031382034392d31382d35362d31367a222f3e3c2f673e3c672069643d22636974797368617065223e3c706174682066696c6c3d22234246363645452220643d224d3135312038303968353176323634682d35317a222f3e3c706174682066696c6c3d22234246363645452220643d224d3131302038343268353176323634682d35317a6d2d38312d39683531763236344832397a222f3e3c706174682066696c6c3d22234434393946342220643d224d3020383930683334377632323548307a222f3e3c706174682066696c6c3d22234434393946342220643d224d36382038373468323232763139394836387a4d30203834386834307632333548307a222f3e3c706174682066696c6c3d22234434393946342220643d224d363820383537683333763232354836387a6d3530203068353176323235682d35317a6d39312d323768353176323434682d35317a222f3e3c706174682066696c6c3d22234246363645452220643d224d3733203930396834357632384837337a6d3630203335683435763739682d34357a6d2d39332032316834357639374834307a6d3138332d3635683333763533682d33337a222f3e3c706174682066696c6c3d22234234344345422220643d224d30203130313968353076343348307a6d3136312d3138683935763834682d39357a222f3e3c2f673e3c672069643d22666f7272657374223e3c656c6c697073652063783d22353036222063793d2231313037222066696c6c3d2223363439363234222072783d22323731222072793d22333031222f3e3c636972636c652063783d22393432222063793d22313231302220723d22333031222066696c6c3d2223363439363234222f3e3c706174682066696c6c3d22234339383046312220643d226d383237203839302d3230362d39362d353220397631326c2d34322d32332d343420337631346c3130342036387a222f3e3c212d2d70616c6d322d2d3e3c672066696c6c3d2223394242323234223e3c636972636c652063783d22353237222063793d223835372220723d223435222f3e3c636972636c652063783d2231303833222063793d223934392220723d223234222f3e3c636972636c652063783d2231303039222063793d223935322220723d223234222f3e3c636972636c652063783d22333639222063793d22313032332220723d223837222f3e3c2f673e3c212d2d62757368312d2d3e3c2f673e3c672069643d22706c6174656175223e3c706174682066696c6c3d22233946313945362220643d224d343939203839397636336c3733203134392032352d3130387a222f3e3c706174682066696c6c3d22233946313945362220643d226d353937203130303320313037203435683233306c37342d3432762d39336c2d3530392d31347a222f3e3c706174682066696c6c3d22234339383046312220643d226d353239203835372d333020343220323035203837683233306c37342d3433762d35307a222f3e3c706174682066696c6c3d22234339383046312220643d226d343939203839392036312031203836203230392d373420327a222f3e3c2f673e3c672069643d22666f72726573745f746f70222066696c6c3d2223394242323234223e3c636972636c652063783d22373333222063793d22313037382220723d223733222f3e3c636972636c652063783d22363431222063793d22313032342220723d223234222f3e3c636972636c652063783d22393835222063793d22313134332220723d22313433222f3e3c2f673e3c672069643d22737461747565223e3c706174682066696c6c3d22234246363645452220643d226d373939203233362d32342031372031372036362d34362038322d3720323039203920372d39203133392d323520352d313220313136682d31306c2d31203234203533203239203131362d3230307a222f3e3c706174682066696c6c3d22233934303045332220643d226d353536203333352035332d31302039203130203131392d352035382d323320342d373120333320322031372036312037342033312036382031322032312d36203239203920312031332d353020332d32332035342d36372d392d31382031302d3137203537203320323938203230203820362031313468396c332033312d313634203620332d323768386c31322d3131372032382d322d32362d31342031352d3239382d31382d35362d32302d31352d38392031342d33312d36332d313820382d35312d387a222f3e3c2f673e3c67207472616e73666f726d3d226d6174726978282e3520302030202e35203230302036333529223e3c212d2d666c6f7765722d2d3e3c2f673e",hex"436f6c6f737365756d0000000000000000000000027f304500bea48200b4015e077363656e656231000000018f00b4003d010000327363656e656232000387019900b4003d010000327363656e656d00000094024e032e007c010000647363656e6566000000df038b01fc00a9010200c874726565310000000028028400980098010500967472656532000000015802ab00640057010500967472656533000000038802d800b1003d010500960100026c032a010e0047ff4502080113006bff79021e017e007bfedb024e017e007bfee101ef017e007bfee1027e017e007bfee702ae017e007bfeed02de017e007bfef3030e017d007bfef9033e017d007bfefe036f017d007bff0400eb016a0092febb021e0215007bfedc024d0214007bfedc01ef0216007bfedc027d0213007bfedc018e0212007bfede015c020f007bfedb01890181007bfeee015c0181007bfeee02ad0210007bfedc02dc020c007bfedb030c0207007bfedb033c0201007bfedb036b01f8007bfedb010a0203008efee600cf01f7008efee6726f756e64000000726f756e640000003c646566733e3c672069643d22726f756e64222066696c6c3d2223393430304533223e3c7061746820643d224d2d31322d31376832345636682d32347a222f3e3c636972636c652063793d22352e352220723d223132222f3e3c2f673e3c2f646566733e3c706174682066696c6c3d22234641433135432220643d226d332037323820313131382d3133322d372d3232354c38203335327a222f3e3c672066696c6c3d2223443439394634223e3c7061746820643d224d302033333368393976383748307a222f3e3c7061746820643d224d2d3920333133683431763837482d397a6d3130332034376833327632394839347a6d35342d3134683534763434682d35347a6d3732382030683935763936682d39357a6d3132322d3331683434763735682d34347a6d3434203135683434763735682d34347a222f3e3c7061746820643d224d39333320333131683338763432682d33387a6d2d37352d37683534763434682d35347a222f3e3c2f673e3c706174682066696c6c3d22234639423233332220643d224d302033383968313038307636393148307a222f3e3c706174682066696c6c3d22234641433135432220643d224d3130383520313033342d37203930367633313168313039327a6d31332d3237334c2d3230203632396c372d32303820313130362d31397a222f3e3c706174682066696c6c3d22234641433135432220643d226d31373920393732203934322d3138382d34362d33392d393432203138377a222f3e3c706174682066696c6c3d22234434393946342220643d226d373036203738352034203132203130312d31372d342d31327a222f3e3c67207472616e73666f726d3d227472616e736c617465283832302039333529223e3c212d2d666c6f7765722d2d3e3c2f673e3c706174682066696c6c3d22234632384430302220643d226d37383020393133203237392033382d332033312d3238302d33387a222f3e3c706174682066696c6c3d22234644453041442220643d226d32363420383636203236342d353320352032312d3236342035337a222f3e3c706174682066696c6c3d22234639423233332220643d226d2d31393920353630203539382d313232682d3731347a6d313735332034304c39353620343738683731347a222f3e3c212d2d7363656e6562312d2d3e3c212d2d7363656e6562322d2d3e3c672066696c6c3d2223423935394544223e3c7061746820643d226d323936203235332d32302d312036203132366832337a6d2d32332d37332d33352d35763133306833387a222f3e3c7061746820643d226d323532203131372d31362d32763133306832317a222f3e3c2f673e3c672066696c6c3d2223454143434639223e3c7061746820643d224d313739203331386837323176323136483137397a222f3e3c7061746820643d226d313739203534392031333720323820313938203130203234312d3130203134352d3234762d3234483137397a6d35372d3232332039352d32322035303320342036362031307a222f3e3c7061746820643d226d3137392034343420392d3330332034382d323620322036302032312031307636316c32312037763230317a6d323234203368343335563230386c2d3132362d32352d3132392d31302d31383020357a222f3e3c7061746820643d224d3331332032363668313238763639483331337a222f3e3c7061746820643d224d33313320323436683335763331682d33357a222f3e3c2f673e3c706174682066696c6c3d22234239353945442220643d224d34363420333534682d34356c3133203233316834357a6d2d313338203239682d32336c3134203139356832337a6d3132322d3334682d33336c2d372d36316833327a222f3e3c706174682066696c6c3d22233934303045332220643d224d34363820313931683139763337682d31397a6d38332d32683139763337682d31397a6d3834203236683139763337682d31397a6d3335203535683139763337682d31397a6d34322d3437683139763337682d31397a6d3433203136683139763337682d31397a6d2d353634203735683132763634682d31327a6d31332d313538683130763236682d31307a6d30203531683231763539682d32317a222f3e3c212d2d726f756e642d2d3e3c212d2d7363656e656d2d2d3e3c672069643d2274726565223e3c672066696c6c3d2223394242323234223e3c7061746820643d224d2d36342038323868333638762d3631482d36347a222f3e3c656c6c697073652063783d22323035222063793d22373637222072783d223939222072793d223631222f3e3c656c6c697073652063783d223334222063793d22373634222072783d223939222072793d223633222f3e3c656c6c697073652063783d22313232222063793d22363839222072783d22313133222072793d223930222f3e3c2f673e3c706174682066696c6c3d22234141373033352220643d224d3832203839366833356c34342d3730682d33357a222f3e3c706174682066696c6c3d22234141373033352220643d224d31323420383534682d31326c2d31392d32376831327a222f3e3c2f673e3c75736520687265663d22237472656522207472616e73666f726d3d226d6174726978282e363320302030202e3633203331382032363529222f3e3c75736520687265663d22237472656522207472616e73666f726d3d226d6174726978282e393220302030202e39322039323420343629222f3e3c212d2d74726565312d2d3e3c212d2d74726565322d2d3e3c212d2d74726565332d2d3e3c212d2d7363656e65662d2d3e",hex"4b696c696d616e6473636861726f000000000000ffd6ad7302369e550093015e00003c646566733e3c706174682069643d2262757368222066696c6c3d22233942423232342220643d224d2d34302d32306837354c353220322034312031396c2d32362d332d333820342d32392d392d352d31357a222f3e3c2f646566733e3c706174682066696c6c3d22234639423233332220643d224d302036353568313038307634373948307a222f3e3c706174682066696c6c3d22234641433135432220643d226d2d31313420373831203438392d35372d3439352d32327a6d313432302d33302d3439312d3330203439332d31397a4d353237203836386c3730312d36382d3130203136337a6d2d36313620313839203836302d33302d3836302d36397a6d313331332039372d3737362d3636203738302d36387a222f3e3c706174682066696c6c3d22234637413930302220643d226d373334203239302d3232392034332d3133392036392d3338372038332d3133352031373868313634316c2d372d3134362d3535322d3230327a222f3e3c706174682066696c6c3d22234632384430302220643d226d33363120353030203136342d3135352d3131302034392039302d3631203137362d3431203231312031312038332033302d35392031342038352035302d3235312d31332d3230382036312033302d39387a222f3e3c706174682066696c6c3d22234632384430302220643d224d3934362035333820383134203334396c2d36372031347a222f3e3c706174682066696c6c3d22676f6c642220643d226d353932203331382d362032392033342d31312d34302037322037362d37326833326c34352d33382034203437203130352d3120352d3138203439203220322d31312032382d322d38372d33312d323020362d34352d31332d323820382d36392d352d34352031342d34392d342d34362033332d333120392d3120312034392d337a222f3e3c706174682066696c6c3d22234146433235302220643d226d31313533203635382d33392d32332d3238392d32302d3130312032302d3138322d32372d3233302032302d3137362d32332d3139302034377a222f3e3c75736520687265663d22237472656522207472616e73666f726d3d226d6174726978282d2e3620302030202e3620313430332032353029222f3e3c75736520687265663d22236275736822207472616e73666f726d3d226d6174726978282d322e3320302030202d312e3137203235342037393729222f3e3c75736520687265663d22236275736822207472616e73666f726d3d226d617472697828322e383620302030202d322034312039343729222f3e3c75736520687265663d22236275736822207472616e73666f726d3d226d617472697828332e353620302030202d322e383520313036312039383729222f3e3c75736520687265663d22236275736822207472616e73666f726d3d226d617472697828342e393320302030202d312e3136203432332036353229222f3e3c75736520687265663d22236275736822207472616e73666f726d3d226d617472697828322e343420302030202d312e32332038352036363629222f3e3c75736520687265663d22236275736822207472616e73666f726d3d226d617472697828312e353920302030202d312e30322034362036343229222f3e3c75736520687265663d22236275736822207472616e73666f726d3d226d617472697828322e323620302030202d2e393820313031342036353529222f3e3c75736520687265663d22236275736822207472616e73666f726d3d226d617472697828322e3420302030202d2e3931203833312036343729222f3e3c75736520687265663d22237472656522207472616e73666f726d3d226d617472697828322e312030203020322e31202d31323732202d35383429222f3e3c672069643d2274726565223e3c706174682066696c6c3d22234141373033352220643d226d373035203638302d31332d38312d37362d323620332d322037332032342d34302d353720342d312033382035342032382d333920313120322d32382034302034302d3131203220332d34302031322031362038317a222f3e3c672066696c6c3d2223363439363234223e3c7061746820643d224d38363820353133613132342033382030203120302d323438203020313234203338203020312030203234382030222f3e3c7061746820643d224d383330203536346136352032302d38203120302d31323020302036352032302d3820312030203132302030222f3e3c7061746820643d224d37373320353435613130392033322030203120302d323139203020313039203332203020312030203231392030222f3e3c2f673e3c2f673e3c75736520687265663d22236275736822207472616e73666f726d3d226d617472697828332e363620302030202d312e31203736342036373329222f3e3c67207472616e73666f726d3d226d617472697828312e332030203020312e33203339352039383529223e3c212d2d666c6f7765722d2d3e3c2f673e",hex"4b796f746f00000000000000000000000000000002158e3f0817b8590055015e037363656e65310000001902e4042b009e010000967363656e6532000001570337019f00da010200c87363656e65330000009c02850322001b010000320200011e03c5025300fc038e01d100f10426019500b7031401c100b7028201e500b70079025300fc008401d700f10015016b00b7010501b800b7018701ed00b76461726b000000006461726b00000000000118000701c100fc009a01dc00a70106022300a7018e021a006f03b001d700d3044201f700a70338022300a702af021a006f627269676874000062726967687400003c646566733e3c636972636c652069643d22627269676874222063783d2230222063793d22302220723d223536222066696c6c3d2223394242323234222f3e3c636972636c652069643d226461726b222063783d2230222063793d22302220723d223536222066696c6c3d2223363439363234222f3e3c2f646566733e3c212d2d6461726b2d2d3e3c212d2d6272696768742d2d3e3c672069643d224562656e655f36223e3c706174682066696c6c3d22234639423233332220643d224d2d363320363636683132313276343339482d36337a222f3e3c706174682066696c6c3d22234646453736362220643d224d2d3231203636396831313237763436482d32317a222f3e3c706174682066696c6c3d22234646453736362220643d224d36333120373034483435346c2d31333720333831683435317a222f3e3c2f673e3c706174682066696c6c3d22234539344531422220643d224d3430392034343968323638763931483430397a6d2d32343020393868373438763935483136397a222f3e3c706174682066696c6c3d22233934303045332220643d224d39343820353733483133376c33332d3333683734357a6d2d343335203130683630763532682d36307a222f3e3c706174682066696c6c3d22234339383046312220643d224d2d3231203633356831313237763530482d32317a222f3e3c706174682066696c6c3d22234446423246372220643d224d36333520363335483435316c2d3333203530683234397a222f3e3c706174682066696c6c3d22233942423232342220643d224d35323420343739683338763437682d33387a6d383720313034683338763532682d33387a6d2d3137342030683338763532682d33387a222f3e3c706174682066696c6c3d22234246363645452220643d224d35393720353134683338763237682d33387a6d2d3134362030683338763237682d33387a222f3e3c706174682066696c6c3d22234245313632322220643d224d34303020343438683138763331682d31387a6d38392030683138763331682d31387a4d31383220353733683138763331682d31387a6d3132392030683138763331682d31387a6d38392030683138763331682d31387a6d38392030683138763331682d31387a6d38392d313235683138763331682d31387a6d38392030683138763331682d31387a6d32313820313235683138763331682d31387a6d2d3132382030683138763331682d31387a6d2d39302030683138763331682d31387a6d2d38392030683138763331682d31387a222f3e3c706174682066696c6c3d22233934303045332220643d224d37323820343439483335386c35312d3332683236377a6d2d36322d313030483431396c2d3130203638683236377a222f3e3c212d2d7363656e65332d2d3e3c672069643d226c656674223e3c706174682066696c6c3d22234339383046312220643d224d33363920363932683335763131682d33357a222f3e3c706174682066696c6c3d22234539344531422220643d224d333832203636366839763235682d397a222f3e3c706174682066696c6c3d22234245313632322220643d224d33373520363431683234763235682d32347a222f3e3c706174682066696c6c3d22233942423232342220643d224d34303620363431682d33396c31392d31357a222f3e3c2f673e3c75736520687265663d22236c65667422207472616e73666f726d3d227472616e736c6174652833313329222f3e3c212d2d7363656e65312d2d3e3c672069643d224562656e655f34223e3c706174682066696c6c3d22234245313632322220643d226d393739203230302d3433362034302d3433372d3430762d33326c343337203430203433362d34307631367a6d2d38343420373668383136763437483133357a222f3e3c706174682066696c6c3d22234245313632322220643d224d3531362032313268353576313030682d35357a6d323837203568373176373835682d37317a6d2d353931203068373176373835682d37317a222f3e3c706174682066696c6c3d22233934303045332220643d224d3139372039323468313030763832483139377a6d302d37313768313030763230483139377a6d33343620312d3433372d34302d32372d333420343634203434203436332d34342d32372033347a6d3234352037313668313030763832483738387a6d302d37313768313030763230483738387a222f3e3c2f673e3c67207472616e73666f726d3d226d617472697828312e352030203020312e3520393635203130303029223e3c212d2d666c6f7765722d2d3e3c2f673e3c212d2d7363656e65322d2d3e",hex"4d61636875506963636875000000000000000000ff372db0fbad0679008e015e000200011202de0338005102ac03b2002f039f035a005900cb0410006f041b037b00d7020303c3006f62757368310000006275736831000000000115035903b6006401ce03e4003c0119043c003c027903a700460363044200500401039f004b024d0426004b70616c6d3200000070616c6d320000003c646566733e3c706174682069643d2267617264656e222066696c6c3d22234144433034422220643d226d2d39362033342d372d37203235372d36312d3330382036307a222f3e3c2f646566733e3c706174682066696c6c3d22234542434646412220643d224d3020343531683435397633383948307a222f3e3c672069643d224562656e655f3234223e3c706174682066696c6c3d22234239433936362220643d224d35363820333337483333356c2d34342d32352d373220342d35392d33312d313138203238203230362032313720333020327a222f3e3c706174682066696c6c3d22234146433135302220643d226d37363220353733203232302d3235302d31362d31382d36302d322d32322d31342d3131392d342d32302d31362d3732203436682d32377a222f3e3c706174682066696c6c3d22233942423232342220643d226d37353220353437203337362032322d33392d3239322d35372d382d36302032387a4d36333720323839483436396c2d38312033352d31313020313935203437342032387a4d3432203236366c2d37382d3239203232203339376834326c34342d35326832396c32332d32302d31362d33386836366c2d31302d376838347a222f3e3c2f673e3c706174682066696c6c3d22234144433034422220643d226d313632203731312d36312d38352038312d3837203131382d377a6d2d39332d36382d31312033342d3934203135382039203834203137322d37332d382d3132392d33362d34362d31342d32397a222f3e3c706174682066696c6c3d22233942423232342220643d226d323031203534372032362d31302031382d32382034322d31302033332d33352032372d342031382d32312d39203134392d3133392036362d34362d33367a222f3e3c706174682066696c6c3d22234234344345422220643d226d373138203335312032332031372034352d33203735203435203434203730203338203139203335203132332d3239342d3136372031362d39347a6d2d3238382036302038342d34302036332d39362033382d32322031372032203331203232387a4d313139203734396c3139312d3233372031372d362037302d313236203134203236387a222f3e3c706174682066696c6c3d22234434393946342220643d226d363633203239392d33372d35322d313120362031322032382d32332039382d3231203320362031322d3330203738203239342039372d33372d35382d32352d3135682d31396c2d31302d35332d31302d342d31312d37312d32332d313720392038322d31332033392d31332d3133337a4d333930203532356c2d33382d32302032312d31372032352d3130382034372d31352031382033372032332d31342031312031352033302d31376831366c3230203133397a6d3533372031392d32312d37392d34332d3533203334203135327a222f3e3c672069643d224562656e655f3230223e3c706174682066696c6c3d22233942423232342220643d226d2d313820383833203139332d3232302039332d35302031372d32302031362d32312034352d32372031362d33342037322d31382034322d343220393320332031312031326839366c333536203138354c313720313338307a222f3e3c75736520687265663d2223627573683122207472616e73666f726d3d22726f74617465282d32362031353239202d3339297363616c65282e383129222f3e3c75736520687265663d222367617264656e22207472616e73666f726d3d226d6174726978283120302030202d31203335312037303229222f3e3c75736520687265663d222367617264656e22207472616e73666f726d3d226d6174726978283120302030202d312e3334203239332037383129222f3e3c75736520687265663d222367617264656e22207472616e73666f726d3d226d6174726978283120302030202d312e3637203233352038353929222f3e3c75736520687265663d222367617264656e22207472616e73666f726d3d226d6174726978283120302030202d322e3031203137372039333829222f3e3c75736520687265663d222367617264656e22207472616e73666f726d3d226d6174726978283120302030202d322e333420313138203130313629222f3e3c2f673e3c706174682066696c6c3d22234641433135432220643d226d323935203632392037332033302031372d31362d37322d33317a6d3232312033392d38352d33362d31332d31357632326c31332031342038352033377a6d3238312d38312d3130382d34312d34342036203131372035307a6d2d3332332d32312033332d3233683131366c2d33302032347a6d3138302d38312d31332d3131682d34386c31322031327a6d3138302037392d32342d31342d373220332032322031357a6d2d3339322034342032312d313820363320332d35302033367a222f3e3c706174682066696c6c3d22234646454238302220643d226d363631203530302033322d392038312033342d32392031317a4d323734203634306c2d33322d31332032362d32342033322031317a222f3e3c706174682066696c6c3d22234646454238302220643d226d323734203634302d33322d31332d322031352033332031327a6d38322d35322035352032342031332d31332d35352d32357a6d3136372d31303020353220312035302032312d343720367a222f3e3c706174682066696c6c3d22234639423233332220643d226d343237203532392037302d3820372d33362d32302d372d382d32372d35372035307a6d32353220332d31382d31352d333720312d31302031347a6d2d3239352034312034372032312031312d31322d34372d32327a6d2d35362033342036342032372031352d31352d36342d32387a222f3e3c706174682066696c6c3d22233634393632342220643d226d3133362031303632203338372d343438203130382d343168313731762d31336c3135392d32302031342d313820343420372031382d3236683438763533367a222f3e3c212d2d62757368312d2d3e3c212d2d70616c6d322d2d3e3c75736520687265663d2223627573683222207472616e73666f726d3d226d617472697828312e332030203020312e3320343034203130313029222f3e3c75736520687265663d2223627573683222207472616e73666f726d3d226d617472697828312e332030203020312e33203737342039333029222f3e3c706174682066696c6c3d22234641433135432220643d226d393735203532322035352033332d362d33337a4d383030203635306c31353820382d3133342d33367a222f3e3c706174682066696c6c3d22234639423233332220643d226d3130303720363530203833203132322031332d39332d35382d34337a6d33302d3134372035392033372d31312d35377a4d353233203631346c313238203131332d38382d313035762d366c3130302036332d36382d3638762d31396c3836203439203132312d3237762d3431483633317a6d2d35383620343639203435352d3839203135332031392037322d3538203530332d373876323739482d35327a222f3e3c706174682066696c6c3d22234646454238302220643d226d38303220353630203136382035362d392d3736483831377a222f3e3c67207472616e73666f726d3d226d617472697828312e332030203020312e33203735302039373529223e3c212d2d666c6f7765722d2d3e3c2f673e",hex"4368696368656e2049747a610000000000000000013b9b6dfab88fa600e1015e00003c706174682066696c6c3d22234639423233332220643d224d302033303868313038307637373148307a222f3e3c706174682066696c6c3d22234641433135432220643d224d31303839203932392d33203830305633303868313039327a222f3e3c672066696c6c3d2223394242323234223e3c7061746820643d226d343535203331322d3436352d34342d3436362034347a6d3130353320302d3431392d34342d3432302034347a222f3e3c7061746820643d226d383631203331322d3438382d32372d3438372032377a222f3e3c7061746820643d226d31333135203331322d3436322d33332d3436332033337a222f3e3c2f673e3c656c6c697073652063783d22323137222063793d22383235222066696c6c3d2223454243464641222072783d22313638222072793d223134222f3e3c706174682066696c6c3d22234632384430302220643d224d34323220323639683334763534682d33347a6d34322d3534683334763534682d33347a6d2d31392d3138683332763138682d33327a6d2d363720313237683434763534682d34347a6d2d3432203534683532763534682d35327a6d2d3431203534683539763534682d35397a6d2d3432203534683636763534682d36367a6d2d3431203534683734763534682d37347a6d2d3432203534683831763534682d38317a6d2d3432203534683839763534682d38397a222f3e3c706174682066696c6c3d22676f6c642220643d224d3439342032313268313530763537483439347a6d2d343020353768323330763534483435347a6d2d333420353568323938763534483432307a6d2d333420353468333637763534483338367a6d2d333520353468343335763534483335317a6d2d333420353468353033763534483331377a6d2d333420353468353732763534483238337a6d2d333420353468363430763534483234397a6d2d333420353468373038763534483231357a222f3e3c706174682066696c6c3d22233934303045332220643d224d35343120323237683537763432682d35377a222f3e3c70617468207374726f6b653d222346394232333322207374726f6b652d6461736861727261793d2231322e392031332e3322207374726f6b652d77696474683d2236372220643d224d3537352032373076343337222f3e3c706174682066696c6c3d22234632384430302220643d224d3437342031393768313839763138483437347a222f3e3c706174682066696c6c3d22234644453041442220643d224d3533302032363968313276343333682d31327a222f3e3c672069643d2274726565223e3c706174682066696c6c3d22234141373033352220643d224d39383420393138683738763533683138762d3835682d36306c34352d3435682d31396c2d3330203330762d3330682d33327a222f3e3c672066696c6c3d2223394242323234223e3c636972636c652063783d22383735222063793d223738352220723d223539222f3e3c636972636c652063783d22393731222063793d223639382220723d223539222f3e3c636972636c652063783d2231303636222063793d223738352220723d223539222f3e3c636972636c652063783d2231303234222063793d223732372220723d223539222f3e3c636972636c652063783d22393731222063793d223738312220723d223739222f3e3c636972636c652063783d22393038222063793d223736332220723d223732222f3e3c2f673e3c2f673e3c75736520687265663d22237472656522207472616e73666f726d3d226d6174726978282d31203020302031203130313020383629222f3e3c75736520687265663d2223627573683222207472616e73666f726d3d227472616e736c617465283331372038343729222f3e3c75736520687265663d2223627573683222207472616e73666f726d3d226d6174726978282e3620302030202e36203937302035363829222f3e3c75736520687265663d2223627573683222207472616e73666f726d3d226d6174726978282e3420302030202e34203131382034333229222f3e3c75736520687265663d2223627573683222207472616e73666f726d3d226d6174726978282e3220302030202e32203932332033373429222f3e3c75736520687265663d2223627573683222207472616e73666f726d3d226d617472697828312e312030203020312e3120373637203130383029222f3e3c67207472616e73666f726d3d227472616e736c61746528393335203130353529223e3c212d2d666c6f7765722d2d3e3c2f673e",hex"506574726100000000000000000000000000000001ceecfb021c9e1a006c00fa027363656e653100000124036102fa00b402000100647363656e653200000124036102fa00b4010200c8003c706174682069643d224562656e655f32222066696c6c3d22234639423233332220643d224d302033373468313038307637303648307a222f3e3c672069643d224562656e655f33223e3c706174682066696c6c3d22234641433135432220643d226d33363720343634203438362d37342d3439342d357a222f3e3c706174682066696c6c3d22234644453041442220643d226d31313535203338312d3339322d33372d3339322033377a222f3e3c706174682069643d22707972616d69645f32222066696c6c3d22234633393230302220643d226d383536203339332d3338302d36392d333236203130347a222f3e3c706174682066696c6c3d22234544384130302220643d226d31303332203335312d3231352039322034353020313436563337317a222f3e3c706174682066696c6c3d22234641433135432220643d226d35353620353733203932312d3138332d3135203332367a222f3e3c706174682066696c6c3d22234635413833332220643d224d3438352035303620323638203632306c313232332039387a222f3e3c706174682066696c6c3d22234632384430302220643d226d37323420373135203137352d31303920323937203130357a222f3e3c706174682066696c6c3d22234632384430302220643d226d393434203730382037332d3836203132332038337a222f3e3c706174682066696c6c3d22234632384430302220643d224d38393220373238762d33306c32352d323220353720333020322032357a222f3e3c706174682066696c6c3d22676f6c642220643d226d393736203733312036332d31762d32326c2d38352d33352d333720332035372033307a6d34312d3130392034332038342038302d317a6d2d38382d31323320313531203939563436397a4d313136203131396834366c363537203634322d313436382037387a222f3e3c706174682066696c6c3d22676f6c642220643d224d383933203733332034363420323936203335203733337a222f3e3c706174682066696c6c3d22676f6c642220643d226d373333203538392034322d313320333820313620382033322039372038372d32352032327a6d323133203136382d32332d33322d32342033327a222f3e3c706174682066696c6c3d22234637413930302220643d226d39363720373831203139382d31392d3239203930682d37367a222f3e3c706174682066696c6c3d22234632384430302220643d224d313136203131396834366c38203130362d353133203531322d35322d3133377a6d3636362036333220312d34322d32392d33372031342d35322d33352d33312d333720323520333120333820372035387a6d2d323539203239203137392d382d312d34352d34382d34382031372d37372d33372d36352d32342d322d31392d3431682d36377a6d34343420312d313136203433203231352032387a222f3e3c2f673e3c672069643d224562656e655f38223e3c706174682066696c6c3d22234239353945442220643d226d353239203433352d38382d35362d3237342d392031323520343230203234302d31307a222f3e3c706174682066696c6c3d22234434393946342220643d226d353235203432392d38342d35307635317a4d323633203538326c3739203420372d3134342d37392d347a6d32313020323468353076313632682d35307a6d2d34332d31353568353076313335682d35307a6d2d3138302d3233203130342d35307635337a222f3e3c706174682066696c6c3d22233934303045332220643d224d33363020363735683233763539682d32337a6d38362d313835683137763632682d31377a6d333420313934683233763533682d32337a4d32373820343930683237763930682d32377a222f3e3c706174682066696c6c3d22234541434346392220643d226d333330203539362d33352d3120362d313020342d31343920323320312d34203134397a6d3136372d3138306834326c2d3720313076313536682d32366c2d312d3135367a6d34203137336834366c2d3720313276313832682d32396c2d322d3138327a4d333633203433326834306c2d3620313076313532682d32356c2d312d3135327a6d2d3135372d32346834306c2d3620313176313533682d32356c2d312d3135337a6d323234203138366833366c2d3620313276313830682d32326c2d312d3138307a6d2d353620386833366c2d3620313276313736682d32326c2d312d3137367a6d33372d3136366833386c2d3620313076313432682d32346c2d312d3134327a6d2d38372031363520333620332d362031302d38203136382d32322d3120362d3136387a222f3e3c2f673e3c672069643d224562656e655f36223e3c706174682066696c6c3d22234637413930302220643d226d3132353620313038312d3131333820353220313132332d3232397a222f3e3c706174682066696c6c3d22234632384430302220643d226d2d353120393036203631352d37392d3237312d36342d35372d3234322d38372d3238682d34326c2d33312d3137682d39377a222f3e3c706174682066696c6c3d22676f6c642220643d224d3533203637316834346c2d3236203933203439332036332d3237312d36342d35372d3234324839326c31372033387a222f3e3c75736520687265663d2223627573683122207472616e73666f726d3d227472616e736c6174652831363020373635297363616c6528312e313129222f3e3c2f673e3c212d2d7363656e65312d2d3e3c212d2d7363656e65322d2d3e3c67207472616e73666f726d3d226d617472697828312e332030203020312e3320373130203130343529223e3c212d2d666c6f7765722d2d3e3c2f673e"];
                return bytes(motifs[index]);
            }
        }