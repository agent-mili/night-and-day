import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


export default buildModule("NaDDeployment", (m) => {
    // Deploye Bibliotheken
    const sunCalc = m.contract("SunCalc", []);
    const ndRenderer = m.contract("NDRenderer", []);
    const ndDecoder = m.contract("NDDecoder", []);
  
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
        NDRenderer: ndRenderer,
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
        NDRenderer: ndRenderer,
      },
      after:[ndMotifDataManager, genericMotifSVG, motif0, motif1, motif2]
    });
  
    return {
      sunCalc,
      ndRenderer,
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