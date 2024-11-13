const { ethers } = require("ethers");
const WebSocket = require("ws");

// Infura und Contract-Konfiguration
const INFURA_PROJECT_ID = "YOUR_INFURA_PROJECT_ID";
const CONTRACT_ADDRESS = "0xYourContractAddress";
const CONTRACT_ABI = [
  "function tokenURI(uint256 tokenId) public view returns (string)"
];

const wsProvider = new ethers.providers.WebSocketProvider(`wss://mainnet.infura.io/ws/v3/${INFURA_PROJECT_ID}`);
const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wsProvider);

// WebSocket-Server für alle Ereignisse
const wsServer = new WebSocket.Server({ port: 8080 });
const clients = new Map(); // Speichert Clients mit ihren Abonnements
let cachedTokenURIs = [];
let currentBlockNumber = null;

// Funktion zum Abrufen und Zwischenspeichern von tokenURIs
async function updateTokenURIs(blockNumber) {
  try {
    const newTokenURIs = [];

    for (let i = 0; i < 4; i++) {
      const tokenId = i;
      const tokenURI = await contract.tokenURI(tokenId);
      newTokenURIs.push({ tokenId, tokenURI });
    }

    cachedTokenURIs = newTokenURIs;
    currentBlockNumber = blockNumber;

    // Sende die neuen tokenURIs nur an die abonnierten Clients
    broadcastToSubscribedClients("tokenURI", { tokenURIs: cachedTokenURIs });
    console.log("Token URIs aktualisiert:", cachedTokenURIs);

  } catch (error) {
    console.error("Fehler beim Abrufen der Token URIs:", error);
  }
}

// Funktion zum Senden an abonnierte Clients
function broadcastToSubscribedClients(type, data) {
  clients.forEach((subscriptions, client) => {
    if (client.readyState === WebSocket.OPEN && subscriptions.has(type)) {
      client.send(JSON.stringify({ type, ...data }));
    }
  });
}

// Wenn ein neuer Block entdeckt wird, aktualisiere Blocknummer und tokenURIs
wsProvider.on("block", async (blockNumber) => {
  console.log("Neuer Block:", blockNumber);

  // Blocknummer an abonnierte Block-Clients senden
  broadcastToSubscribedClients("block", { blockNumber });

  // Aktualisiere und sende die tokenURIs
  await updateTokenURIs(blockNumber);
});

// WebSocket-Server für Clients
wsServer.on("connection", (ws) => {
  console.log("Neuer Client verbunden.");
  clients.set(ws, new Set()); // Erstelle ein leeres Abonnement-Set für den neuen Client

  // Empfang von Abonnement-Nachrichten vom Client
  ws.on("message", (message) => {
    const { action, type } = JSON.parse(message);

    if (action === "subscribe") {
      clients.get(ws).add(type);
      console.log(`Client hat ${type} abonniert.`);
    } else if (action === "unsubscribe") {
      clients.get(ws).delete(type);
      console.log(`Client hat ${type} abbestellt.`);
    }

    // Initiale Daten senden, wenn der Client abonniert
    if (type === "block" && action === "subscribe" && currentBlockNumber) {
      ws.send(JSON.stringify({ type: "block", blockNumber: currentBlockNumber }));
    }
    if (type === "tokenURI" && action === "subscribe" && cachedTokenURIs.length > 0) {
      ws.send(JSON.stringify({ type: "tokenURI", tokenURIs: cachedTokenURIs }));
    }
  });

  // Entferne Client bei Verbindungsabbruch
  ws.on("close", () => {
    console.log("Client getrennt.");
    clients.delete(ws);
  });

  ws.on("error", (error) => {
    console.error("Client WebSocket Fehler:", error);
  });
});

console.log("WebSocket-Server läuft auf ws://localhost:8080");
