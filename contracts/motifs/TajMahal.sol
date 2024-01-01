

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;
import "../BasicMotif.sol";



library TajMahal {

    int32 constant lat = 27_175_016;
    int32 constant lng = 78_042_104;

    uint16 constant lookingDirection = 0;
    uint16 constant horizont = 350;

    string constant name = "tajmahal";

    MotifType constant motifType = MotifType.SightSeeing;

  



   function getMotif() internal pure returns (Motif memory) {

   


    Motif memory motif = Motif({
        tokenId: 2, 
        name: name,
        lat: lat,
        lng: lng,
        lookingDirection: lookingDirection,
        horizon: horizont,
        svg:'<defs><pattern id="b" width="450" height="460" y="1080" overflow="visible" patternUnits="userSpaceOnUse" viewBox="130 -462.5 450 460"><path fill="none" d="M130-462.5h450v460H130z"/><path fill="#FCD899" d="M450-120h260v5H450zM225-5h260v5H225zM0-120h260v5H0zM450-350h260v5H450zM225-235h260v5H225zM0-350h260v5H0zM225-465h260v5H225z"/></pattern><path id="a" fill="#FDE0AD" d="M43-37 0 37l-43-74z"/><g id="d" fill="#BF66EE" transform="scale(1 -1)"><path d="M-12-17.5h24v23h-24z"/><circle cy="5.5" r="12"/></g></defs><g><use href="#a" transform="matrix(3.4021 0 0 -.4027 -13.592 495.788)"/><use href="#a" transform="matrix(6.5198 0 0 -.6388 278.052 486.935)"/><use href="#a" transform="matrix(6.5198 0 0 -.7233 955.918 483.765)"/></g><g><path fill="#FAC15C" d="M-4.5 505.9h1089V1080H-4.5z"/><path fill="#FFE766" d="M-23.3 514.9h1126.6V540H-23.3zM621.9 540H458.1l-1295.7 604.4h2755.2z"/><path fill="#F9B233" d="M576.1 540h-72.2l-570.6 604.4h1213.4z"/><pattern id="c" href="#b" patternTransform="translate(2249.986 2600.028)"/><path fill="url(#c)" d="M576.1 540h-72.2l-570.6 604.4h1213.4z"/><path fill="#FFE766" d="M-72.7 659.7 354.4 540H287l-359.7 59.3zM1152.7 659.7 725.6 540H793l359.7 59.3z"/></g><g><ellipse cx="540.3" cy="254.8" fill="#BF66EE" rx="70.7" ry="84.6"/><g fill="#EACCF9"><path d="M364 357h351v131H364z"/><path d="M469 281h142v153H469z"/><path d="M457 327h165v160H457z"/></g><!--turet--><!--roof--><path fill="#C980F1" d="M201 487h678v36H201z"/><path fill="#D499F4" d="M483 352h113v135H483z"/><path fill="#A933E9" d="M500 412h80v76h-80z"/><circle cx="540" cy="411" r="40" fill="#A933E9"/><use href="#d" transform="matrix(1.11 0 0 1.11 540 468)"/><g fill="#9400E3"><circle cx="540.2" cy="123.5" r="6.8"/><circle cx="540.2" cy="153.6" r="6.8"/><circle cx="540.2" cy="138.7" r="9.6"/></g><!--ture2--><!--bush--></g>',
        scenes: new SceneInMotif[](1),
        motifType: motifType

    });


/*     motif.replacements[0] = bushReplacement;
    motif.replacements[1] = turretReplacement;
    motif.replacements[2] = roofReplacement;
    motif.replacements[3] = trurret2Replacement; */

    return motif;
   }

    

}