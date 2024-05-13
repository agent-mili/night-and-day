
import { expect } from "chai";
import { ethers } from "hardhat";



describe("NAD", function () {

    xit("should render light house", async function () {
        const [owner, otherAccount] = await ethers.getSigners();
      

        
         // deploy linked libraries (SunCalc and NDRenderer) and link them to NAD contract
         const ndRenderer = await ethers.deployContract("NDRenderer");
       
         await ndRenderer.waitForDeployment();
             
        const timestamp = BigInt(Date.now()) / BigInt(1e3);
        const lightHouse = await ndRenderer.renderLighthouse("<!--light-->", -100 , timestamp.toString());
        console.log(lightHouse);
        expect(lightHouse).to.be.a("string");
      
      
      
      });
    });

