const WebSocket = require('ws');
var roomTable = {};
var ws2roomTable = {};

const wss = new WebSocket.Server({ port: 8080 }, () => {
    console.log("Signaling server is now listening on port 8080")
});

// Broadcast to all.
wss.broadcast = (ws, data) => {
    wss.clients.forEach((client) => {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
            client.send(data);
        }
    });
};

// send to other peers.
wss.sendToPeer = (peers, ws, data) => {
    peers.forEach((client) => {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
            client.send(data);
        }
    });
};

wss.on('connection', (ws) => {
    console.log(`Client connected. Total connected clients: ${wss.clients.size}`)
    
    ws.onmessage = (message) => {
        const payload = JSON.parse(message.data);
        console.log("onmessage=>", payload.payload.roomId, "->", message.data + "\n");

        if(ws2roomTable[ws] == null)
        {
            if( roomTable[payload.payload.roomId] == null ) roomTable[payload.payload.roomId] = [ws];
            else roomTable[payload.payload.roomId].push(ws);
        }
        ws2roomTable[ws] = payload.payload.roomId;        
        console.log("onmessage=>count->",  roomTable[payload.payload.roomId].length+"\n");

        //wss.broadcast(ws, message.data);
        wss.sendToPeer(roomTable[payload.payload.roomId], ws, message.data);
    }

    ws.onclose = () => {
        console.log(`Client disconnected. Total connected clients: ${wss.clients.size}`)

        var roomId = ws2roomTable[ws];
        const index = roomTable[roomId].indexOf(ws);
        if (index > -1) {
            roomTable[roomId].splice(index, 1);
        }
        delete ws2roomTable[ws]
        console.log(`RoomID=${roomId}, count=${roomTable[roomId].length}`)
    }
});