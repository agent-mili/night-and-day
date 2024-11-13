// SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;
    import "../BasicMotif.sol";
    import "../NDUtils.sol";
    import "@openzeppelin/contracts/utils/Strings.sol";

    import "@openzeppelin/contracts/utils/Strings.sol";
    contract GenericMotifs {

        using Strings for uint256;
        using Strings for int256;

        function getGeneric(uint index) public pure returns (bytes memory, uint, uint) {
            bytes memory startIndices = hex"000000190032004d0062007a009900b100d100ed010a01210142015b017a019601b701ce01e801fe0213023302550271028f02a602c102da02f40312032c03450358036c0388039b03b503cc03e503fc0411042e0443045d0476049404ac04c204da04ef050505170529053e05580576058d05a105b805d205ea05fc06110627063e0654066c0684069c06b406c806dd06f8070e0723073c0753076c0782079c07b607d007e80802081b0834084b08610880089e08b808cd08e408fb0915092f094909610979099109a909b909c809e309f30a030a150a280a380a460a580a680a7b0a960aa90abf0ada0ae80af80b090b1d0b2f0b3f0b550b6b0b7c0b8b0ba00bb70bc70bd60be70bf60c050c150c290c400c510c620c770c8e0c9d0cb70cc80cd80ce80cfa0d090d1f0d310d420d540d640d740d840d940da40db70dc80dd90de90df80e090e1c0e2e0e400e4f0e5e0e6e0e810e970ea90eba0eca0eda0eed0eff0f110f280f390f490f610f7b0f8c0f9b0fab0fbe0fd00fe10ff01003101610271037104b105c106a1079108d109d10ad10be10d610ed110211161128113d114e1167117b119e11b611c811d911e811f9120a121a1232124312591271128a129b12b112c312dc12f8131013221334134e136213741385139513a913c013cf13e113f4140714171428143a144a1465148a149d14b314c714e71500151115241534154f156115701586159715af15c115d115e315f6160d161d162c16401651166416761687169c16b116c016d416e616f6171b172d17401752176217721784179417b517cb17e117f11801181b1831184b1859186b18831895";
            bytes memory motifs = hex"1f0120f1cef6b90734009a506170616b6f6c6561204265616368ffed4db1fa9c1a1f10000850756e746120436f726d6f72616e7403c77458fedd512100be5265796e056973666a6172a0331f009b8c75fae2551200e5506c617961204e65677261fdcb34be0a664504010e4b036172656b2003806013013d35eff6b3939f005a426c61636b2053616e6480191f204d61756900d3937dfc5c05f20100416e7365204368617374616e657402502216da00e885e601655370696167676961206469204669636f206b0c6e646501b3c717ff06c64b011e808315646520656c204172656e616cfebb8f55034c4bb5010e201b016765401b004520540067207b116c65022aad5b0184aab20079506572697373a0d30903a48766f72ba0e80102e008a618416c61736b6103cd61d2ff010e6600a85376696e6166656c6c811307fef50d90f716dee7e0026d16506f696e74652056656e75730062113205f2be0f01285021551a616920506173697220486974616d01851a05fb6eb2db005650696ee1041a10426168616d61730275df37008ec3e7007ae1000512526f7361021a312901673665009e456c61666f219d017369815309ff7cc082071fbcb500d2a06d0f4d6572616800c7fb8efc74f453008743213cc1980bec2115fc22e7260096486f72217a0253686f201901617920480f726d7564610068ccdf07465c0700fe472034215f21b942200672757a2049736c201209010ce41afc503f33011960be624f2041017262203d09ffbd43130353e28d010e61d704536f75726321891727417267656e74fdfa1b72011860690142436c6966746f6e803c0dffbeec3c025c3c56005a4469616ea19917204b656e796101a9faff020c3e2000b4536861726d20456c20b00e65696b68fecbcbf80371ae23001442219200612254007220c642da0c00fd2679fea251310073507261423f208660c220220b696101c161ddff65ac1700f7e20024184c61677a69726100cc1783feffb52800fe42616c6420436170a0501fff6c52c400c96958015f4361626f204c65646ffea182b8fd6d22a90091436f70036163616220b60cfeca53b608e269dc00035768692206044865617665a0e109014cc8cefbb2d4b0012221542110216f0c01a007c5fb1454a100d253696522fc20ef4183239b09014975f5fb23a6a0009b20a22367005023810c69736fff039e02f6f4a7f3010b201682de024d617420b80e01466c61f69975ea00474c616e696b226b80460d33b056fac996a1006f54756c756d80140900b6633c07447de400f480a4602901204223fa11636179fde80c9108fb8d25000b4879616d73801c0c00bfcbf4fbd327a1012750616ca04523700c756261ffc5311bfe10f5aa0130a168006f41680c63686f01914d8c079ff0da006be00264032c204f6b2340127761003c31e20461605901274d616166757368a0af0d0050310b045c6698006552656574e0001508cdea8afaab46a3009620f5210c2200015a6f23650d02f1533cfff2ae9300204f6d6168a2330b00c6f9c604c900bc0066476822a8c0580975238205e30d79013c4d4041417b1b79d2fb086c4c77009649776f204a696d61ff7af7fd06dd5569010450422b0f69204b7574610235f152ff7fa40e00b4a0e082430a6e6861024f6d480015e6e363fc209522631673657320496c6c6574657302a86d21ffed70da0128447523761264752050696c61740294069a00fdd12f00b45a200d166e69205261740382a2850055609100ce536f6c617273746373146e02fb9823ffa9ca14008a506f7274686375726e6f818e0c026169c8003c135f00b743616c408f006322f823000c022db42601bc3d4800b24f6c7520410c697a0215e0c4020659ee00b44ee401280e02bc3170f89c6aa9010e43616e6e6fc29e0df54242f9028e9900334c61204a6f204e261010766502db31bbf892294801075269616c74a08109010374f50339fbc100a5239218746920616c204861666661017fc6bf035bf00a006046756a612297225762ce0c8073f7034ac3a8010e4a756d65e0011709fdeb9d86fcbc100f00928682006425c8104573746500c03fdcfb2185c6009643617922521075637265ffc17269fb2b3ed0012f4c61732567006325460073210209c3058b345e006e56696a24c0044e6167617280730e00acd838071e5869010e4e61637061a0e609feedc99d07487b20014023c8006ca2fc0aff2c03bafb73baa400be5061ca02526f6a23720c657275fe626c89fbc6cf0700ff2595244710496e676c657361ffe437b3fb2fbe8f00f5802f004d228d2376222d0c02088cff87a2b600804d797274c05e0a03135593ff78e0be009949231a0361646f6ec3e60d03733874ff95e53700d54c75736b251d0079e400c108d452ddfa92704e00b8806222f3240324760a6e0148c223facb115a01388019194d6f73717569746f005afbb704cf802900a4486972696b6574692294617d09025ee2070131220b00fa2031007a2355114b73616d696c6974011622d4fbe8928a00552018202d01477524c31262616e6f025f8cd7079c0b77009048616d6875273f60480dffa763140258918a004c4d75797522bd6015090048dde306d4a41a0148a3370053275d24ca41131267616e02244d8100dae07200ff49722d52616d22580074222f144d697871757161fff9e7f5fa97e97b000852616269235d015265a8230cff80d10606e4ca6e001841686dc0140e0019ec7d0070ef74010e496c68657524b5248e096f6d003d13b0008c8bc62063e003160afe71b11401f6e350005a4d2553208d01756ca2c009fe9bf5b400dd47f10111261704647769636822c001726226aa0c0249d41bfb86a9b600654f6365223502436974c59308733635f96c7aed00fd812d2622203b263408f1c749fa3717ed00ea8017135a69636174656c61019d4b670879e96c00e8536125910175722032430c09ff5624150914a64e005a212f28112256007340490c03121456fffec33200d14c6f6e21e80902ea15fc002228f000a521f90c697302fca30c00845c4800b4462420076b6675727420616d25ff0e696e02d312dc0081f491007e5a757220cb1a02693d8bffc7abb800b44d6164726964031cfe40014087b800a057245f007a25801d03181a6000445f25009a526f7474657264616d02b5f38c008bb82e00c94d24a922030adff9ce00fa761600b45769248d0a72d6f201baa66700a9497322eb0c62756c0352ab7f023cb94a006322811f6b7661038a67ca0111cffa009253746f636b686f6c6d0308164e0042829e00c7034272757824a20265732f2009107373656cfe9883c5fd380913002c53616f22da21991ffdefda01fc857b8e000a4275656e6f73204169726573fe020d6cfbcaad26015621a900742a0f006f24252a2c0d696c65ff4792e9fb69127101364c25be1a00465693fb95ccf1015d426f676f746100a0326dfc032bc8011943273c0c636173fdeb83d3fca691ce016243af1f65766964656ffe7e25d5fc906faf003e4173756e63696f6eff0441cbfbf0614f446620970a7a00d12e75faae42630067207f26dc016c7623c00c72fe70205c01abfdd401604a6f2258116e657362757267ffec28880231b4bf00214e24fc0d6f626900626b030033c25c00794c20b80e730089829f024f5e2501104164646920e001626527420997e3de02575eef001c4424ba264120630d61616dff798c6100c9e9c3015f4c23950e64610054ca21fffceb120084416363227409513f76ffc2ab7e002d4123360d6a616e01ca5efc01dc94ea01454b407b0a02319819009b6a6a00a55423a81d73023098f600301e620095416c67696572020023eeff8b138c0092436173250827b31261026df430fb97333b00d04e657720596f726b62fc0c029a121bfb44bdda00a3546f7224e80a6f027f0f03fac6d4d600b22185006320d70a020798e8f8f38f5500b44c41b5026e676521e8090240b4c5f8b4483100ab413742b210636973636f018919c7fb38581d00584d6924840b01286640fa16c55900f343692a3a006441db034d65786920280181cb2311077ef5005761642d4421641f01807a68034b6b14001e4475626179790167fcea037b929400744d61737161740a01795d5002c8212800996124670b697961640146d6e6025fa8fa206b0e616b6b6101e49f020219401800645925da01736821661179696d0174fcbb033da3780033416275205a24840d01fc528c02a4fe5a00ac4261676820940a01ff56c60229e896006044226710736368710220fe52030f404e00be546568238d0b0260ed5a01f55c660155416e2cff0a61017c5c6c03fee01b007f2d110d61636901e0a5b3046e178d00a64c28a81f75720123c7bf0457752500914d756d62616901b38c1f04977345003c4e65752d1344656c6869015798a1054386d7002b4b6f6c6b6122cf09d1b62d05fdfa3f01154224c90d6b6f6b0140c7c1064eef6e00c6482d880d6f69016b0c8b05631f140092446824701f0260bcaa06eff41600874265696a696e6701c234ab06594b7c001f43686f6e67007140120857e12906cc454800962b51016e7a20030901dc28d5073d159f004e27d91f6e67686169022079800853c00300d4546f6b796f023c63ef07936f7b00c15365006f2405090c6bc70441ee4100dc4144171061025ccba703fdf24b014c53616d61727122ba0b003010fe060f7c0300ac4b75217311204c756d7075720013ffb1063027c2009c532088006120110affa189b9065f632601414a20be007220f109df108a0735f43e00e74d275d1e6c61fdfa7d33090263a100255379646e6579fdbe518208a2b48d00364d656c45bb0b6e65fde4f33608e3f639014c28db026265722e9c0ccceaf70a6ca0f300134175636b22e80a64011a144bfbd4ea5f0097229928d102446f6d20811f6f00917659ff2f351300d9436f6e61726b79ffe222a601cb16b801394b696761126c69021ebcf902b58f6700d561732d53756c61220c006e226709008962dcfb426e4f00b6e201c345d924920949ac4601e1b22e00064422350c756261fe184c7106e8204a0123285d0b7468ff14359f01af58a4001b27fe20f30a03c7d71b009fc99500df54236900642ce40e6dff7b391806dd8b75002244656e7023ab1d720069b4d304c28acb00fb436f6c6f6d626f01d2b4c706cfbaa30046577521b30a03a5a5f2f711080000dd41286d2bd51c676501bf608402dbfff60055616c2d4b7577616974030acc86f9339f7420b401616c29330a79ffd034f5fc6c1080002b216c0e6175730109f5eb04ad3b2000a748612797007228171f640025d4080557b93a009a5468696d7068750301e19e01d304c000f74b7969761d024ab552019dafd70078497a6d69720113f3b1ff0c65cb010c4e6f75616b208b0d747401f437f9fa3afb49010044612a620b7301ce24c503668099004d4b2e7a234806028d97f953b3312ec42e930d6e6978016ba42501f6f8f800ef4220dc036972617429e32f450cfe96ba6107fb2bff00de416c692d4d0153702b9411677300433daa005f0eb800b04e6967657220234a0c746100ff857dffd1f343001454412f127563746f750230362904e837b000b658696e6a2e720a6701f774a5f9a9d67f00a28cb1221c1a6473ff08f9fb0200d8bc00225a616d62657a69023b5baaf969308529e1016f6e2acb036e74205620c90e65790271fb82061e671900b94e656924c30d6e67677500ec959501eeb53a00522177024e696c2b2725ae2499022c204b2eca20860b6dfea4116800e19844011b4e250e13622d4e61756b6c75667400605eaeff5b4b0e00f820670e726f766961fe079ba1fbe734f40148205c0d646f7a6100ea29e002a1a7b8005820aa0e6161024435d8037b94d600d241736721ad0d740192f2d7045c37e100dd4a6f6421ac0d7201676dd2037a01c500304d757328a30a01b68a790221b9fb00fc4d30b4006125430f20546162756b02387becffc71a5200bc2ea9106e6164610137ecf902f9592200b552756220c440bd0c6c69fe8fa9df081e283c000053220c02736f6e216d007322d60bff2cd18efb718c7a0145497323ee209c01204721220d616efe9d8e0bfbce6eb9015441742790106d610229bbbbf908a03400e34465617468a1490cfe7f8b490143e67000004b616c252e09726902a8ce5c066768c52d350a616769696e2075732c2047275f0d01a04ead01ae66bf00b3656c2d73402b0061320b022d626522b109022956fcf952945200cc4327007227b50f205269766572017fed0c035bbcdb008dcca30f001fadcb02b3082c00854d75716469732ebd0a0336ae014d513200c347754241022064272eef0063239003012e8cd62dd3046f0115456d2ae4006f28cc0d69ffbddee400e80c0000644b696e26570c736100f4f6dd06735c59005644259a225c0d020f61b00247c464005d5461646d218a0754907605795fbc0148c90174742744116e6704c0b3bd00b01405003159747265204e319a0f6b6f796104eac61bfc48b0b7015d416c215d09043dfdf701897844000420200e646b61707003d23601feb53c11011733ae156b6a6176696b043fa25af6a7ce04015255747169616740121c0b29a90136d5ea01214b6972756e61fcbb75c2fbed6d8a013f5573687531241b03c83cc308829b81001a4f796d79616b6f6e00cc2390ff045a51013b26710d6a756c01f9598b057c8513003951236b012d5a20d7042067616f79289f0a0256854a0452e8fd00b454223201736125ad01692c250524062ca00075225d2119090227c832048278a4004a47150f6b6f72756d02c631600079d53c00874a2c6513667261756a6f636801abdb0e052f7e6900e95361249b0e6d61746861fc0c79350602883c00b228c1006151b1046b652c20412059117263746963610493c43e0401732b0143536521e5046e7979206f2f4a0c6f76029cc42b00a84717006c462a4f0c6e7a650294e45300539d9c0101320d0273656923bd0b030a254c00aced9900d6576525d50b7202376b36faacfe3d00bd4d4f3721e30170702fab423e0a036a47e5ffbb6b2400644c20a900202f570b0365eace0294715100c7566f209a0702b94b950186d8e4a10a02696c7626250261ffbc278d06424a2500004c6126fe0c6e67fdcd7aec08a5e72b00294727462a3d006ea05f0b1005e50066783700744475696a550a02fbc4fd012f8fed006d4b41350d7702d52ad70122a88a005242756432a111737402bf39d000dddf9f00dd4c6a75626c6a23b40902412761f8b25068007f437fe9007e0a02602b79ffc2b99e01115436081d646f0230d55f0852410d00bc4e696b6b6f017e2d9f073df47f006c5461692345336808690199451f05f96aad2a88284621f30b016028bcfb16b1a800134c612d352e2f0a610113aa5f049456c2009f230101677333d51a031f4920063624cc00b249726b7574736b03571a2f058a960d00c120c503736e6f79217b126b0347d1d204f075e600b14e6f766f736962694014080ce102f91c6d1b004a22760f666602d63094fcdaedf9007453742e202b6e0c6e277302b8db21fb9ece9900df251d232c0e616c03d1739af7afed9a0059446177248b1503c19885f850570b00a24e616174732769686368276f21af30ae006f3628229b0d726bfed676b6fd776a81014249702017126e6761002b1663fc628a610118426f6120566928d30aff0d7113fd2190fa00474220b82f360b61ff4982a7010db698014b4322fa0e7a6102972f9c02835c85007a456c622a590a0207a90c046e5010004353269442c11e010314a900796045006741676164657a00849753078ddb39012e5269622049275c05696d2c205469377f012d4c21d00e6501207b1dfa2275c40126506f706f25ab13657065746cfcd5aa960460d41e00424865617264ae370900d9a9160267423300e047531d6f6c00c12afd0338701900d2486164696275fdca5ce0ff44ce5e000c547240d0016e202f6601437532c20afd6938be0a39ceaa002e52287d2e8862e10c007c4df0fb5c3b5400ae54617025d551942c9a2e041703d44a15fceca7f500dd4e75756b01c3f369021b89f000862ba2231d0b756d01a4daa2055b4743013a31ce0361205473222d152043687502b7d22503c6aac301314261696b6f6e7572";
            uint startIndex = uint(uint8(startIndices[index * 2])) << 8 | uint(uint8(startIndices[index * 2 + 1]));
            uint endIndex = uint(uint8(startIndices[(index + 1) * 2])) << 8 | uint(uint8(startIndices[(index + 1) * 2 + 1]));


            return (motifs, startIndex, endIndex);
        }

        function getFlowerType(uint index) public pure returns (FlowerType) {

            uint8[] memory flowerWeightings =  bytesToInt8Array(hex"2820100c");
            return FlowerType(getWeightIndex("Flower", index, flowerWeightings));
        }
       

 


        function getBeachTraits(uint index) public pure returns (BeachTraits memory) {

            uint beachIndex = index - 21;

            uint8 [] memory shortColorWeightings = bytesToInt8Array(hex"212121");
            uint8 [] memory shortPatternWeightings = bytesToInt8Array(hex"1e1e140310");
            uint8 [] memory towelColorWeightings = bytesToInt8Array(hex"18161c19");
            uint8 [] memory towelPatternWeightins = bytesToInt8Array(hex"154e");
            BeachTraits memory beachTraits;
            uint256[2] memory beachColorIndexes = [25970159286877075534151789485724632988018602343906580859550974201160956191881,20175262148451];             
            bytes6[7] memory beachColors = [bytes6("ffa0e7"),bytes6("9bb224"),bytes6("4b3d66"),bytes6("ffd700"),bytes6("fff5bf"),bytes6("ffdef6"),bytes6("9e331c")];
            string [7] memory beachColorTraits = ["Pink", "Green", "Black", "Gold", "White", "Cream", "Red"];

            uint traitIndex = (beachIndex * 3) / 255;
            uint traitPos = (beachIndex * 3) % 255;



            uint beachColorIndex = beachColorIndexes[traitIndex] >> traitPos & 7;
            beachTraits.beachColor =  string(abi.encodePacked("#",beachColors[beachColorIndex]));

            bytes6[4] memory jellyColors = [bytes6("4d6aff"),bytes6("80ff8a"),bytes6("ffff66"),bytes6("ff8080")];
            uint8[] memory jellyFishWeightings =  bytesToInt8Array(hex"26201904");
            traitIndex = getWeightIndex("Jelly", index, jellyFishWeightings);

            beachTraits.jellyColor = string(abi.encodePacked("#",jellyColors[traitIndex]));
            beachTraits.jellyTypeId = traitIndex + 18;


          
           
            traitIndex = getWeightIndex("ShortColor", index, shortColorWeightings) + 0;
            beachTraits.shortsColor = getTraitColor(traitIndex);

            string [5] memory shortPatterns = ["polka","striped","camels","ape_with_lemon",""];
            traitIndex = getWeightIndex("ShortPattern", index, shortPatternWeightings);

            beachTraits.shortsPattern = shortPatterns[traitIndex];

            beachTraits.shortsSVG = string.concat("<use href='#shorts' fill='", beachTraits.shortsColor, "' />", traitIndex != 4 ? string.concat("<use href='#shorts' fill='url(#", beachTraits.shortsPattern, ")' />"): "");
            string memory skinColor = getSkinColor(index);
            beachTraits.skinColor = skinColor;

            traitIndex = getWeightIndex("TowelColor", index, towelColorWeightings) + 3;
            beachTraits.towelColor= getTraitColor(traitIndex);
    

            string [2] memory towelPatterns = ["zigzag",""];
            traitIndex = getWeightIndex("TowelColor", index, towelPatternWeightins);
            beachTraits.towelPattern = towelPatterns[traitIndex];

            beachTraits.towelSVG = string.concat("<use href='#towel' fill='", beachTraits.towelColor, "' />", traitIndex != 1 ? string.concat("<use href='#towel' fill='url(#", beachTraits.towelPattern, ")' />") : "");

            (beachTraits.beverage,beachTraits.beverageAttribute) = getBeverage(index,90,927);


            beachTraits.attributes = string.concat(getTraitAttribute("Beach Color", beachColorTraits[beachColorIndex]), getTraitAttribute("Jellyfish Color", beachTraits.jellyColor), getTraitAttribute("Shorts", string.concat(beachTraits.shortsColor, " ", beachTraits.shortsPattern)), getTraitAttribute("Towel", string.concat(beachTraits.towelColor, " ", beachTraits.towelPattern)),beachTraits.beverageAttribute);
            return beachTraits;
        
        }

        function getCatTrait(uint index) public pure returns (uint, string memory) {

            bytes6[4] memory catColors = [bytes6("5b4488"),bytes6("96673c"),bytes6("e57232"),bytes6("fffffe")];

            uint catTypeId;
            string memory catColor;
            
            uint8[] memory catColorCityWeightings =  bytesToInt8Array(hex"241e1908");
            uint8[] memory catColorLandscapeWeightings =  bytesToInt8Array(hex"26241405");
            uint weightIndex;
            weightIndex =  (index >= 221) ? getWeightIndex("Cat", index, catColorLandscapeWeightings): getWeightIndex("Cat", index, catColorCityWeightings);

            catTypeId = weightIndex + 22;
            catColor = string(abi.encodePacked("#",catColors[weightIndex]));


            return (catTypeId, catColor);
        }


        function getSkinColor(uint index) public pure returns (string memory) {

            bytes6[6] memory skinColors = [bytes6("ffcabf"),bytes6("ffcc99"),bytes6("cc8f52"),bytes6("7a4625"),bytes6("ffcc4d"),bytes6("966329")];
            uint skinColorIndex = index % 6;
            string memory skinColor = string(abi.encodePacked("#",skinColors[skinColorIndex]));
            return skinColor;
        }


        function getTraitColor(uint colorIndex) public pure returns (string memory) {

            bytes6[10] memory colors = [bytes6("797d95"),bytes6("be1521"),bytes6("2bbe16"), bytes6("aa7035"),bytes6("538027"),bytes6("276280"),bytes6("802635"), bytes6("be8e16"),bytes6("ff7301"),bytes6("1597be")];
            return string(abi.encodePacked("#",colors[colorIndex]));
        }

        function getTraitAttribute(string memory traitType, string memory traitValue) public pure returns (string memory) {
            return string.concat(',{"trait_type":"', traitType, '","value":"', traitValue, '"}');
        }


        function getBeverage(uint index, uint x, uint y) public pure returns (string memory, string memory) {
        string memory scale = (index >= 221) ? "0.7" : "1";
        string[6] memory beverages = ["Coffee","Tea","Vine","Water","Ice_Tea","Lemon"];
        uint8[] memory beverageWeightings =  bytesToInt8Array(hex"19190f140906");
        string memory beverage = beverages[getWeightIndex("Beverage", index, beverageWeightings)];
        return (string.concat("<use", " href='#", beverage, "' transform='translate(", x.toString(), ",", y.toString(),") scale(", scale ,")'/>"), getTraitAttribute("Beverage", beverage));
    }


        function getCityTraits(uint index) public pure returns (CityTraits memory) {

            uint cityIndex = index - 121;

            CityTraits memory cityTraits;

            uint8[] memory displayDevicesWeightings =  bytesToInt8Array(hex"26291103");
            uint8[] memory chartTypeWeightings = bytesToInt8Array(hex"152c0e0e08");


            address[5] memory priceFeedAddresses = [0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c,0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419,0xEC8761a0A73c34329CA5B1D3Dc7eD07F30e836e2,0x379589227b15F1a12195D3f2d90bBc9F31f95235,0x214eD9Da11D2fbe465a6fc601a91E62EbEc1a0D6];
            uint traitIndex = getWeightIndex("Chart", index, chartTypeWeightings);
            cityTraits.priceFeed = priceFeedAddresses[traitIndex];

            string[4] memory displays = ['Laptop', 'Clipboard', 'Crystal Ball',  'Hologram'];
            cityTraits.displayType = getWeightIndex("Display", index, displayDevicesWeightings);

            cityTraits.displaySVG = string.concat("<use href='#", cityTraits.displayType == 0 ? "la" : cityTraits.displayType == 1 ? "cl" : cityTraits.displayType == 2 ? "cr" : "pr", "' />");

            uint cityTypes = 208949948408315176645400514316296940490473578437358986892907;
            cityTraits.skyLinetype = (cityTypes >> ((cityIndex) * 2)) & 3;

            string[4] memory skyLineTypes = ["Townview","Cityscape","Urban","Metropolis"];
            for(uint i = 0; i < skyLineTypes.length; i++) {
                if (cityTraits.skyLinetype >= i) {
                    cityTraits.skylineSVG = string.concat("<use href='#", skyLineTypes[i], "' />", cityTraits.skylineSVG );
                }
            }

            cityTraits.skylineSVG = string.concat("<g id='skyl", index.toString() ,"'>",cityTraits.skylineSVG, "</g>");

            uint coastelIndexes = 160480604047421108333616122368;
            cityTraits.isCoastel = (coastelIndexes & (1 << cityIndex)) != 0;

            (cityTraits.catTypeId, cityTraits.catColor) = getCatTrait(index);

            (cityTraits.beverage, cityTraits.beverageAttribute) = getBeverage(index,487,1039);

            uint tableColorIndex = NDUtils.randomNum(string.concat("Table", index.toString()), 0, 4) + 3;
            string memory tableColor = getTraitColor(tableColorIndex);

            cityTraits.tableSVG = string.concat("<use href='#c-table' fill='", tableColor, "' />");
            cityTraits.attributes = string.concat( getTraitAttribute("Display Device", displays[cityTraits.displayType]), getTraitAttribute("Skyline",string.concat(skyLineTypes[cityTraits.skyLinetype],cityTraits.isCoastel ? " Ocean" : "" )),getTraitAttribute("Cat Color", cityTraits.catColor ),cityTraits.beverageAttribute);

            return cityTraits;
        }

        function getNFTInside(uint index) public pure returns (uint) {

            uint8[] memory nftWeightings =  bytesToInt8Array(hex"0509070b090a0e08070a0b0a0b0c090b090c0b0d0a");
            uint256 i = NDUtils.randomNum(string.concat("NFT", index.toString()), 0,209);
            return usew(nftWeightings, i);
        }

            
        function getLandscapeTraits(uint index) public pure returns (LandscapeTraits memory ) {

            uint landscapeIndex = index - 221;

            LandscapeTraits memory landscapeTraits;

            uint8[] memory hatWeightings =  bytesToInt8Array(hex"000f16130c110f");
            uint8[] memory shirtColorWeightings = bytesToInt8Array(hex"212121");
            uint8[] memory shirtPatternWeightings = bytesToInt8Array(hex"1a280e050e");
            
            uint256[2] memory traits = [38567098456751155478290073649538280755737003682037970179806874605521698382659,7505701893370582164606120932148679538071925];

            uint climateZones = 1064990383896710156005944362069183360137773097117926154212646;

            string[3] memory climateZoneTraits = ["Polar", "Humid", "Desert"];
            bytes6[3] memory climateZoneColors = [bytes6("DFB2F7"),bytes6("B9C966"),bytes6("F9B233")];
            landscapeTraits.climateZoneIndex = (climateZones >> ((99-landscapeIndex) * 2)) & 3;

            landscapeTraits.skinColor = getSkinColor(index);

            (landscapeTraits.catTypeId, landscapeTraits.catColor) = getCatTrait(index);


            uint traitIndex = getWeightIndex("ShirtColor", index, shirtColorWeightings) + 7;
            landscapeTraits.shirtColor = getTraitColor(traitIndex);

            landscapeTraits.furnitureColor = getTraitColor(NDUtils.randomNum(string.concat("Furniture", index.toString()), 0, 4) + 3);
            landscapeTraits.furnitureSVG = string.concat("<g fill='", landscapeTraits.furnitureColor  , "'><use href='#easel' /><use href='#l-table' /></g>");

            traitIndex = NDUtils.randomNum(string.concat("Pants", index.toString()), 0, 3) + 0;
            landscapeTraits.pantsColor = getTraitColor(traitIndex);

            string [5] memory shirtPatterns = ["polka","striped","camels","ape_with_lemon",""];
            traitIndex = getWeightIndex("ShirtPattern", index, shirtPatternWeightings);

            landscapeTraits.shirtPattern = shirtPatterns[traitIndex];

            (landscapeTraits.beverage, landscapeTraits.beverageAttribute) = getBeverage(index,1020,1020);

            string [8] memory hats = ["fedora","basecap","beret","beanie","sunhat","glasses","chinoise","cylinder"];
            landscapeTraits.hat = hats[getWeightIndex("Hat", index, hatWeightings)];

            landscapeTraits.artistSVG = string.concat("<use href='#arti' fill='", landscapeTraits.skinColor, "' /><use href='#shirt' fill='", landscapeTraits.shirtColor, "' />", traitIndex != 4 ? string.concat("<use href='#shirt' fill='url(#", landscapeTraits.shirtPattern, ")' />") :"" , "<use href='#pants' fill='", landscapeTraits.pantsColor, "' /><use href='#", landscapeTraits.hat, "' />");





            traitIndex = (landscapeIndex * 4) / 256;
            uint traitPos = (landscapeIndex * 4) % 256;



            uint landscapeTrait = traits[traitIndex] >> traitPos & 15;
            landscapeTraits.hasCity = (landscapeTrait & 1) == 1;
            landscapeTraits.hasMountains = (landscapeTrait & 2) == 2;
            landscapeTraits.hasRiver = (landscapeTrait & 4) == 4;
            landscapeTraits.hasOcean = (landscapeTrait & 8) == 8;

            landscapeTraits.before = string.concat( landscapeTraits.hasMountains? "<use href='#l-m' />" : "", 
            '<polygon fill="', string(abi.encodePacked("#",climateZoneColors[landscapeTraits.climateZoneIndex])) ,'" points="1095,1096 1095,345 830,393 579,369 396,394 50,350 -19,336 -19,1096"/>');

            landscapeTraits.before = string.concat(landscapeTraits.before, landscapeTraits.hasCity ?  "<use href='#l-c' />" : "" );
            landscapeTraits.before = landscapeTraits.hasRiver ? string.concat(landscapeTraits.before, "<use href='#l-r' />") : landscapeTraits.before;

            landscapeTraits.before =  landscapeTraits.climateZoneIndex == 0 ? string.concat(landscapeTraits.before, "<use href='#l-p' />") : landscapeTraits.climateZoneIndex == 1 ? string.concat(landscapeTraits.before, "<use href='#l-t' />") : string.concat(landscapeTraits.before, "<use href='#l-d' />");

            landscapeTraits.attributes = string.concat( getTraitAttribute("Landscape", string.concat(landscapeTraits.hasCity ? "City" : "", landscapeTraits.hasRiver ? " River" :"", landscapeTraits.hasMountains ? " Mountains" : "",  landscapeTraits.hasOcean ? " Ocean" : "")), getTraitAttribute("Climate Zone", climateZoneTraits[landscapeTraits.climateZoneIndex]), getTraitAttribute("Shirt", string.concat(landscapeTraits.shirtColor, " ", landscapeTraits.shirtPattern )) ,getTraitAttribute("Cat Color", landscapeTraits.catColor ) , getTraitAttribute("Hat", landscapeTraits.hat),landscapeTraits.beverageAttribute);
            return landscapeTraits;

        }

          function usew(uint8[] memory w,uint256 i) internal pure returns (uint8) {
                uint8 ind=0;
                uint256 j=uint256(w[0]);
                while (j<i) {
                ind++;
                j+=uint256(w[ind]);
                }
                return ind;
            }

        function getWeightIndex(string memory salt, uint tokenId, uint8[] memory weights) internal pure returns (uint) {
            uint256 i  = NDUtils.randomNum(string.concat(salt, tokenId.toString()), 0,99);
            return usew(weights, i);
        }
        

        function bytesToInt8Array(bytes memory data) internal pure returns (uint8[] memory) {
            uint8[] memory result = new uint8[](data.length);
            for (uint i = 0; i < data.length; i++) {
                result[i] = uint8(data[i]);
            }
            return result;
        }




    }