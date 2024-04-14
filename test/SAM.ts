
import { expect } from "chai";
import { ethers } from "hardhat";

import {
    time
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";

xdescribe("SAM", function () {
    xit("should return sun position", async function () {
        const [owner, otherAccount] = await ethers.getSigners();

        const SAM = await ethers.getContractFactory("SAM");
        const sam = await SAM.deploy();

        const latitude: BigInt = 498787n * (10n ** 14n);
        const longitude: BigInt = 86469n * (10n ** 14n);
        console.log(latitude.toString(), longitude.toString());
        console.log(await time.latest());
        const sunPosition = await sam.calculateSolarPosition(latitude.toString(), longitude.toString());
        console.log(sunPosition[0] / 10n ** 14n, sunPosition[1]/ 10n ** 14n );
        expect(sunPosition).to.be.a("array");
    }
    )

}
);