CREATE TABLE IF NOT EXISTS SpeedTests (
    id INTEGER PRIMARY KEY, -- will need to be unique but we can be a little lax with assignment
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

CREATE TABLE IF NOT EXISTS PersonalData (
    id INTEGER PRIMARY KEY,
    phoneID TEXT NOT NULL,

    longitude DECIMAL NOT NULL,
    latitude DECIMAL NOT NULL,
    accuracy DECIMAL NOT NULL,
    altitude DECIMAL NOT NULL,
    speed DECIMAL NOT NULL,
    heading DECIMAL NOT NULL,

    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    zip TEXT NOT NULL,

    recievedTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
