// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import { sqrt} from "@prb/math/src/Common.sol";
import "./solidity-trigonometry/Trigonometry.sol";
import "./solidity-trigonometry/InverseTrigonometry.sol";

contract SAM {
    uint256 constant J2000 = 2_451_545e18;
    uint256 constant J1970 = 2_440_588e18;
    uint256 constant T_REF = 21_958e18;
    uint256 constant T_CORR = 43e18;
    uint256 constant PI_E = 3_141592653589793238;
    uint256 constant PI2 = PI_E * 2;
    uint256 constant TO_RAD = 17453292519943296;
    uint256 constant TO_DEG = 57295779513224454144;


    function calculateSolarPosition(int256 _latitude, int256 _longitude)
        public
        view
        returns (int256, int256)
    {
    
        uint256 _timestamp = block.timestamp * 1e18;
        int256 _t = calcT(_timestamp);
        uint256 _deltaT = deltaT(_timestamp);
        int256 te = _t + int256((1_1574 * _deltaT) / 1e10);
        int256 lat_rad = (_latitude * int256(TO_RAD)) / 1e18;

        //call algo1
        (int256 hourAngle, int256 declination) = algo1(_t, te, _longitude);

        // call azimuthZenit
        (int256 azimuth, int256 zenith) = azimuthZenit(
            lat_rad,
            hourAngle,
            declination
        );

        return (azimuth, zenith);
    }

    function azimuthZenit(
        int256 lat_rad,
        int256 hourAngle,
        int256 declination
    ) public pure returns (int256, int256) {
        int256 sp;
        if (lat_rad < 0) {
            sp = Trigonometry.sin(uint256(lat_rad * -1)) * -1;
        } else {
            sp = Trigonometry.sin(uint256(lat_rad));
        }
        int256 oneSubSquareSP = 1e36 - sp * sp;
        uint256 cp = sqrt((uint256(oneSubSquareSP)));

        int256 _sd;
        if (declination < 0) {
            _sd = Trigonometry.sin(uint256(declination * -1)) * -1;
        } else {
            _sd = Trigonometry.sin(uint256(declination));
        }
        int256 oneSubsquareSD = 1e36 - _sd * _sd;

        uint256 cd = sqrt(uint256(oneSubsquareSD));

        int256 sH;
        int256 cH;
        if (hourAngle < 0) {
            sH = Trigonometry.sin(uint256(hourAngle * -1)) * -1;
            cH = Trigonometry.cos(uint256(hourAngle * -1));
        } else {
            sH = Trigonometry.sin(uint256(hourAngle));
            cH = Trigonometry.cos(uint256(hourAngle));
        }

        int256 se0 = (sp * _sd * 1e18 + int256(cp) * int256(cd) * cH) / 1e36;
        int256 squareSE0 = 1e36 - se0 * se0;
        int256 ep = InverseTrigonometry.arcsin(se0) -
            int256((426 * sqrt(uint256(squareSE0))) / 1e7);

        int256 x = (cH * sp) / 1e18 - (_sd * int256(cp)) / int256(cd);

        int256 azimuth = p_atan2(sH, x);
        int256 zenith = ep;
        // return (int(sH), x);
        return (
            int256(((int256(PI_E) + azimuth) * int256(TO_DEG)) / 1e18),
            int256((zenith * int256(TO_DEG)) / 1e18)
        );
    }

    function algo1(
        int256 _t,
        int256 te,
        int256 _longitude
    ) public pure returns (int256, int256) {
        int256 wte = (17_202_786 * te) / 1e9;

        int256 s1;
        int256 c1;
        if (wte < 0) {
            s1 = Trigonometry.sin(uint256(wte * -1)) * -1;
            c1 = Trigonometry.cos(uint256(wte * -1));
        } else {
            s1 = Trigonometry.sin(uint256(wte));
            c1 = Trigonometry.cos(uint256(wte));
        }

        int256 s2 = (2 * s1 * c1) / 1e18;
        int256 c2 = ((c1 + s1) * (c1 - s1)) / 1e18;

        int256 rightAscension = -13888 *
            1e14 +
            (17202792 * te) /
            1e9 +
            (3199 * s1) /
            1e5 -
            (265 * c1) /
            1e5 +
            (405 * s2) /
            1e4 +
            (1525 * c2) /
            1e5;

        rightAscension = rightAscension % int256(PI2);

        if (rightAscension < 0) {
            rightAscension += int256(PI2);
        }

        int256 declination = 657 *
            1e13 +
            (7347 * s1) /
            1e5 -
            (39919 * c1) /
            1e5 +
            (73 * s2) /
            1e5 -
            (66 * c2) /
            1e4;

        int256 hourAngle = 175283 *
            1e13 +
            (63003881 * _t) /
            1e7 +
            (_longitude * int256(TO_RAD)) /
            1e18 -
            rightAscension;

        hourAngle = ((hourAngle + int256(PI_E)) % int256(PI2)) - int256(PI_E);

        if (hourAngle < -int256(PI_E)) {
            hourAngle += int256(PI2);
        }
        return (hourAngle, declination);
    }

    function calcT(uint256 _timestamp) public pure returns (int256) {
        uint256 _days = (_timestamp / 86400 + J1970 - J2000);
        return (int256)(int256(_days) - int256(T_REF) + int256(T_CORR));
    }

    /* Between years 2015 and 3000, calculate:
	    ΔT = 67.62 + 0.3645 * t + 0.0039755 * t^2
	    where: t = y - 2015 
        */
    function deltaT(uint256 _timestamp) public pure returns (uint256) {
        uint256 t = ((_timestamp / 86400 + J1970 - J2000) * 1e2) /
            36525 -
            uint256(15 * 1e18);

        uint256 a1 = 6762 * 1e16;
        uint256 a2 = (3645 * t) / 1e4;
        uint256 a3 = (39755 * (t * t)) / 1e26;

        return a1 + a2 + a3;
        // return t;
    }

    function tan(uint x) public pure returns (int) {
        return Trigonometry.sin(x) * 1e18 / Trigonometry.cos(x);
    }


    //for moon calculation
    uint constant EARTH_OBLIQUITY = TO_RAD * 234397 / 1e14;

    function rightAscensionMoon(uint l, uint b) public pure returns (int) {

        int y = (Trigonometry.sin(l) * Trigonometry.cos(EARTH_OBLIQUITY) - tan(b) * Trigonometry.sin(EARTH_OBLIQUITY)) / 1e18;

        return p_atan2(y, Trigonometry.cos(l));
    }


    function declinationMoon(uint l, uint b) public pure returns (int) {
        int numerator = (Trigonometry.sin(b) * Trigonometry.cos(EARTH_OBLIQUITY) + (Trigonometry.cos(b) * Trigonometry.sin(EARTH_OBLIQUITY) * Trigonometry.sin(l) / 1e18))/1e18;
        return InverseTrigonometry.arcsin(numerator);
}

    function altitude(uint256 H, uint256 phi, uint256 dec) public pure returns (int256) {
            int256 term1 = (Trigonometry.sin(phi) * Trigonometry.sin(dec)) / 1e18;
            int256 term2 = (Trigonometry.cos(phi) * Trigonometry.cos(dec) * Trigonometry.cos(H)) / (1e18 * 1e18);
            int256 sum = term1 + term2;
            return InverseTrigonometry.arcsin(sum);
        }

    function azimuth(int256 H, uint256 phi, int256 dec) public pure returns (int256) {
    int256 sinH = Trigonometry.sin(uint256(H));
    int256 cosH = Trigonometry.cos(uint256(H));
    int256 sinPhi = Trigonometry.sin(phi);
    int256 cosPhi = Trigonometry.cos(phi);
    int256 tanDec = tan(uint256(dec));
    
    int256 x = (cosH * sinPhi - tanDec * cosPhi) / 1e18;
    
    return p_atan2(sinH, x);
}


    function sideRealTime(uint d, int lw) public pure returns (int) {
        uint x = 28016e16 + 3609856235 * d / 1e7;
        return (int(TO_RAD * x) - lw * 1e18) / 1e18 ;
    }

    function getMoonPosition(uint256 lat, uint256 lng, uint256 timestamp) public pure returns (int256, int256) {

      int lw = int(lng * TO_RAD)/ 1e18 * -1;
      uint phi  = lat * TO_RAD / 1e18;

      uint256 d = timestamp / 86400e18 + J1970 - 5e17 - J2000;

        (int ra, int dec, uint dt) = moonCoords(d);
        int H = sideRealTime(d, lw) - ra;
        int h = altitude(uint(H), phi, uint(dec));
        int x = tan(phi) * Trigonometry.cos(uint(dec)) - Trigonometry.sin(uint(dec)) * Trigonometry.cos(uint(H));
        int pa = p_atan2(Trigonometry.sin(uint(H)), x);
        int az = azimuth(H, phi, dec);

        return (az,h) ;
    }

    // getMoonIllumination() {}



    function moonCoords(uint256 d) public pure returns (int, int, uint) {

      uint L = TO_RAD * (218316e15 + 13176396 * d / 1e6) / 1e18;
      uint M = TO_RAD * (134963e15 + 13064993 * d / 1e6) / 1e18;
      uint F = TO_RAD  * (93272e15 + 13119350 * d / 1e6) / 1e18;
      int l = int(L) + (int(TO_RAD) * 6289e15 * Trigonometry.sin(M)) / 1e36;
      int b = int(TO_RAD) * 5128 * Trigonometry.sin(F) / 1e40;
      uint dt = uint(385001e18 - 20905 * Trigonometry.cos(M)); 

      int ra = rightAscensionMoon(uint(l), uint(b));
      int dec = declinationMoon(uint(l),uint(b));


      return (ra, dec, dt);
      

    }

    /// @notice ATAN2(Y,X) FUNCTION (MORE PRECISE MORE GAS)
    /// @param y y
    /// @param x x
    /// @return T T
    function p_atan2(int256 y, int256 x) public pure returns (int256 T) {
        int256 c1 = 3141592653589793300 / 4;
        int256 c2 = 3 * c1;
        int256 abs_y = y >= 0 ? y : -y;
        abs_y += 1e8;

        if (x >= 0) {
            int256 r = ((x - abs_y) * 1e18) / (x + abs_y);
            T = (1963e14 * r**3) / 1e54 - (9817e14 * r) / 1e18 + c1;
        } else {
            int256 r = ((x + abs_y) * 1e18) / (abs_y - x);
            T = (1963e14 * r**3) / 1e54 - (9817e14 * r) / 1e18 + c2;
        }
        if (y < 0) {
            return -T;
        } else {
            return T;
        }
    }

    


}
