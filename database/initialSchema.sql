CREATE TABLE IF NOT EXISTS SpeedTests (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    testID TEXT NOT NULL,
    phoneID TEXT NOT NULL,
    uploadSpeed DECIMAL(9, 2) NOT NULL,
    downloadSpeed DECIMAL(9, 2) NOT NULL,
    latency INTEGER NOT NULL, -- in milliseconds
    jitter DECIMAL(9, 2) NOT NULL, -- in milliseconds
    packetLoss DECIMAL(9, 2), -- in percentage (0-100), can be null if not run
    
    testStartTime DATETIME NOT NULL, -- in UTC, time the test started
    testDuration INTEGER NOT NULL, -- in milliseconds
    recievedTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    longitude DECIMAL(9,6) NOT NULL, -- location data
    latitude DECIMAL(8,6) NOT NULL,
    accuracy DECIMAL(9,2) NOT NULL -- in meters
);

CREATE TABLE IF NOT EXISTS PersonalData (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    phoneID TEXT NOT NULL,

    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    zip TEXT NOT NULL,

    recievedTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
