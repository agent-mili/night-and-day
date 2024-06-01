import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


export default buildModule("NaDDeployment", (m) => {
    // Deploye Bibliotheken
    const sunCalc = m.contract("SunCalc", []);
    const ndUtils = m.contract("NDUtils", []);
    const ndDecoder = m.contract("NDDecoder", []);

    const ndRenderer = m.contract("NDRenderer", [], {
      libraries: {
        NDUtils: ndUtils,
      },
    
    });

  
    // Deploye den GenericMotifs Contract
    const genericMotif = m.contract("GenericMotifs", []);
    const genericMotifSVG = m.contract("GenericMotifsSVG", []);
  
    // Deploye Motif Contracts
    const motif0 = m.contract("Motifs0", []);
    const motif1 = m.contract("Motifs1", []);
    const motif2 = m.contract("Motifs2", []);
  
    // Deploye NDMotifDataManager mit Verlinkung zur NDDecoder Bibliothek
    const ndMotifDataManager = m.contract("NDMotifDataManager", [
      genericMotif,
      genericMotifSVG,
      motif0,
      motif1,
      motif2,
    ], {
      libraries: {
        NDDecoder: ndDecoder,
        NDUtils: ndUtils,
      },
      after:[  genericMotif,
        genericMotifSVG,
        motif0,
        motif1,
        motif2]
    });
  
    // Deploye NAD mit Verlinkung zu SunCalc und NDRenderer
    const nandd = m.contract("NAD", [ndMotifDataManager], {
      libraries: {
        SunCalc: sunCalc,
        NDUtils: ndUtils,
        NDRenderer: ndRenderer,
      },
      after:[ndMotifDataManager, genericMotifSVG, motif0, motif1, motif2]
    });
  
    return {
      sunCalc,
      ndRenderer,
      ndUtils,
      ndDecoder,
      genericMotif,
      motif0,
      motif1,
      motif2,
      genericMotifSVG,
      ndMotifDataManager,
      nandd,
    };
  });