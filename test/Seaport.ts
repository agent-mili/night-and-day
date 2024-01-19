import { expect } from 'chai';
import { ethers } from 'hardhat';


describe('Seaport', function () {
    xit('should return seaport location position', async function () {

        const [owner, otherAccount] = await ethers.getSigners();

        const Seaports = await ethers.getContractFactory('Seaports');
        const seaport = await Seaports.deploy();

       const locationHexString = "0x5343504f56ffb966c0034e50750137010124";
       
       const response = await seaport.decodeLocation(locationHexString);
         console.log(response);
       expect(response).to.be.a('array');
    }
    )

xit('should return all seaport locations', async function () {

    const [owner, otherAccount] = await ethers.getSigners();

    const Seaports = await ethers.getContractFactory('Seaports');
    const seaport = await Seaports.deploy();

   
   const response = await seaport.getAllLocations();
     console.log(response);
   expect(response).to.be.a('array');

})
});