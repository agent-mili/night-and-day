// test getMotif from Cairo.sol contract

import { ethers } from "hardhat";
import { expect } from "chai";


xdescribe("Cairo", function () {
    xit("Should return a motif", async function () {
        const [owner, otherAccount] = await ethers.getSigners();

        const Cairo = await ethers.getContractFactory("Cairo");
        const cairo = await Cairo.deploy();

        const motif = await cairo.getMotif();
        console.log(motif);
        expect(motif).to.be.a("array");
    })
});