pragma solidity ^0.8.20;


import { sqrt} from "@prb/math/src/Common.sol";
import "./solidity-trigonometry/Trigonometry.sol";
import "./solidity-trigonometry/InverseTrigonometry.sol";




library SunCalc {

    uint256 constant J2000 = 2_451_545e18;
    uint256 constant J1970 = 2_440_588e18;
    uint256 constant DAY_IN_SE = 86400000e18;
    uint256 constant T_REF = 21_958e18;
    uint256 constant T_CORR = 43e18;
    uint256 constant PI_E = 3_141592653589793238;
    uint256 constant PI2 = PI_E * 2;
    uint256 constant TO_RAD = 17453292519943296;
    uint256 constant TO_DEG = 57295779513224454144;
    uint256 constant J0 = 9*1e14;



    function toDays(uint timestamp) public pure returns (uint) {
        return timestamp / 86400  - 5e17 + J1970 - J2000;
    }

    function fromJulian(uint256 j) public pure returns (uint256) {
        return (j + 5e17 - J1970) * 86400;
    }

    function julianCycle(uint256 d, int256 lw) public pure returns (int256) {
        int256 cycle = int256(d) - int256(J0) -  (1e18 * lw / int256(PI2));

        // round to cloesest integer 
        uint remainder = uint(cycle) % 1e18;
        if (remainder > 5e17) {
            return cycle / 1e18 * 1e18 + 1e18;
        } 

        return cycle / 1e18 * 1e18;
    }

    //function approxTransit(Ht, lw, n) { return J0 + (Ht + lw) / (2 * PI) + n; }
    // implement in solidity
       function approxTransit(uint256 Ht, int256 lw, uint256 n) public pure returns (uint256) {
 
        int transit = (int(Ht) + lw ) * 1e18 / int(PI2) ;

        return uint(int(J0) + transit + int(n));
    }

     function solarTransitJ(uint256 ds, uint256 M, uint256 L) public pure returns (uint256) {
        uint256 term1 = uint(int(J2000) + int(ds) + (53*1e14 * Trigonometry.sin(M) / 1e18 )); // 0.0053 * 1e18
        int256 term2 = 69*1e14 * Trigonometry.sin(2 * L) / 1e18;

        return uint(int(term1) - term2);
    }

    function hourAngle(uint256 h, int256 phi, int256 d) public view returns (uint) {



        int256 sinH = Trigonometry.sin(h);

        int256 sinPhi = Trigonometry.sin(phi);

        int256 sinD = Trigonometry.sin(d);

        int256 cosPhi = Trigonometry.cos(phi);

        int256 cosD = Trigonometry.cos(d);


        // Berechnung des Stundenwinkels
        int256 numerator = sinH - sinPhi * sinD  / 1e18;

        int256 denominator = cosPhi * cosD / 1e18;


        int256 angle = InverseTrigonometry.arcsin(1e18 * numerator / denominator);

        angle = int(PI_E) / 2 - angle;


        return uint(angle);
    }


    function getSetJ(uint256 h, int256 lw, int256 phi, int256 dec, uint256 n, uint256 M, uint256 L) internal view returns (uint256) {
        uint256 w = hourAngle(h, phi, dec);


        uint256 a = approxTransit(w, lw, n);


        uint result =  solarTransitJ(a, M, L);

        return result;
    }



    //for moon calculation
    uint constant EARTH_OBLIQUITY = TO_RAD * 234397 / 1e4;

    function rightAscension(int l, int b) public pure returns (int) {

        int y = (Trigonometry.sin(l) * Trigonometry.cos(EARTH_OBLIQUITY) - tan(b) * Trigonometry.sin(EARTH_OBLIQUITY)) / 1e18;
        int cosL = Trigonometry.cos(l);
        return p_atan2(y, cosL);
    }


    function declination(int l, int b) public pure returns (int) {
        int numerator = (Trigonometry.sin(b) * Trigonometry.cos(EARTH_OBLIQUITY) + (Trigonometry.cos(b) * Trigonometry.sin(EARTH_OBLIQUITY) * Trigonometry.sin(l) / 1e18))/1e18;
        return InverseTrigonometry.arcsin(numerator);
}

    function altitude(int H, uint phi, int dec) public pure returns (int256) {
            int256 term1 = (Trigonometry.sin(phi) * Trigonometry.sin(dec)) / 1e18;
            int256 term2 = (Trigonometry.cos(phi) * Trigonometry.cos(dec) * Trigonometry.cos(H)) / 1e36;
            int256 sum = term1 + term2;
            return InverseTrigonometry.arcsin(sum);
        }

    function azimuth(int256 H, uint256 phi, int256 dec) public pure returns (int256) {
    int256 sinH = Trigonometry.sin(H);
    int256 cosH = Trigonometry.cos(H);
    int256 sinPhi = Trigonometry.sin(phi);
    int256 cosPhi = Trigonometry.cos(phi);
    int256 tanDec = tan(dec);
    
    int256 x = (cosH * sinPhi - tanDec * cosPhi) / 1e18;
    
    return p_atan2(sinH, x);
}


    function sideRealTime(uint d, int lw) public pure returns (int) {
        uint x = 28016e16 + 3609856235 * d / 1e7;
        return (int(TO_RAD * x) - lw * 1e18) / 1e18;
    }

     function getMoonPosition(int256 lat, int256 lng, uint256 timestamp) public pure returns (int256, int256, int) {

      int lw = lng * int(TO_RAD)/ 1e18 * -1;
      uint phi  = uint(lat * int(TO_RAD) / 1e18 + int(PI2));


      uint256 d = toDays(timestamp);

        (int ra, int dec, uint dt) = moonCoords(d);
        int H = sideRealTime(d, lw) - ra;
        int h = altitude(H, phi, dec);
        int x = (tan(phi) * Trigonometry.cos(dec) - Trigonometry.sin(dec) * Trigonometry.cos(H)) / 1e18;

        int pa = p_atan2(Trigonometry.sin(H), x);

        int az = azimuth(H, phi, dec);
        az = az * 180e18 / int(PI_E) + 180e18;
        az = az % 360e18;
        if (az<0) {
            az = az + 360e18;
        }
        int alt = h * 180e18 / int(PI_E);
        int angle = pa * 180e18 / int(PI_E);

        return (az,alt, angle) ;
    } 

    function getMoonIllumination(uint timestamp) public pure returns (int, int, int) {

        uint d = toDays(timestamp);
        (int raSun, int decSun) = sunCoords(d);
        (int raMoon, int decMoon, uint dtMoon) = moonCoords(d);
        uint sDist = 149598000 * 1e18; // distance from Earth to Sun in km
        int phi; 
        {
            int term1 = Trigonometry.sin(decSun) * Trigonometry.sin(decMoon)/ 1e18;
            int term2 = Trigonometry.cos(decSun) * Trigonometry.cos(decMoon) * Trigonometry.cos(raSun - raMoon) / 1e36;

            phi = int(PI_E) / 2 - InverseTrigonometry.arcsin(term1 + term2);
        }
       
        int inc = p_atan2(int(sDist) * Trigonometry.sin(phi) / 1e18, int(dtMoon) - int(sDist) * Trigonometry.cos(phi) / 1e18);
        int angle = p_atan2(Trigonometry.cos(decSun) * Trigonometry.sin(raSun - raMoon) / 1e18, (Trigonometry.sin(decSun) * Trigonometry.cos(decMoon) / 1e18 ) 
        - Trigonometry.cos(decSun) * Trigonometry.sin(decMoon) * Trigonometry.cos(raSun - raMoon) / 1e36);

        angle = angle * 180e18 / int(PI_E);
        int fraction = (1e18 + Trigonometry.cos(inc)) / 2;
        //int phase = 5 * 1e17 +  5 * 1e17 * inc  * ( angle < 0 ? -1 : int(1)) / int(PI_E);

        return (fraction, 0, angle);
    } 



    function moonCoords(uint256 d) public pure returns (int, int, uint) {

      uint L = TO_RAD * (218316e15 + 13176396 * d / 1e6) / 1e18;
      uint M = TO_RAD * (134963e15 + 13064993 * d / 1e6) / 1e18;
      uint F = TO_RAD  * (93272e15 + 13229350 * d / 1e6) / 1e18;
      int l = int(L) + (int(TO_RAD) * 6289e15 * Trigonometry.sin(M)) / 1e36;
      int b = int(TO_RAD) * 5128 * Trigonometry.sin(F) / 1e21;
      uint dt = uint(385001e18 - 20905 * Trigonometry.cos(M)); 

      int ra = rightAscension(l, b);
      int dec = declination(l,b);

      return (ra, dec, dt);
    }


    // Solar Mean Anomaly
    function solarMeanAnomaly(uint d) public pure returns (uint) {
        return TO_RAD * ((3575291 * 1e14) + (98560028 * d/ 1e8)) / 1e18;
    }

    // Ecliptic Longitude
    function eclipticLongitude(uint M) public pure returns (int) {

        int C1 = 19148 * Trigonometry.sin(M) / 1e4;
        int C2 = 2 * Trigonometry.sin(2 * M) / 1e2;
        int C3 = 3 * Trigonometry.sin(3 * M) / 1e4;
        int C = int(TO_RAD) * (C1+ C2 + C3) / 1e18;
        uint P = TO_RAD * 1029372 / 1e4;

        return int(M) + C + int(P + PI_E);
    }

    function sunCoords(uint d) public pure returns (int, int) {

    uint M = solarMeanAnomaly(d);
    int L = eclipticLongitude(M);
  
    int ra = rightAscension(L, 0);
    int dec = declination(L, 0);
    return (ra, dec);
    }

     //always returns the sunrise/sunset time enclosing the given date 
     //e.G. in the night we will have a past sunset and a future sunrise
     // in the day we have a past sunrise and a future sunset
     function getSunRiseSet(uint256 date, int256 lat, int256 lng) public view returns (uint256, uint256) {



        
       
        int lw = lng * int(TO_RAD)/ 1e18 * -1;


        int phi  = (lat * int(TO_RAD) / 1e18);


        uint256 d = toDays(date); 


        int256 n = julianCycle(d, lw);


        uint256 ds = approxTransit(0, lw, uint(n));


        uint256 M = solarMeanAnomaly(ds);

        int256 L = eclipticLongitude(M);

        int256 dec = declination(L, 0);


        uint256 Jnoon = solarTransitJ(ds, M, uint(L));


        uint256 Jset = getSetJ(0, lw, phi, dec, uint(n), M, uint(L));

        uint256 Jrise = Jnoon - (Jset - Jnoon);


        uint sunrise = fromJulian(Jrise);
        uint sunset = fromJulian(Jset);



        if (sunrise > date) {
            n -= 1e18;
        } else if (sunset < date) {
            n += 1e18;
        }
        ds = approxTransit(0, lw, uint(n));
        M = solarMeanAnomaly(ds);
        L = eclipticLongitude(M);
        dec = declination(L, 0);
        Jnoon = solarTransitJ(ds, M, uint(L));
        Jset = getSetJ(0, lw, phi, dec, uint(n), M, uint(L));
        if (sunrise > date) {
            sunset = fromJulian(Jset);
        } else if (sunset < date) {
            Jrise = Jnoon - (Jset - Jnoon);
            sunrise = fromJulian(Jrise);
        }


        return (sunrise, sunset);
    }


    function getPosition(int lat, int lng, uint256 timestamp) public pure returns (int256, int256) {

      int lw = lng * int(TO_RAD)/ 1e18 * -1;
      uint phi  = uint(lat * int(TO_RAD) / 1e18 + int(PI2));

      uint256 d = toDays(timestamp);
      (int ra, int dec) = sunCoords(d);
        int H = sideRealTime(d, lw) - ra;

        int az = azimuth(H, phi, dec) * 180e18 / int(PI_E) + 180e18;
        int al = altitude(H, phi, dec) * 180e18 / int(PI_E);

        return (az,al);

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




    function tan(int x) public pure returns (int) {
        int y =  Trigonometry.sin(x) * 1e18 / Trigonometry.cos(x);
        return y;
    }

    function tan(uint x) public pure returns (int) {
        return Trigonometry.sin(x) * 1e18 / Trigonometry.cos(x);
    }

}