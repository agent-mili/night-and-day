// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { sd, SD59x18, sqrt} from "@prb/math/src/SD59x18.sol";

/**
 * @title Arcsine calculator.
 * @author Md Abid Sikder
 *
 * @notice Calculates arcsine. Fuzz testing shows that relative error is always
 * smaller than 0.01%. Uses the polynomial approximation functions found in
 * https://dsp.stackexchange.com/a/25771, but chooses between them at x=0.4788
 * due to differences in the relative errors as can be seen here
 * https://www.desmos.com/calculator/wrfwjhythe
 *
 * @dev See the desmos link for what functions f and g in the code refer to.
 */
library InverseTrigonometry {

  SD59x18 constant PI = SD59x18.wrap(3_141592653589793238);
  SD59x18 constant ONE = SD59x18.wrap(1000000000000000000);
  SD59x18 constant TWO = SD59x18.wrap(2000000000000000000);

    SD59x18 constant a0 = SD59x18.wrap(1570728800000000000);
    // −0.2121144
    SD59x18 constant a1 = SD59x18.wrap(-212114400000000000);
    // 0.0742610
    SD59x18 constant a2 = SD59x18.wrap(74261000000000000);
    // −0.0187293
    SD59x18 constant a3 = SD59x18.wrap(-18729300000000000);

  function g(int256 _x) internal pure returns (int256) {
    SD59x18 sd_x = sd(_x);

    SD59x18 HALF_PI = PI.div(TWO);
  
    SD59x18 root =  sqrt(ONE.sub(sd_x));
    
    SD59x18 result =  HALF_PI - root.mul(a0.add(sd_x.mul(a1.add(sd_x.mul(a2.add(sd_x.mul(a3)))))));

    return result.unwrap();

  }

  function f(int256 _x) internal pure returns (int256) {

    SD59x18 sd_x = sd(_x);
    SD59x18 xSq = sd_x.mul(sd_x);

    // 1/6
    // https://www.wolframalpha.com/input?i=1%2F6
    // 0.1666666666666666666666666
    SD59x18 frac1Div6 = sd(166666666666666666);

    // 3/40
    // https://www.wolframalpha.com/input?i=3%2F40
    // 0.075
    SD59x18 frac3Div40 = sd(75000000000000000);

    // 15/336
    // https://www.wolframalpha.com/input?i=15%2F336
    // 0.044642857142857142857142857142
    SD59x18 frac15Div336= sd(44642857142857142);

    SD59x18 result = sd_x.mul(ONE.add(xSq.mul(frac1Div6.add(xSq.mul(frac3Div40.add(xSq.mul(frac15Div336)))))));

    return result.unwrap();
  }

  /**
     * @notice Arcsine function
     *
     * @param _x A integer with 18 fixed decimal points, where the whole part is bounded inside of [-1,1]
     *
     * @return The arcsine, with 18 fixed decimal points
     */
  function arcsin(int256 _x) internal pure returns (int256) {
    int256 DOMAIN_MAX = 1000000000000000000;
    int256 DOMAIN_MIN = -DOMAIN_MAX;
    require(_x >= DOMAIN_MIN && _x <= DOMAIN_MAX, 'InverseTrigonometry: DOMAIN');

    // arcsin is an odd function, so arcsin(-x) = -arcsin(x), so we can remove
    // the negative here for easier math
    bool isNegative = _x < 0;
    _x = isNegative ? -_x : _x;

    // 0.4788
    int256 CHOICE_LINE = 478800000000000000;

    int256 result = _x < CHOICE_LINE ? f(_x) : g(_x);

    return isNegative ? -result : result;
  }
}