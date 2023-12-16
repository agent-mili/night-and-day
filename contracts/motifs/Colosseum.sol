
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;
import "../BasicMotif.sol";




library Colosseum {

    //string constant svg = '<g fill="#9400E3"><path d="M-12-17.5h24V5.6h-24z"/><circle cy="5.5" r="12"/></g><path fill="#FAC15C" d="m3 728 1118-132-7-225L8 352z"/><g fill="#D499F4"><path d="M0 333h99v87H0z"/><path d="M-9 313h41v87H-9zM94 360h32v29H94zM148 346h54v44h-54zM876 346h95v96h-95zM998 315h44v75h-44zM1042 330h44v75h-44z"/><path d="M933 311h38v42h-38zM858 304h54v44h-54z"/></g><path fill="#F9B233" d="M0 389h1080v691H0z"/><path fill="#FAC15C" d="M1085 1034-7 906v311h1092z"/><path fill="#FAC15C" d="M1098 761-20 629l7-208 1106-19z"/><path fill="#FAC15C" d="m179 972 942-188-46-39-942 187z"/><path fill="#D499F4" d="m706 785 4 12 101-17-4-12z"/><path fill="#F28D00" d="m780 913 279 38-3 31-280-38z"/><path fill="#FDE0AD" d="m264 866 264-53 5 21-264 53z"/><path fill="#F9B233" d="m-199 560 598-122h-714l116 122z"/><path fill="#F9B233" d="M1554 600 956 478h714l-116 122z"/><g><g fill="#B959ED"><path d="m296 253-20-1 6 126h23zM273 180l-35-5v130h38z"/><path d="m252 117-16-2v130h21z"/></g><g fill="#EACCF9"><path d="M179 318h721v216H179z"/><path d="m179 549 137 28 198 10 241-10 145-24v-24H179zM236 326l95-22 503 4 66 10z"/><path d="m179 444 9-303 48-26 2 60 21 10v61l21 7v201zM403 447h435V208l-126-25-129-10-180 5z"/><path d="M313 266h128v69H313z"/><path d="M313 246h35v31h-35z"/></g><path fill="#B959ED" d="M464 354h-45l13 231h45zM326 383h-23l14 195h23zM448 349h-33l-7-61h32z"/><g fill="#9400E3"><path d="M468 191h19v37h-19zM551 189h19v37h-19zM635 215h19v37h-19zM670 270h19v37h-19zM712 223h19v37h-19zM755 239h19v37h-19zM191 314h12v64h-12zM204 156h10v26h-10zM204 207h21v59h-21z"/></g><!--round--></g><g id="a"><g fill="#9BB224"><path d="M-64 828h368v-61H-64z"/><ellipse cx="205" cy="767" rx="99" ry="61"/><ellipse cx="34" cy="764" rx="99" ry="63"/><ellipse cx="122" cy="689" rx="113" ry="90"/></g><path fill="#AA7035" d="M82 896h35l44-70h-35z"/><path fill="#AA7035" d="M124 854h-12l-19-27h12z"/></g><use href="#a" transform="matrix(.63 0 0 .63 318 265)"/><use href="#a" transform="matrix(.92 0 0 .92 924 46)"/>';
    
    
    
    bytes constant roundByteData = hex"032A010B00B90208015700F700860174006F00670073006D0063005E0052004B0045003B003800380036003500340033003200310030002F002F002E002D002C002B002A00290028012B00F2011800E7010600D501F400C301EA00B101E000A201D6009301CC008401C2007501B8006601AE005800A4004B009E003E0098003300920028008C001D0086001200800007007A00FB007500F4006F00ED006900E6006300DF005D00D8005700D1005100CA004B00C4004500BD003F00B7003900B1003300AB002D00A50027009F00";
//    bytes constant treeBytes = hex"013E0109003F039C002E005C";
    
   // bytes constant rectData = '0033015700D10057005E00A00057005E00D8001600410057005E0022001D0057005E00A80016002C002200160028001900220016001C00120016001D002200160016001200220016001C0022001600120010001A0016002200';

    
    int32 constant lat = 30_044_419;
    int32 constant lng = 31_235_647;
    uint16 constant lookingDirection = 0;
    uint16 constant horizont = 350;
    string constant name = "collosseum";
    MotifType constant motifType = MotifType.SightSeeing;
    function getMotif() internal pure returns (Motif memory) {

                 Replacement memory treeReplacement = Replacement({
                tag: ObjectType.USE,
                dataType: RenderDataType.POSISTIONSANDSCALE,
                data: hex"013E0109003F039C002E005C",
                placeholder: "tree",
                ref: "tree"
                 }); 

       /*    Replacement memory rects = Replacement({
            tag: ObjectType.RECT,
            dataType: RenderDataType.POSITIONSANDTWOSCALES,
            data: '0033015700D10057005E00A00057005E00D8001600410057005E0022001D0057005E00A80016002C002200160028001900220016001C00120016001D002200160016001200220016001C0022001600120010001A0016002200',
            placeholder: "rect",
            ref: "rect"
            }); */
    
    


            Replacement memory roundReplacement = Replacement({
            tag: ObjectType.USE,
            dataType: RenderDataType.POSITIONSANDTWOSCALES,
            data: roundByteData,
            placeholder: "round",
            ref: "round"
            }); 
            

             Motif memory motif = Motif({
            tokenId:1, /* tokenId-Wert */
            name: name,
            lat: lat,
            lng: lng,
            lookingDirection: lookingDirection,
            horizon: horizont,
            svg: '<g fill="#9400E3"><path d="M-12-17.5h24V5.6h-24z"/><circle cy="5.5" r="12"/></g><path fill="#FAC15C" d="m3 728 1118-132-7-225L8 352z"/><g fill="#D499F4"><path d="M0 333h99v87H0z"/><path d="M-9 313h41v87H-9zM94 360h32v29H94zM148 346h54v44h-54zM876 346h95v96h-95zM998 315h44v75h-44zM1042 330h44v75h-44z"/><path d="M933 311h38v42h-38zM858 304h54v44h-54z"/></g><path fill="#F9B233" d="M0 389h1080v691H0z"/><path fill="#FAC15C" d="M1085 1034-7 906v311h1092z"/><path fill="#FAC15C" d="M1098 761-20 629l7-208 1106-19z"/><path fill="#FAC15C" d="m179 972 942-188-46-39-942 187z"/><path fill="#D499F4" d="m706 785 4 12 101-17-4-12z"/><path fill="#F28D00" d="m780 913 279 38-3 31-280-38z"/><path fill="#FDE0AD" d="m264 866 264-53 5 21-264 53z"/><path fill="#F9B233" d="m-199 560 598-122h-714l116 122z"/><path fill="#F9B233" d="M1554 600 956 478h714l-116 122z"/><g><g fill="#B959ED"><path d="m296 253-20-1 6 126h23zM273 180l-35-5v130h38z"/><path d="m252 117-16-2v130h21z"/></g><g fill="#EACCF9"><path d="M179 318h721v216H179z"/><path d="m179 549 137 28 198 10 241-10 145-24v-24H179zM236 326l95-22 503 4 66 10z"/><path d="m179 444 9-303 48-26 2 60 21 10v61l21 7v201zM403 447h435V208l-126-25-129-10-180 5z"/><path d="M313 266h128v69H313z"/><path d="M313 246h35v31h-35z"/></g><path fill="#B959ED" d="M464 354h-45l13 231h45zM326 383h-23l14 195h23zM448 349h-33l-7-61h32z"/><g fill="#9400E3"><path d="M468 191h19v37h-19zM551 189h19v37h-19zM635 215h19v37h-19zM670 270h19v37h-19zM712 223h19v37h-19zM755 239h19v37h-19zM191 314h12v64h-12zM204 156h10v26h-10zM204 207h21v59h-21z"/></g><!--round--></g><g id="a"><g fill="#9BB224"><path d="M-64 828h368v-61H-64z"/><ellipse cx="205" cy="767" rx="99" ry="61"/><ellipse cx="34" cy="764" rx="99" ry="63"/><ellipse cx="122" cy="689" rx="113" ry="90"/></g><path fill="#AA7035" d="M82 896h35l44-70h-35z"/><path fill="#AA7035" d="M124 854h-12l-19-27h12z"/></g><!--t-->', // Ihr langer SVG-String
            scenes: new SceneInMotif[](0), // Initialisierung mit einer leeren Array, wenn nötig
            replacements: new Replacement[](2),
            motifType: motifType
        });

 /*            Motif memory motif;
            {
            motif.horizon = horizont;
            motif.lat = lat;
            motif.lng = lng;
            motif.lookingDirection = lookingDirection;
            motif.name = name;
            motif.svg = '<g fill="#9400E3"><path d="M-12-17.5h24V5.6h-24z"/><circle cy="5.5" r="12"/></g><path fill="#FAC15C" d="m3 728 1118-132-7-225L8 352z"/><g fill="#D499F4"><path d="M0 333h99v87H0z"/><path d="M-9 313h41v87H-9zM94 360h32v29H94zM148 346h54v44h-54zM876 346h95v96h-95zM998 315h44v75h-44zM1042 330h44v75h-44z"/><path d="M933 311h38v42h-38zM858 304h54v44h-54z"/></g><path fill="#F9B233" d="M0 389h1080v691H0z"/><path fill="#FAC15C" d="M1085 1034-7 906v311h1092z"/><path fill="#FAC15C" d="M1098 761-20 629l7-208 1106-19z"/><path fill="#FAC15C" d="m179 972 942-188-46-39-942 187z"/><path fill="#D499F4" d="m706 785 4 12 101-17-4-12z"/><path fill="#F28D00" d="m780 913 279 38-3 31-280-38z"/><path fill="#FDE0AD" d="m264 866 264-53 5 21-264 53z"/><path fill="#F9B233" d="m-199 560 598-122h-714l116 122z"/><path fill="#F9B233" d="M1554 600 956 478h714l-116 122z"/><g><g fill="#B959ED"><path d="m296 253-20-1 6 126h23zM273 180l-35-5v130h38z"/><path d="m252 117-16-2v130h21z"/></g><g fill="#EACCF9"><path d="M179 318h721v216H179z"/><path d="m179 549 137 28 198 10 241-10 145-24v-24H179zM236 326l95-22 503 4 66 10z"/><path d="m179 444 9-303 48-26 2 60 21 10v61l21 7v201zM403 447h435V208l-126-25-129-10-180 5z"/><path d="M313 266h128v69H313z"/><path d="M313 246h35v31h-35z"/></g><path fill="#B959ED" d="M464 354h-45l13 231h45zM326 383h-23l14 195h23zM448 349h-33l-7-61h32z"/><g fill="#9400E3"><path d="M468 191h19v37h-19zM551 189h19v37h-19zM635 215h19v37h-19zM670 270h19v37h-19zM712 223h19v37h-19zM755 239h19v37h-19zM191 314h12v64h-12zM204 156h10v26h-10zM204 207h21v59h-21z"/></g><!--round--></g><g id="a"><g fill="#9BB224"><path d="M-64 828h368v-61H-64z"/><ellipse cx="205" cy="767" rx="99" ry="61"/><ellipse cx="34" cy="764" rx="99" ry="63"/><ellipse cx="122" cy="689" rx="113" ry="90"/></g><path fill="#AA7035" d="M82 896h35l44-70h-35z"/><path fill="#AA7035" d="M124 854h-12l-19-27h12z"/></g><!--t-->';
            motif.motifType = motifType;
            motif.replacements = new Replacement[](2);
            motif.replacements[0] = roundReplacement;
            motif.replacements[1] = treeReplacement;
            } */

            motif.replacements[0] = roundReplacement;
            motif.replacements[1] = treeReplacement;
           //  motif.replacements[2] = treeReplacement2;
            
            return motif;


    }
    

}
    
