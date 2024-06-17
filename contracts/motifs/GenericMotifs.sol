// SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;
    import "../BasicMotif.sol";
    contract GenericMotifs {
       

        function getBeach(uint index) public pure returns (bytes memory) {
            string[100] memory motifs = [hex"0120f1cef6b90734009a506170616b6f6c6561204265616368",hex"ffed4db1fa9c1a10000850756e746120436f726d6f72616e74",hex"03c77458fedd512100be5265796e6973666a617261204265616368",hex"0123f9c8f6bb2f16007250756e616c752775204265616368",hex"009b8c75fae2551200e5506c617961204e65677261",hex"022ab4a101833ada00ff56696b2042656163682053616e746f72696e69",hex"fdcb34be0a664504010e4b6172656b617265204265616368",hex"013d35eff6b3939f005a426c61636b2053616e64204265616368204d617569",hex"00d3937dfc5c05f20100416e7365204368617374616e6574",hex"025022da00e885e601655370696167676961206469204669636f6772616e6465",hex"01b3fbf5ff08eaff014a506c6179612064652042656e696a6f",hex"01b3c717ff06c64b011e506c61796120646520656c204172656e616c",hex"febb8f55034c4bb5010e506c616765206465204574616e672053616c65",hex"022aad5b0184aab2007950657269737361204265616368",hex"03a48766f72ba0e80102426c61636b2053616e6420426561636820416c61736b61",hex"03cd61d2ff010e6600a85376696e6166656c6c736a6f6b756c6c204265616368",hex"fef50d90f716dee7010e506c61676520646520506f696e74652056656e7573",hex"0062113205f2be0f012850616e74616920506173697220486974616d",hex"01851a05fb6eb2db005650696e6b2053616e6420426561636820426168616d6173",hex"0275df37008ec3e7007a537069616767696120526f7361",hex"021a312901673665009e456c61666f6e69737369204265616368",hex"ff7cc082071fbcb500d250616e746169204d65726168",hex"00c7fb8efc74f45300874372616e65204265616368",hex"01ec2115fc22e7260096486f7273652053686f6520426179204265726d756461",hex"0068ccdf07465c0700fe4772616e64652053616e7461204372757a2049736c616e64",hex"010ce41afc503f33011950696e6b2042656163682042617262756461",hex"ffbd43130353e28d010e416e736520536f75726365206427417267656e74",hex"fdfa1b72011860690142436c6966746f6e204265616368",hex"ffbeec3c025c3c56005a4469616e61204265616368204b656e7961",hex"ffa8a8c30257979e01564e756e677769204265616368",hex"01a9faff020c3e2000b4536861726d20456c20536865696b68",hex"fecbcbf80371ae23001442656c6c61204d617265204265616368",hex"00fd2679fea25131007350726169612064652053616e7461204d61726961",hex"01c161ddff65ac1700f7506c616765206465204c61677a697261",hex"00cc1783feffb52800fe42616c642043617065204265616368",hex"ff6c52c400c96958015f4361626f204c65646f",hex"fea182b8fd6d22a90091436f7061636162616e61",hex"feca53b608e269dc000357686974652048656176656e204265616368",hex"014cc8cefbb2d4b00122477261636520426179",hex"01a007c5fb1454a100d2536965737461204b6579204265616368",hex"014975f5fb23a6a0009b506c617961205061726169736f",hex"ff039e02f6f4a7f3010b506c616765206465204d617469726120",hex"01466c61f69975ea00474c616e696b6169204265616368",hex"0133b056fac996a1006f54756c756d204265616368",hex"00b6633c07447de400f4576869746520426561636820426f7261636179",hex"fde80c9108fb8d25000b4879616d73204265616368",hex"00bfcbf4fbd327a1012750616c6d204265616368204172756261",hex"ffc5311bfe10f5aa0130507261696120646f2053616e63686f",hex"011a062bfbec65700071506c617961204a75616e696c6c6f",hex"01914366079fce5300e457686974652042656163682c204f6b696e6177612c204a6170616e",hex"003c31e20461605901274d61616675736869204265616368",hex"0050310b045c66980065526565746869204265616368",hex"00cdea8afaab46a30096506c61796120456c205a6f6e7465",hex"02f1533cfff2ae9300204f6d616861204265616368",hex"00c6f9c604c900bc00664768616e6469204265616368",hex"0075238205e30d79013c4d61796120426179",hex"0179d2fb086c4c77009649776f204a696d61",hex"ff7af7fd06dd5569010450616e746169204b757461",hex"0235f152ff7fa40e00b45072616961206461204d6172696e6861",hex"024f6d480015e6e3010e506c6179612064652073657320496c6c65746573",hex"02a86d21ffed70da012844756e652064752050696c6174",hex"0294069a00fdd12f00b45a6c61746e6920526174",hex"0382a2850055609100ce536f6c6172737472616e64656e",hex"02fb9823ffa9ca14008a506f7274686375726e6f204265616368",hex"026169c8003c135f00b743616c61204d61636172656c6c61",hex"022db42601bc3d4800b24f6c7564656e697a",hex"0215e0c4020659ee00b44e69737369204265616368",hex"02bc3170f89c6aa9010e43616e6e6f6e204265616368",hex"01f54242f9028e9900334c61204a6f6c6c6120436f7665",hex"02db31bbf892294801075269616c746f204265616368",hex"010374f50339fbc100a5536861746920616c204861666661",hex"017fc6bf035bf00a006046756a6169726168204265616368",hex"018073f7034ac3a8010e4a756d6569726168204265616368",hex"fdeb9d86fcbc100f009250756e74612064656c2045737465",hex"00c03fdcfb2185c600964361796f205375637265",hex"ffc17269fb2b3ed0012f4c617320506f6369746173",hex"007a3bf205e4258d0106526169204c6568",hex"00b743c3058b345e006e56696a6179204e61676172204265616368",hex"00acd838071e5869010e4e616370616e204265616368",hex"feedc99d07487b2001404361626c6520426561636820",hex"ff2c03bafb73baa400be506c61796120526f6a612050657275",hex"fe626c89fbc6cf0700ff426168696120496e676c657361",hex"ffe437b3fb2fbe8f00f5506c617961204d6f6e74616e697461",hex"0202088cff87a2b600804d7972746c65204265616368",hex"03135593ff78e0be0099496e636861646f6e6579204265616368",hex"03733874ff95e53700d54c75736b656e74797265204265616368",hex"fdf62d9401198f0a0154426f756c64657273204265616368",hex"00d452ddfa92704e00b8506c61796120456c2050617265646f6e",hex"0148c223facb115a0138506c617961204d6f73717569746f",hex"01386246facc8ed0006d506c617961205870752d4861",hex"005afbb704cf802900a4486972696b657469796120426561636820",hex"025ee2070131220b00fa506c617a6869204b73616d696c6974",hex"01161ebefbe894150038506c617961204775616e6162616e6f",hex"025f8cd7079c0b77009048616d68756e6720426561636820",hex"ffa763140258918a004c4d7579756e69204265616368",hex"0048dde306d4a41a014850616e7461692053657269204b656e74616e67616e",hex"02244d8100dae07200ff49722d52616d6c612074616c204d697871757161",hex"fff9e7f5fa97e97b00085261626964612052656420426561636820",hex"018ed31b079dff2800804879616b756e61204265616368",hex"ff80d10606e4ca6e001841686d6564204265616368"];
            return bytes(motifs[index]);
        }

        function getSkyscraper(uint index) public pure returns (bytes memory) {
            string[100] memory motifs = [hex"03121456fffec33200d14c6f6e646f6e",hex"02ea15fc002228f000a55061726973",hex"02fca30c00845c4800b44672616e6b6675727420616d204d61696e",hex"02d312dc0081f491007e5a7572696368",hex"02693d8bffc7abb800b44d6164726964",hex"031cfe40014087b800a0576172737a617761",hex"03181a6000445f25009a526f7474657264616d",hex"02b5f38c008bb82e00c94d696c616e6f",hex"02dff9ce00fa761600b45769656e",hex"0272d6f201baa66700a9497374616e62756c",hex"0352ab7f023cb94a00634d6f736b7761",hex"038a67ca0111cffa009253746f636b686f6c6d",hex"0308164e0042829e00c742727578656c6c65732f4272757373656c",hex"fe9883c5fd380913002c53616f205061756c6f",hex"fdefda01fc857b8e000a4275656e6f73204169726573",hex"fe020d6cfbcaad26015653616e746961676f206465204368696c65",hex"ff4792e9fb69127101364c696d61",hex"00465693fb95ccf1015d426f676f7461",hex"00a0326dfc032bc8011943617261636173",hex"fdeb83d3fca691ce01624d6f6e7465766964656f",hex"fe7e25d5fc906faf003e4173756e63696f6e",hex"ff0441cbfbf0614f012f4c612050617a",hex"00d12e75faae4263006753616e2053616c7661646f72",hex"fe70205c01abfdd401604a6f68616e6e657362757267",hex"ffec28880231b4bf00214e6169726f6269",hex"00626b030033c25c00794c61676f73",hex"0089829f024f5e2501104164646973204162656261",hex"ff97e3de02575eef001c4461722065732053616c61616d",hex"ff798c6100c9e9c3015f4c75616e6461",hex"0054ca21fffceb1200844163637261",hex"00513f76ffc2ab7e002d416269646a616e",hex"01ca5efc01dc94ea01454b6169726f",hex"02319819009b6a6a00a554756e6973",hex"023098f600301e620095416c67696572",hex"020023eeff8b138c009243617361626c616e6361",hex"026df430fb97333b00d04e657720596f726b2043697479",hex"029a121bfb44bdda00a3546f726f6e746f",hex"027f0f03fac6d4d600b24368696361676f",hex"020798e8f8f38f5500b44c6f7320416e67656c6573",hex"0240b4c5f8b4483100ab53616e204672616e636973636f",hex"018919c7fb38581d00584d69616d69",hex"01286640fa16c55900f3436975646164206465204d657869636f20",hex"0181cb6403127ef5005761642d446f6861",hex"01807a68034b6b14001e447562617979",hex"0167fcea037b929400744d6173716174",hex"01795d5002c82128009961722d5269796164",hex"0146d6e6025fa8fa00584d616b6b61",hex"01e49f020219401800644a6572757368616c6179696d",hex"0174fcbb033da3780033416275205a616269",hex"01fc528c02a4fe5a00ac42616768646164",hex"01ff56c60229e896006044696d617363687120",hex"0220fe52030f404e00be54656872616e",hex"0260ed5a01f55c660155416e6b617261",hex"017c5c6c03fee01b007f4b6172616369",hex"01e0a5b3046e178d00a64c6168617572",hex"0123c7bf0457752500914d756d626169",hex"01b38c1f04977345003c4e65752d44656c6869",hex"015798a1054386d7002b4b6f6c6b617461",hex"00d1b62d05fdfa3f011542616e676b6f6b",hex"0140c7c1064eef6e00c64861204e6f69",hex"016b0c8b05631f1400924468616b61",hex"0260bcaa06eff41600874265696a696e67",hex"01c234ab06594b7c001f43686f6e6771696e67",hex"0157e12906cc454800965368656e7a68656e",hex"01dc28d5073d159f004e5368616e67686169",hex"022079800853c00300d4546f6b796f",hex"023c63ef07936f7b00c153656f756c",hex"030c6bc70441ee4100dc417374616e61",hex"025ccba703fdf24b014c53616d617271616e64",hex"003010fe060f7c0300ac4b75616c61204c756d707572",hex"0013ffb1063027c2009c53696e6761707572",hex"ffa189b9065f632601414a616b61727461",hex"00df108a0735f43e00e74d616e696c61",hex"fdfa7d33090263a100255379646e6579",hex"fdbe518208a2b48d00364d656c626f75726e65",hex"fde4f33608e3f639014c43616e6265727261",hex"fdcceaf70a6ca0f300134175636b6c616e64",hex"011a144bfbd4ea5f009753616e746f20446f6d696e676f20",hex"00917659ff2f351300d9436f6e61726b79",hex"ffe222a601cb16b801394b6967616c69",hex"021ebcf902b58f6700d561732d53756c61696d616e697961",hex"008962dcfb426e4f00b64369756461642064652050616e616d61",hex"0049ac4601e1b22e000644736368756261",hex"fe184c7106e8204a01235065727468",hex"ff14359f01af58a4001b4c7573616b61",hex"03c7d71b009fc99500df54726f6e646865696d",hex"ff7b391806dd8b75002244656e7061736172",hex"0069b4d304c28acb00fb436f6c6f6d626f",hex"01d2b4c706cfbaa30046577568616e",hex"03a5a5f2f711080000dd416e63686f72616765",hex"01bf608402dbfff60055616c2d4b7577616974",hex"030acc86f9339f7400b643616c67617279",hex"ffd034f5fc6c1080002b4d616e61757320",hex"0109f5eb04ad3b2000a748616964617261626164",hex"0025d4080557b93a009a5468696d706875",hex"0301e19e01d304c000f74b796a6977",hex"024ab552019dafd70078497a6d6972",hex"0113f3b1ff0c65cb010c4e6f75616b63686f7474",hex"01f437f9fa3afb49010044616c6c6173",hex"01ce24c503668099004d4b65726d616e"];
            return bytes(motifs[index]);
        }

        function getLandscape(uint index) public pure returns (bytes memory) {
            string[102] memory motifs = [hex"02028d97f953b33100d250686f656e6978",hex"016ba42501f6f8f800ef4e6173736572736565",hex"fe96ba6107fb2bff00de416c69636520537072696e6773",hex"fea20119fbef0264002853616e20506564726f2064652041746163616d612c204368696c65",hex"00ff857dffd1f343001454696d62756b7475",hex"0230362904e837b000b650726f76696e7a2058696e6a69616e672c204368696e61",hex"01f774a5f9a9d67f00a257686974652053616e6473",hex"022965f7f925936a00ea4c61732056656761732c204e6576616461",hex"023b5baaf969308500804d6f6e756d656e742056616c6c6579",hex"0271fb82061e671900b9496e6e657265204d6f6e676f6c65692c204368696e61",hex"00ec959501eeb53a005257656973736572204e696c2c204b68617274756d20",hex"fea4116800e19844011b4e616d69622d4e61756b6c7566742c204e616d69626961",hex"024d76e0f96e8b1a00b44d6f6162",hex"fe079ba1fbe734f401484d656e646f7a61",hex"00ea29e002a1a7b8005853616e61612c2059656d656e",hex"024435d8037b94d600d241736761626174",hex"0192f2d7045c37e100dd4a6f6470687572",hex"01676dd2037a01c500304d7573636174",hex"01b68a790221b9fb00fc50726f76696e7a20546162756b2c2053617564692d4172616269656e",hex"02387becffc71a5200bc4772616e61646120",hex"0137ecf902f9592200b552756220616c204b68616c69",hex"fe8fa9df081e283c000053696d70736f6e20446573657274",hex"ff2cd18efb718c7a014549736c612053616e2047616c6c616e2c2050657275",hex"fe9d8e0bfbce6eb9015441746163616d61",hex"020f2887f91d34d900a84d6f6a61766520446573657274",hex"fe7f8b490143e67000004b616c6168617269",hex"02a8ce5c066768c500b45a616769696e2075732c20476f62692c204d6f6e676f6c6569",hex"01a04ead01ae66bf00b3576869746520446573657274",hex"020f7f95f92eb79000e4436f6c6f7261646f205269766572",hex"017fed0c035bbcdb008d46756a6169726168",hex"001fadcb02b3082c00854d6f6761646973636875",hex"010336ae014d513200c34775656c7461206427204172636865692c20456e65646920506c61746561752c20547363686164",hex"012e8cd60128446f0115456d69204b6f75737369",hex"ffbddee400e80c0000644b696e7368617361",hex"0301e9eb01d201c500dc4b696576",hex"020f61b00247c464005d50616c6d797261",hex"03d701d1feffd1a2000c5661746e616a6f6b756c6c",hex"04c0b3bd00b01405003159747265204e6f72736b6f7961",hex"04eac61bfc48b0b7015d416c657274",hex"043dfdf70189784400044e6f72646b617070",hex"03d23601feb53c1101175265796b6a6176696b",hex"043fa25af6a7ce040152426172726f77",hex"040b29a90136d5ea01214b6972756e61",hex"fcbb75c2fbed6d8a013f55736875616961",hex"03c83cc308829b81001a4f796d79616b6f6e",hex"04f3f8cefbccd02e01654361706520436f6c756d626961",hex"01f9598b057c8513003951696e672d5a616e672d506c6174656175",hex"0256854a0452e8fd00b45472616e7361696c61692c2050616d6972204d6f756e7461696e73",hex"0227c832048278a4004a4b6172616b6f72756d",hex"02c631600079d53c00874a756e67667261756a6f6368",hex"01abdb0e052f7e6900e94d742045766572657374",hex"fc0c79350602883c00b2416c676165204c616b652c2042756e6765722048696c6c732c20416e7461726374696361",hex"0493c43e0401732b01434f7374726f762053657665726e796a2c20426172656e7473205365612c20527573736961",hex"029cc42b00a84717006c466972656e7a65",hex"0294e45300539d9c01014d61727365696c6c65",hex"030a254c00aced9900d65765696d6172",hex"02376b36faacfe3d00bd4d69737369737369707069205269766572",hex"036a47e5ffbb6b2400644c6f6368204e6973",hex"0365eace0294715100c7566f6c6761",hex"02b94b950186d8e400b45472616e73696c76616e6961",hex"ffbcbcaa06424a25000050726f76696e7a204c616d70756e672c20496e646f6e65736961",hex"fdcd7aec08a5e72b0029476f756c6275726e2052697665722c20566963746f7269612c204175737472616c6961",hex"031005e50066783700744475697362757267",hex"02fbc4fd012f8fed006d4b72616b6f77",hex"02d52ad70122a88a00524275646170657374",hex"02bf39d000dddf9f00dd4c6a75626c6a616e61",hex"02412761f8b25068007f53616e204672616e636973636f",hex"02602b79ffc2b99e0111546f6c65646f",hex"0230d55f0852410d00bc4e696b6b6f",hex"017e2d9f073df47f006c546169706568",hex"0199451f05f96aad015f4c696a69616e67",hex"016028bcfb16b1a80013486176616e6e61",hex"0113aa5f049456c2009f4b696e6773746f6e",hex"031f4920063624cc00b249726b7574736b",hex"03571a2f058a960d00c14b7261736e6f796172736b",hex"0347d1d204f075e600b14e6f766f7369626972736b",hex"030ce102f91c6d1b004a42616e6666",hex"02d63094fcdaedf9007453742e204a6f686e2773",hex"02b8db21fb9ece9900df4d6f6e747265616c",hex"03d1739af7afed9a0059446177736f6e",hex"03c19885f850570b00a24e616174732769686368276f68204e6174696f6e616c205061726b",hex"fed676b6fd776a81014249706174696e6761",hex"002b1663fc628a610118426f61205669737461",hex"ff0d7113fd2190fa004742726173696c6961",hex"ff4982a7010db698014b4375616e7a61",hex"02972f9c02835c85007a456c62727573",hex"0207a90c046e501000435372696e61676172",hex"010314a900796045006741676164657a",hex"00849753078ddb39012e5269622049726162696d2c2054696d6f722d4c65737465",hex"01207b1dfa2275c40126506f706f636174657065746c",hex"fcd5aa960460d41e004248656172642049736c616e64",hex"00d9a9160267423300e044616c6c6f6c",hex"00c12afd0338701900d24861646962752c2053757175747261",hex"fdca5ce0ff44ce5e000c5472697374616e2064612043756e6861",hex"fd6938be0a39ceaa002e52616b616961205269766572",hex"007c4df0fb5c3b5400ae5461706f6e2064656c2044617269656e",hex"03d44a15fceca7f500dd4e75756b",hex"01c3f369021b89f00086576164692052756d20",hex"01a4daa2055b4743013a50756e61205473616e672043687520",hex"02b7d22503c6aac301314261696b6f6e7572",hex"fe62913ef97ce95e001252617061204e7569",hex"02319855ff9ed865008d436f746f20646520446f6e616e61"];
            return bytes(motifs[index]);
        }

        function getHorizon(MotifType motifType) public pure returns (uint) {

            if (motifType == MotifType.BEACH) {
                return 310;
            }
            if (motifType == MotifType.SKYSCRAPER) {
                return 475;
            }
            if (motifType == MotifType.LANDSCAPE) {
                return 359;
            }
            return 0;
        }

        function getScene(MotifType motifType) public pure returns (SceneInMotif[] memory) {
            SceneInMotif[] memory sceneInMotif;
            if (motifType == MotifType.BEACH) {
                sceneInMotif = new SceneInMotif[](1);
                {
                        uint8[] memory assets = new uint8[](1);
                        assets[0] = 18;
                        sceneInMotif[0] = SceneInMotif("j", assets, [int(50), int(480), int(973), int(60)
                    ], 350);
                    }
            } else if (motifType == MotifType.SKYSCRAPER) {
               sceneInMotif = new SceneInMotif[](1);
                {
                        uint8[] memory assets = new uint8[](1);
                        assets[0] = 2;
                        sceneInMotif[0] = SceneInMotif("m", assets, [int(733), int(941), int(310), int(105)
                    ], 300);
                    }
            } else if (motifType == MotifType.LANDSCAPE) {
                sceneInMotif = new SceneInMotif[](1);
                {
                        uint8[] memory assets = new uint8[](1);
                        assets[0] = 2;
                        sceneInMotif[0] = SceneInMotif("1", assets, [int(861), int(954), int(211), int(40)
                    ], 300);
                    }
            }
            return sceneInMotif;

        }


 


        function getBeachTraits(uint index) public pure returns (BeachTraits memory) {



            BeachTraits memory beachTraits;
            uint256[2] memory beachColorIndexes = [41341480336443795834078175875216095607501858439471481496782762632714599867529,11988922190500];             
            string[6] memory beachColors = ["#ffa0e7","#9bb224","#4b3d66","#ffd700","#fff5bf","#ffdef6"];
            string [6] memory beachColorTraits = ["Pink", "Green", "Black", "Gold", "White", "Cream"];

            uint traitIndex = (index * 3) / 255;
            uint traitPos = (index * 3) % 255;



            uint beachColorIndex = beachColorIndexes[traitIndex] >> traitPos & 7;
            beachTraits.beachColor =  beachColors[beachColorIndex];
          
            string[5] memory shortsColors = ["#ac2532","#543e85","#2d8fab","#46ad47","#ad8430"];
            traitIndex = (index * 2) % 3;
            beachTraits.shortsColor = shortsColors[traitIndex];
            (string memory skinColor, string memory skinColorAttribute) = getSkinColor(index);
            beachTraits.skinColor = skinColor;
            string[4] memory towelColors = ["#662432","#462b73","#2d5c70","#507b3b"];
            traitIndex = (index * 2) % 3;
            beachTraits.towelColor = towelColors[traitIndex];

            beachTraits.attributes = string.concat(',{"trait_type":"Beach Color","value":"', beachColorTraits[beachColorIndex], '"}, {"trait_type":"Towel Color","value":"', beachTraits.towelColor, '"},{"trait_type":"Shorts Color","value":"', beachTraits.shortsColor, skinColorAttribute );

            return beachTraits;
        
        }


        function getSkinColor(uint index) public pure returns (string memory, string memory) {

            string[10] memory skinColors = ["#ffcabf","#ffcc99","#e6ae76","#cc8f52","#bb7f43","#966329","#925b2d","#7a4625","#ffcc73","#ffcc4d"];
            uint skinColorIndex = (index * 3) % 10;
            string memory skinColor = skinColors[skinColorIndex];
            string memory attribute = string.concat(',{"trait_type":"Skin Color","value":"', skinColor, '"}');
            return (skinColor, attribute);
        }


        function getCityTraits(uint index) public pure returns (CityTraits memory) {

            CityTraits memory cityTraits;


            address[5] memory priceFeedAddresses = [0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419,0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c,0xEC8761a0A73c34329CA5B1D3Dc7eD07F30e836e2,0x214eD9Da11D2fbe465a6fc601a91E62EbEc1a0D6,0x379589227b15F1a12195D3f2d90bBc9F31f95235];
            uint traitIndex = (index * 3 ) % 5;
            cityTraits.priceFeed = priceFeedAddresses[traitIndex];

            string[3] memory displays = ['Crystal Ball', 'Laptop', 'Clipboard'];
            traitIndex = (index * 2) % 3;

            cityTraits.displaySVG = string.concat("<use href='#", traitIndex == 0 ? "cr" : traitIndex == 1 ? "la" : "cl", "' />");

            uint cityTypes = 208949948408315176645400514316296940490473578437358986892907;
            cityTraits.skyLinetype = (cityTypes >> ((index) * 2)) & 3;

            string[4] memory skyLineTypes = ["mini","midi","large","mega"];
            for(uint i = 0; i < skyLineTypes.length; i++) {
                if (cityTraits.skyLinetype >= i) {
                    cityTraits.skylineSVG = string.concat("<use href='#", skyLineTypes[i], "' />", cityTraits.skylineSVG );
                }
            }
            uint coastelIndexes = 160480604047421108333616122368;
            cityTraits.isCoastel = (coastelIndexes & (1 << index)) != 0;
            cityTraits.attributes = string.concat( ',{"trait_type": "Display Device", "value": "', displays[traitIndex], '"},{"trait_type": "Skyline", "value": "', skyLineTypes[cityTraits.skyLinetype], '"},{"trait_type":"Coastel View","value":"', cityTraits.isCoastel ? "Yes" : "No", '"}');

            return cityTraits;
        }

        function getLandscapeTraits(uint index) public pure returns (LandscapeTraits memory ) {

            LandscapeTraits memory landscapeTraits;
            
            uint256[2] memory traits = [38567096731314568780641464313144695135602970097189989059279612274963869152067,4467654741599495210471749775461820980734155125];

            uint climateZones = 17140672472095896272335075615643983079201628415938079165600357;

            string[3] memory climateZoneTraits = ["Polar", "Temperate", "Desert"];
            string[3] memory climateZoneColors = ["#DFB2F7","#B9C966","#F9B233"];
            landscapeTraits.climateZoneIndex = (climateZones >> ((101-index) * 2)) & 3;
            landscapeTraits.climateZoneColor = climateZoneColors[landscapeTraits.climateZoneIndex];

            (string memory skinColor, string memory skinColorAttribute) = getSkinColor(index);
            landscapeTraits.skinColor = skinColor;

            uint traitIndex = (index * 4) / 256;
            uint traitPos = (index * 4) % 256;



            uint landscapeTrait = traits[traitIndex] >> traitPos & 15;
            landscapeTraits.hasCity = (landscapeTrait & 1) == 1;
            landscapeTraits.hasMountains = (landscapeTrait & 2) == 2;
            landscapeTraits.hasRiver = (landscapeTrait & 4) == 4;
            landscapeTraits.hasOcean = (landscapeTrait & 8) == 8;

            landscapeTraits.before = landscapeTraits.hasOcean ? "<use href='#l-o' />" : "";
            landscapeTraits.before = landscapeTraits.hasMountains ? "<use href='#l-m' />" : landscapeTraits.before;

            landscapeTraits.front = landscapeTraits.hasCity ? "<use href='#l-c' />" : "";
            landscapeTraits.front = landscapeTraits.hasRiver ? string.concat(landscapeTraits.front, "<use href='#l-r' />") : landscapeTraits.front;

            landscapeTraits.front =  landscapeTraits.climateZoneIndex == 0 ? string.concat(landscapeTraits.front, "<use href='#l-p' />") : landscapeTraits.front;
            landscapeTraits.front =  landscapeTraits.climateZoneIndex == 1 ? string.concat(landscapeTraits.front, "<use href='#l-t' />") : landscapeTraits.front;
            landscapeTraits.front =  landscapeTraits.climateZoneIndex == 2 ? string.concat(landscapeTraits.front, "<use href='#l-d' />") : landscapeTraits.front;

            string[4] memory shirtColors = ["#FF0000","#00FF00","#0000FF","#FFFF00"];
            landscapeTraits.shirtColor = shirtColors[index % shirtColors.length];
            string [4] memory pantsColors = ["#FF0000","#00FF00","#0000FF","#FFFF00"];
            landscapeTraits.pantsColor = pantsColors[index % pantsColors.length];

            string [4] memory hats = ["None","Cap","Hat","Headphones"];
            landscapeTraits.hat = hats[index % hats.length];




            string memory YES = "Yes";
            string memory NO = "No";

            landscapeTraits.attributes = string.concat(skinColorAttribute ,',{"trait_type":"City","value":"', landscapeTraits.hasCity ? YES : NO, '"},{"trait_type":"River","value":"',landscapeTraits.hasRiver ? YES :NO, '"},{"trait_type":"Mountains","value":"', landscapeTraits.hasMountains ?YES : NO, '"},{"trait_type":"Ocean","value":"',landscapeTraits.hasOcean ? YES : NO, '"},{"trait_type":"Climate Zone","value":"', climateZoneTraits[landscapeTraits.climateZoneIndex], '"}, {"trait_type":"Shirt Color","value":"', landscapeTraits.shirtColor, '"},{"trait_type":"Pants Color","value":"', landscapeTraits.pantsColor, '"}, {"trait_type":"Hat","value":"', landscapeTraits.hat, '"}');
            return landscapeTraits;

        }



    }