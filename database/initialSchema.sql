CREATE TABLE IF NOT EXISTS SpeedTests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    testID TEXT NOT NULL,
    phoneID TEXT NOT NULL,
    uploadSpeed DECIMAL NOT NULL,
    downloadSpeed DECIMAL NOT NULL,
    latency INTEGER NOT NULL, -- in milliseconds
    jitter DECIMAL NOT NULL, -- in milliseconds
    packetLoss DECIMAL, -- in percentage (0-100), can be null if not run
    
    testStartTime DATETIME NOT NULL, -- in UTC, time the test started
    testDuration INTEGER NOT NULL, -- in milliseconds
    recievedTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
