// tests for SunCalc cointract

import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('SunCalc', function () {
    it('should return sun position', async function () {

        const [owner, otherAccount] = await ethers.getSigners();

        const SunCalc = await ethers.getContractFactory('SunCalc');
        const sunCalc = await SunCalc.deploy();
        const timestamp = BigInt(Date.now()) * BigInt(1e15);
        const latitude: BigInt = 29982406n * (10n ** 12n);
        const longitude: BigInt = 31132695n * (10n ** 12n);
        const sunPosition = await sunCalc.getPosition(latitude.toString(), longitude.toString(), timestamp.toString());
        console.log(Number(sunPosition[0] / 10n ** 14n) / 10000 , Number(sunPosition[1] / 10n ** 14n) / 10000) ;
        expect(sunPosition).to.be.a('array');
    }
    )

    xit ('should return moon position', async function () {

        const [owner, otherAccount] = await ethers.getSigners();

        const SunCalc = await ethers.getContractFactory('SunCalc');
        const sunCalc = await SunCalc.deploy();
        const timestamp = BigInt(1698407364000) * BigInt(1e18);
        const latitude: BigInt = 29982406n * (10n ** 12n);
        const longitude: BigInt = 31132695n * (10n ** 12n);
        const moonPosition = await sunCalc.getMoonPosition(latitude.toString(), longitude.toString(), timestamp.toString());
        console.log(moonPosition[0] / 10n ** 14n, moonPosition[1] / 10n ** 14n, Number(moonPosition[2] / 10n ** 14n) / 1e4 * 180 / Math.PI);
        expect(moonPosition).to.be.a('array');
    })

    xit ('should return moon illumination', async function () {

        const [owner, otherAccount] = await ethers.getSigners();

        const SunCalc = await ethers.getContractFactory('SunCalc');
        const sunCalc = await SunCalc.deploy();
        const timestamp = BigInt(1698407364000) * BigInt(1e18);
        const latitude: BigInt = 498787n * (10n ** 14n);
        const longitude: BigInt = 86469n * (10n ** 14n);
        const moonPosition = await sunCalc.getMoonIllumination(timestamp.toString());
        console.log(moonPosition);
        expect(moonPosition).to.be.a('array');
    })
});