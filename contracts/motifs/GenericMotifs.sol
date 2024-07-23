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
            bytes memory startIndices = hex"000000190032004d0065007a009700af00ce00e60106011f013b0158016f019001b001cf01eb020c0223023d02530268028802aa02c602e402fb0316032c0345035f037d039703b003c303d703f304060420043704510468047d049a04af04c904e204fa051f0537054d0565057a059005a205b405c905e306010618062c0643065d06750687069c06b206c906df06f7070f0727073f075307680779079407aa07c007d907f00809081f08390853086b0885089d08b308ce08e709000918092e094d096b0986099d09b209c209d109ec09fc0a0c0a1e0a310a410a4f0a610a710a840a9f0ab20ac80ae30af10b010b120b260b380b480b5e0b740b850b940ba90bc00bd00bdf0bf00bff0c0e0c1e0c320c490c5a0c6b0c800c970ca60cc10cd20ce20cf20d040d130d290d3b0d4c0d5f0d6f0d7f0d8f0d9f0daf0dc20dd30de40df40e030e140e270e390e4b0e5a0e690e790e8c0ea20eb40ec50ed50ee50ef80f0a0f1c0f340f450f550f6d0f870f980fa70fb70fca0fdc0fed0ffc100f1022103310441058106910781087109b10ab10bb10cc10df10f6111b112d114e1163117e119711b711d611f712051216122c123d124e125e1284129612ac12c412e312f4130b131d13401356136e1380139413c513d913eb13f9140a141f143614451457146a147a148a149b14ad14c414df15041517152d1541156f159d15ae15c115d115ec15fe160d1623164716741686169616a816bb16d216e216f117011712172317351746175b1770177f179317a517b517da17ec17ff181118211831184318531874188a18a018b018c918e318f9191319211934194d195f19711989";
            bytes memory motifs = hex"1f0120f1cef6b90734009a506170616b6f6c6561204265616368ffed4db1fa9c1a1f10000850756e746120436f726d6f72616e7403c77458fedd512100be5265796e056973666a6172a033090123f9c8f6bb2f160072203304616c752775804b1f009b8c75fae2551200e5506c617961204e65677261022ab4a101833ada00ff5601696b8027012053205f136f72696e69fdcb34be0a664504010e4b6172656b200380210f013d35eff6b3939f005a426c61636b202030006480191f204d61756900d3937dfc5c05f20100416e7365204368617374616e657402502216da00e885e601655370696167676961206469204669636f20880c6e646501b3fbf5ff08eaff014a80a00064406e0d6e696a6f01b3c717ff06c64b011ee0001805656c2041726520de09febb8f55034c4bb5010e201b01676540340045206d00672094116c65022aad5b0184aab20079506572697373a1210903a48766f72ba0e80102e008bf1f416c61736b6103cd61d2ff010e6600a85376696e6166656c6c736a6f6b756c6c80e607fef50d90f716dee7e0027416506f696e74652056656e75730062113205f2be0f012850214a1a616920506173697220486974616d01851a05fb6eb2db005650696ee1043a10426168616d61730275df37008ec3e7007ae1002512526f7361021a312901673665009e456c61666f21f2017369808c09ff7cc082071fbcb500d2a06d0f4d6572616800c7fb8efc74f453008743215c4149224e0c01ec2115fc22e7260096486f72219a0253686f201901617920480f726d7564610068ccdf07465c0700fe472034217f21d942750672757a2049736c201209010ce41afc503f33011960be60552041017262203d09ffbd43130353e28d010e61f704536f75726321901727417267656e74fdfa1b72011860690142436c6966746f6e803c0dffbeec3c025c3c56005a4469616ea1a014204b656e7961ffa8a8c30257979e01564e756e6777a0ee1101a9faff020c3e2000b4536861726d20456c20c60e65696b68fecbcbf80371ae2300144221af0061228a007220dc40f60c00fd2679fea2513100735072614275209c60d820220b696101c161ddff65ac1700f7e20041184c61677a69726100cc1783feffb52800fe42616c6420436170a0501fff6c52c400c96958015f4361626f204c65646ffea182b8fd6d22a90091436f70036163616220cc0cfeca53b608e269dc0003576869221c044865617665a0f709014cc8cefbb2d4b00122216a212621850c01a007c5fb1454a100d253696523322105419941b7084975f5fb23a6a0009b20a223ba005023ec0c69736fff039e02f6f4a7f3010b201682fb024d617420b80f2001466c61f69975ea00474c616e696b228280470d33b056fac996a1006f54756c756d80140900b6633c07447de400f480a56029012042246611636179fde80c9108fb8d25000b4879616d73801c0c00bfcbf4fbd327a1012750616ca045238e0c756261ffc5311bfe10f5aa0130a169006f41690c63686f011a062bfbec6570007120aa20c1014a7520970c6c6c6f01914366079fce5300e4e0027c032c204f6b23760477612c204a250f116e003c31e20461605901274d616166757368a0ce0d0050310b045c6698006552656574e0001508cdea8afaab46a30096806a2220015a6f239b0b02f1533cfff2ae9300204f6d236aa0ca0ac6f9c604c900bc0066476822dec0580975238205e30d79013c4d40ac419b1b79d2fb086c4c77009649776f204a696d61ff7af7fd06dd5569010450424b0f69204b7574610235f152ff7fa40e00b4a0ff82630a6e6861024f6d480015e6e36432210022831673657320496c6c6574657302a86d21ffed70da0128447523ac1264752050696c61740294069a00fdd12f00b45a200d166e69205261740382a2850055609100ce536f6c6172737463a9146e02fb9823ffa9ca14008a506f7274686375726e6f80e20c026169c8003c135f00b743616c408f0063231823200c022db42601bc3d4800b24f6c7520410c697a0215e0c4020659ee00b44ee4015e0e02bc3170f89c6aa9010e43616e6e6fc2be09f54242f9028e9900334c21cc006f204e269b10766502db31bbf892294801075269616c74a08109010374f50339fbc100a523b218746920616c204861666661017fc6bf035bf00a006046756a6122b7227662ee0c8073f7034ac3a8010e4a756d65e0011709fdeb9d86fcbc100f009226d9231f00642605104573746500c03fdcfb2185c6009643617922711075637265ffc17269fb2b3ed0012f4c6173259d0063257c0b73007a3bf205e4258d01065221b0024c6568211309c3058b345e006e56696a2507044e6167617280840c00acd838071e5869010e4e61632284801509feedc99d07487b20014023f9006cc32c0aff2c03bafb73baa400be5061dc02526f6a23a40c657275fe626c89fbc6cf0700ff25dd247910496e676c657361ffe437b3fb2fbe8f00f5802f004d229f230f223f0c02088cff87a2b600804d797274c05f0a03135593ff78e0be009949234b0361646f6ec4180d03733874ff95e53700d54c75736b25650079c4f310fdf62d9401198f0a0154426f756c646572c3bb08d452ddfa92704e00b8807a231d244d24c00a6e0148c223facb115a01388019114d6f73717569746f01386246facc8ed0006d8017175870752d4861005afbb704cf802900a4486972696b65746922d461bd0a20025ee2070131220b00fa2030007a2396104b73616d696c697401161ebefbe8941500a0610047240445280e6f025f8cd7079c0b77009048616d6825eca0490dffa763140258918a004c4d75797522ff6060090048dde306d4a41a0148a379005327dc252c41431267616e02244d8100dae07200ff49722d52616d229a00742271144d697871757161fff9e7f5fa97e97b000852616269239f015265c8bb09018ed31b079dff28008024eb006b293b806e0cff80d10606e4ca6e001841686dc02c0c03121456fffec33200d14c6f6e213c0902ea15fc002228f000a5214d0c697302fca30c00845c4800b446239e076b6675727420616d259d0f696e02d312dc0081f491007e5a757269235f19693d8bffc7abb800b44d6164726964031cfe40014087b800a05723dd007a25051d03181a6000445f25009a526f7474657264616d02b5f38c008bb82e00c94d242721400adff9ce00fa761600b45769240b0a72d6f201baa66700a9497322570c62756c0352ab7f023cb94a006321d5006b20521f8a67ca0111cffa009253746f636b686f6c6d0308164e0042829e00c74272757824200265732f2009107373656cfe9883c5fd380913002c53616f222e1f756c6ffdefda01fc857b8e000a4275656e6f73204169726573fe020d6cfbcaad02260156475f29e3006f23a32a000d696c65ff4792e9fb69127101364c253c1a00465693fb95ccf1015d426f676f746100a0326dfc032bc801194326da0c636173fdeb83d3fca691ce0162431b1f65766964656ffe7e25d5fc906faf003e4173756e63696f6eff0441cbfbf0614f43e420970a7a00d12e75faae42630067207f2679016c76232c0c72fe70205c01abfdd401604a6f25e41f6e657362757267ffec28880231b4bf00214e6169726f626900626b030033c25c01007927fe0f6f730089829f024f5e2501104164646920e001626526df0997e3de02575eef001c44242725bf20630d61616dff798c6100c9e9c3015f4c22d229470b54ca21fffceb120084416363284709513f76ffc2ab7e002d4122720d6a616e01ca5efc01dc94ea01454b407b0a02319819009b6a6a00a55422e41d73023098f600301e620095416c67696572020023eeff8b138c0092436173247527501f61026df430fb97333b00d04e657720596f726b2043697479029a121bfb44bdda0400a3546f7224540a6f027f0f03fac6d4d600b22185006320d70a020798e8f8f38f5500b44c41b5026e676521e8090240b4c5f8b4483100ab413742b210636973636f018919c7fb38581d00584d6923c10b01286640fa16c55900f3436929ee006441db144d657869636f200181cb6403127ef5005761642d4421651f01807a68034b6b14001e4475626179790167fcea037b929400744d61737161740a01795d5002c8212800996123a4243b08640146d6e6025fa8fa206c0e616b6b6101e49f020219401800644a254701736821671179696d0174fcbb033da3780033416275205a23c10d01fc528c02a4fe5a00ac4261676820950a01ff56c60229e89600604422681173636871200220fe52030f404e00be546568238f0b0260ed5a01f55c660155416e2cd50a61017c5c6c03fee01b007f2ce70d61636901e0a5b3046e178d00a64c28281f75720123c7bf0457752500914d756d62616901b38c1f04977345003c4e65752d1344656c6869015798a1054386d7002b4b6f6c6b6122d109d1b62d05fdfa3f01154224950d6b6f6b0140c7c1064eef6e00c6482d7b1f6f69016b0c8b05631f1400924468616b610260bcaa06eff41600874265696a69116e6701c234ab06594b7c001f43686f6e677140120857e12906cc454800962af1016e7a20030901dc28d5073d159f004e27591f6e67686169022079800853c00300d4546f6b796f023c63ef07936f7b00c15365006f2407090c6bc70441ee4100dc4144191061025ccba703fdf24b014c53616d61727122bc0b003010fe060f7c0300ac4b75217411204c756d7075720013ffb1063027c2009c532088006120110affa189b9065f632601414a20be007220f109df108a0735f43e00e74d26cb1f6c61fdfa7d33090263a100255379646e6579fdbe518208a2b48d00364d656c622c1c0b6e65fde4f33608e3f639014c285b126265727261fdcceaf70a6ca0f300134175636b22ea0a64011a144bfbd4ea5f0097229b285102446f6d20811f6f2000917659ff2f351300d9436f6e61726b79ffe222a601cb16b801394b696713616c69021ebcf902b58f6700d561732d53756c61220e006e226909008962dcfb426e4f00b6e201c6264820ff0a0049ac4601e1b22e00064422370c756261fe184c7106e8204a012327cc0b7468ff14359f01af58a4001b276d20f40a03c7d71b009fc99500df54236c00642c850e6dff7b391806dd8b75002244656e7023ae1d720069b4d304c28acb00fb436f6c6f6d626f01d2b4c706cfbaa30046577521b40a03a5a5f2f711080000dd4127dc2b751c676501bf608402dbfff60055616c2d4b7577616974030acc86f9339f7420b401616c28a30a79ffd034f5fc6c1080002b216d0f617573200109f5eb04ad3b2000a7486126d7007227581f640025d4080557b93a009a5468696d7068750301e19e01d304c000f74b796a691e77024ab552019dafd70078497a6d69720113f3b1ff0c65cb010c4e6f75616b208d0d747401f437f9fa3afb490100446129e50b7301ce24c503668099004d4b2e33234b06028d97f953b3312e7d2e4c0e6e6978016ba42501f6f8f800ef4e61263c2e660d65fe96ba6107fb2bff00de416c692ceb0153702b120b6773fea20119fbef0264002821d9292e016472662e0141742600006d2bfb24b11f6c6500ff857dffd1f343001454696d62756b74750230362904e837b000b65072006f2f9e057a2058696e6a2e3c006760320b6e6101f774a5f9a9d67f00a28c53205d0c6473022965f7f925936a00ea4c2a0f0856656761732c204e6526200861023b5baaf96930852974016f6e2a70036e74205620eb0c65790271fb82061e671900b94926352959201f0067319c0069a0680b00ec959501eeb53a005257652b30086572204e696c2c204b2e9700742d5d0afea4116800e19844011b4e253d09622d4e61756b6c7566742077400f096961024d76e0f96e8b1a27fa0e6f6162fe079ba1fbe734f401484d6528520b7a6100ea29e002a1a7b8005820c100612110015965209c0c024435d8037b94d600d241736721e40d740192f2d7045c37e100dd4a6f6421e30e7201676dd2037a01c500304d757363202008b68a790221b9fb00fcc1300154612149002c2118047564692d41222a483408387becffc71a5200bc2e90006e21160d200137ecf902f9592200b55275624bb420d80c6c69fe8fa9df081e283c000053225205736f6e20446520fa0c74ff2cd18efb718c7a01454973243620b2012047214502616e2c21da2b09089d8e0bfbce6eb90154a1df0a020f2887f91d34d900a84d2b2d017665a0460cfe7f8b490143e67000004b616c257d09726902a8ce5c066768c52d0406616769696e207521b9004727b0002ce1008f0901a04ead01ae66bf00b381f1809109020f7f95f92eb79000e443790072280a0f205269766572017fed0c035bbcdb008dcc760d001fadcb02b3082c00854d6f676127ed23fd0d010336ae014d513200c34775656c4c6d00272ee3006323e4052c20456e656431d52d93056561752c2054202f2678022e8cd62dbf046f0115456d2a8e006f293a0d69ffbddee400e80c0000644b696e26c40773610301e9eb01d2219c0edc4b696576020f61b00247c464005d4f490d79726103d701d1feffd1a2000c562df0006192740b04c0b3bd00b01405003159742285004e31bb0f6b6f796104eac61bfc48b0b7015d416c218009043dfdf701897844000420200e646b61707003d23601feb53c1101173424006b21641e696b043fa25af6a7ce040152426172726f77040b29a90136d5ea01214b69722af20dfcbb75c2fbed6d8a013f55736875312c0c03c83cc308829b81001a4f796d2b160b6f6e04f3f8cefbccd02e01657110215b01756d22cc0a01f9598b057c851300395123dc012d5a238f002da1210a0256854a0452e8fd00b454225a017361261c214400502304007221c200752bb7211c090227c832048278a4004a47840f6b6f72756d02c631600079d53c00874a2c1315667261756a6f636801abdb0e052f7e6900e94d74204521cf312b09fc0c79350602883c00b22932006151c0046b652c20422035239401486933be022c20412067107263746963610493c43e0401732b01434f2f3e016f762c402046026e796a203200613455007429d70065236f005241c20b61029cc42b00a84717006c462ae30c6e7a650294e45300539d9c0101323f017365205d0a65030a254c00aced9900d6240927480a02376b36faacfe3d00bd4d241840020170702fbd427d0a036a47e5ffbb6b2400644c20cc24310c730365eace0294715100c7566f20bd0702b94b950186d8e4a12d00692ac4046e6961ffbc281f04424a250000c3c4014c61279844f40049242d2ad40c6961fdcd7aec08a5e72b00294727eb2ae4006e8072042c2056696355d220d301417520f223c60d61031005e50066783700744475696b110a02fbc4fd012f8fed006d4b41800d7702d52ad70122a88a005242756432fb12737402bf39d000dddf9f00dd4c6a75626c6a61284108412761f8b25068007f43f1ea003a0a02602b79ffc2b99e01115425301f646f0230d55f0852410d00bc4e696b6b6f017e2d9f073df47f006c546169706508680199451f05f96aad2b4028fc223a0b016028bcfb16b1a80013486120ff0b6e610113aa5f049456c2009f2349016773343f1a031f4920063624cc00b249726b7574736b03571a2f058a960d00c120bf03736e6f79219d0f6b0347d1d204f075e600b14e6f766f7325764014080ce102f91c6d1b004a299c0f666602d63094fcdaedf9007453742e202c240c6e277302b8db21fb9ece9900df25f423750e616c03d1739af7afed9a005944617724f71503c19885f850570b00a24e616174732769686368276f21d130e2006f369922e00d726bfed676b6fd776a810142497020170f6e6761002b1663fc628a610118426f61219829870aff0d7113fd2190fa00474220b82f290b61ff4982a7010db698014b432c500e7a6102972f9c02835c85007a456c622b0e0a0207a90c046e5010004353274a006128101e010314a900796045006741676164657a00849753078ddb39012e526962204945e3006d24a90069383e012d4c21ca0e6501207b1dfa2275c40126506f706f262613657065746cfcd5aa960460d41e00424865617264b5f50900d9a9160267423300e048040c6f6c00c12afd0338701900d248252d00622502035375717522570bfdca5ce0ff44ce5e000c547240d9016e20264701437532ff0afd6938be0a39ceaa002e522939310a630c0c007c4df0fb5c3b5400ae546170264a51d12d59268e1703d44a15fceca7f500dd4e75756b01c3f369021b89f000862c6023480c756d2001a4daa2055b4743013a320c00612583223511204368752002b7d22503c6aac3013142616924af0c7572fe62913ef97ce95e001252344e03204e75692d711455ff9ed865008d436f746f20646520446f6e616e61";
            uint startIndex = uint(uint8(startIndices[index * 2])) << 8 | uint(uint8(startIndices[index * 2 + 1]));
            uint endIndex = uint(uint8(startIndices[(index + 1) * 2])) << 8 | uint(uint8(startIndices[(index + 1) * 2 + 1]));


            return (motifs, startIndex, endIndex);
        }

        function getFlowerType(uint index) public pure returns (FlowerType) {

            uint8[] memory flowerWeightings =  bytesToInt8Array(hex"2820100c");
            return FlowerType(getWeightIndex("Flower", index, flowerWeightings));
        }
       

 


        function getBeachTraits(uint index) public pure returns (BeachTraits memory) {

            uint beachIndex = index - 19;

            uint8 [] memory shortColorWeightings = bytesToInt8Array(hex"212121");
            uint8 [] memory shortPatternWeightings = bytesToInt8Array(hex"1e1e140310");
            uint8 [] memory towelColorWeightings = bytesToInt8Array(hex"18161c19");
            uint8 [] memory towelPatternWeightins = bytesToInt8Array(hex"154e");

            BeachTraits memory beachTraits;
            uint256[2] memory beachColorIndexes = [41341480336443795834078175875216095607501858439471481496782762632714599867529,11988922190500];             
            bytes6[6] memory beachColors = [bytes6("ffa0e7"),bytes6("9bb224"),bytes6("4b3d66"),bytes6("ffd700"),bytes6("fff5bf"),bytes6("ffdef6")];
            string [6] memory beachColorTraits = ["Pink", "Green", "Black", "Gold", "White", "Cream"];

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

            string [5] memory shortPatterns = ["polka","striped","animal","animal2","none"];
            traitIndex = getWeightIndex("ShortPattern", index, shortPatternWeightings);

            beachTraits.shortsPattern = shortPatterns[traitIndex];

            beachTraits.shortsSVG = string.concat("<use href='#shorts' fill='", beachTraits.shortsColor, "' /><use href='#shorts' fill='url(#", beachTraits.shortsPattern, ")' />");
            string memory skinColor = getSkinColor(index);
            beachTraits.skinColor = skinColor;

            traitIndex = getWeightIndex("TowelColor", index, towelColorWeightings) + 3;
            beachTraits.towelColor= getTraitColor(traitIndex);
    

            string [2] memory towelPatterns = ["zigzag","none"];
            traitIndex = getWeightIndex("TowelColor", index, towelPatternWeightins);
            beachTraits.towelPattern = towelPatterns[traitIndex];

            beachTraits.towelSVG = string.concat("<use href='#towel' fill='", beachTraits.towelColor, "' /><use href='#towel' fill='url(#", beachTraits.towelPattern, ")' />");

            beachTraits.attributes = string.concat(getTraitAttribute("Beach Color", beachColorTraits[beachColorIndex]), getTraitAttribute("Jellyfish Color", beachTraits.jellyColor), getTraitAttribute("Shorts", string.concat(beachTraits.shortsColor, " ", beachTraits.shortsPattern)), getTraitAttribute("Towel", string.concat(beachTraits.towelColor, " ", beachTraits.towelPattern)));
            return beachTraits;
        
        }

        function getCatTrait(uint index) public pure returns (uint, string memory) {

            bytes6[4] memory catColors = [bytes6("5b4488"),bytes6("96673c"),bytes6("e57232"),bytes6("fffffe")];

            uint catTypeId;
            string memory catColor;
            
            uint8[] memory catColorCityWeightings =  bytesToInt8Array(hex"241e1908");
            uint8[] memory catColorLandscapeWeightings =  bytesToInt8Array(hex"26241405");
            uint weightIndex;
            weightIndex =  (index >= 219) ? getWeightIndex("Cat", index, catColorLandscapeWeightings): getWeightIndex("Cat", index, catColorCityWeightings);

            catTypeId = weightIndex + 22;
            catColor = string(abi.encodePacked("#",catColors[weightIndex]));


            return (catTypeId, catColor);
        }


        function getSkinColor(uint index) public pure returns (string memory) {

            bytes6[10] memory skinColors = [bytes6("ffcabf"),bytes6("ffcc99"),bytes6("e6ae76"),bytes6("cc8f52"),bytes6("bb7f43"),bytes6("966329"),bytes6("925b2d"),bytes6("7a4625"),bytes6("ffcc73"),bytes6("ffcc4d")];
            uint skinColorIndex = NDUtils.randomNum(string.concat("Skin", index.toString()),0,9);
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


        function getCityTraits(uint index) public pure returns (CityTraits memory) {

            uint cityIndex = index - 19 - 100;

            CityTraits memory cityTraits;

            uint8[] memory displayDevicesWeightings =  bytesToInt8Array(hex"26291103");
            uint8[] memory chartTypeWeightings = bytesToInt8Array(hex"152c0e0e08");


            address[5] memory priceFeedAddresses = [0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c,0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419,0xEC8761a0A73c34329CA5B1D3Dc7eD07F30e836e2,0x379589227b15F1a12195D3f2d90bBc9F31f95235,0x214eD9Da11D2fbe465a6fc601a91E62EbEc1a0D6];
            uint traitIndex = getWeightIndex("Chart", index, chartTypeWeightings);
            cityTraits.priceFeed = priceFeedAddresses[traitIndex];

            string[4] memory displays = ['Laptop', 'Clipboard', 'Crystal Ball',  'Hologram'];
            cityTraits.displayType = getWeightIndex("Display", index, displayDevicesWeightings);

            cityTraits.displaySVG = string.concat("<use href='#", cityTraits.displayType == 0 ? "cr" : cityTraits.displayType == 1 ? "la" : cityTraits.displayType == 2 ? "cl" : "pr", "' />");

            uint cityTypes = 208949948408315176645400514316296940490473578437358986892907;
            cityTraits.skyLinetype = (cityTypes >> ((cityIndex) * 2)) & 3;

            string[4] memory skyLineTypes = ["mini","midi","large","mega"];
            for(uint i = 0; i < skyLineTypes.length; i++) {
                if (cityTraits.skyLinetype >= i) {
                    cityTraits.skylineSVG = string.concat("<use href='#", skyLineTypes[i], "' />", cityTraits.skylineSVG );
                }
            }

            uint coastelIndexes = 160480604047421108333616122368;
            cityTraits.isCoastel = (coastelIndexes & (1 << cityIndex)) != 0;

            (cityTraits.catTypeId, cityTraits.catColor) = getCatTrait(index);

            uint tableColorIndex = NDUtils.randomNum(string.concat("Table", index.toString()), 0, 4) + 3;
            string memory tableColor = getTraitColor(tableColorIndex);

            cityTraits.tableSVG = string.concat("<use href='#c-table' fill='", tableColor, "' />");
            cityTraits.attributes = string.concat( getTraitAttribute("Display Device", displays[cityTraits.displayType]), getTraitAttribute("Skyline",string.concat(skyLineTypes[cityTraits.skyLinetype],cityTraits.isCoastel ? " Ocean" : "" )));

            return cityTraits;
        }

        function getNFTInside(uint index) public pure returns (uint) {

            uint8[] memory nftWeightings =  bytesToInt8Array(hex"00010a090c0b0a0a0d0b0b0d100b0b080d060d");
            uint256 i = NDUtils.randomNum(string.concat("NFT", index.toString()), 0,189);
            return usew(nftWeightings, i);
        }

            
        function getLandscapeTraits(uint index) public pure returns (LandscapeTraits memory ) {

            uint landscapeIndex = index - 19 - 100 - 100;

            LandscapeTraits memory landscapeTraits;

            uint8[] memory hatWeightings =  bytesToInt8Array(hex"000f16130c110f");
            uint8[] memory shirtColorWeightings = bytesToInt8Array(hex"212121");
            uint8[] memory shirtPatternWeightings = bytesToInt8Array(hex"1a280e050e");
            
            uint256[2] memory traits = [38567096731314568780641464313144695135602970097189989059279612274963869152067,4467654741599495210471749775461820980734155125];

            uint climateZones = 17140672472095896272335075615643983079201628415938079165600357;

            string[3] memory climateZoneTraits = ["Polar", "Temperate", "Desert"];
            bytes6[3] memory climateZoneColors = [bytes6("DFB2F7"),bytes6("B9C966"),bytes6("F9B233")];
            landscapeTraits.climateZoneIndex = (climateZones >> ((101-landscapeIndex) * 2)) & 3;
            landscapeTraits.climateZoneColor = string(abi.encodePacked("#",climateZoneColors[landscapeTraits.climateZoneIndex]));

            landscapeTraits.skinColor = getSkinColor(index);

            (landscapeTraits.catTypeId, landscapeTraits.catColor) = getCatTrait(index);


            uint traitIndex = getWeightIndex("ShirtColor", index, shirtColorWeightings) + 7;
            landscapeTraits.shirtColor = getTraitColor(traitIndex);

            landscapeTraits.furnitureColor = getTraitColor(NDUtils.randomNum(string.concat("Furniture", index.toString()), 0, 4) + 3);
            landscapeTraits.furnitureSVG = string.concat("<g fill='", landscapeTraits.furnitureColor  , "'><use href='#easel' /><use href='#l-table' /></g>");

            traitIndex = NDUtils.randomNum(string.concat("Pants", index.toString()), 0, 3) + 0;
            landscapeTraits.pantsColor = getTraitColor(traitIndex);

            string [5] memory shirtPatterns = ["polka","striped","animal","animal2","none"];
            traitIndex = getWeightIndex("ShirtPattern", index, shirtPatternWeightings);

            landscapeTraits.shirtPattern = shirtPatterns[traitIndex];


            string [8] memory hats = ["fedora","basecap","french_hat","beanie","sunhat","glasses","chinoise","cylinder"];
            landscapeTraits.hat = hats[getWeightIndex("Hat", index, hatWeightings)];

            landscapeTraits.artistSVG = string.concat("<use href='#arti' fill='", landscapeTraits.skinColor, "' /><use href='#shirt' fill='", landscapeTraits.shirtColor, "' /><use href='#shirt' fill='url(#", landscapeTraits.shirtPattern, ")' /><use href='#pants' fill='", landscapeTraits.pantsColor, "' /><use href='#", landscapeTraits.hat, "' />");





            traitIndex = (landscapeIndex * 4) / 256;
            uint traitPos = (landscapeIndex * 4) % 256;



            uint landscapeTrait = traits[traitIndex] >> traitPos & 15;
            landscapeTraits.hasCity = (landscapeTrait & 1) == 1;
            landscapeTraits.hasMountains = (landscapeTrait & 2) == 2;
            landscapeTraits.hasRiver = (landscapeTrait & 4) == 4;
            landscapeTraits.hasOcean = (landscapeTrait & 8) == 8;

            landscapeTraits.before = landscapeTraits.hasMountains ? "<use href='#l-m' />" : "";

            landscapeTraits.front = landscapeTraits.hasCity ? "<use href='#l-c' />" : "";
            landscapeTraits.front = landscapeTraits.hasRiver ? string.concat(landscapeTraits.front, "<use href='#l-r' />") : landscapeTraits.front;

            landscapeTraits.front =  landscapeTraits.climateZoneIndex == 0 ? string.concat(landscapeTraits.front, "<use href='#l-p' />") : landscapeTraits.climateZoneIndex == 1 ? string.concat(landscapeTraits.front, "<use href='#l-t' />") : string.concat(landscapeTraits.front, "<use href='#l-d' />");


            landscapeTraits.attributes = string.concat( getTraitAttribute("Landscape", string.concat(landscapeTraits.hasCity ? "City " : "", landscapeTraits.hasRiver ? " River" :"", landscapeTraits.hasMountains ? "Mountains " : "",  landscapeTraits.hasOcean ? "Ocean" : "")), getTraitAttribute("Climate Zone", climateZoneTraits[landscapeTraits.climateZoneIndex]), getTraitAttribute("Shirt", string.concat(landscapeTraits.shirtColor, " ", landscapeTraits.shirtPattern )) ,getTraitAttribute("Cat Color", landscapeTraits.catColor ) , getTraitAttribute("Hat", landscapeTraits.hat));
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