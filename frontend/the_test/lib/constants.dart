// const String SERVER_IP="http://www.ethohampton.com/1kb_file.txt";
// const String SERVER_IP="https://www.google.com";
const String SERVER_IP="8.8.8.8";
const int PORT = 53;
const int NUMBER_OF_SERVERS = 1;
const List<String> SERVER_IP_LIST = ['8.8.8.8'];
const int NUMBER_OF_PINGS_TO_SEND_INITIAL = 1;
const int NUMBER_OF_PINGS_TO_SEND_JITTER = 100;
//used the max value for flutter web instead of the 64 version
const int MAX_INITIAL_PING = 9007199254740991;


//Homepage

const String HOMEPAGE_IMAGE_URL = 'https://images.pexels.com/photos/53504/grass-rush-juicy-green-53504.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';



//Results
const COLUMN_TITLES_RESULTS = ['Date', 'Download', 'Upload', 'Jitter', 'Latency', 'Packet Loss', 'Total Test Duration'];
const String SERVER_RESULT_REQUEST_URL = '/api/v0/getSpeedTestResults/';

//jitter, packet loss, latency
const int UDP_PACKETS_TO_SEND_JITTER = 200;
const int UDP_PACKET_SIZE  = 160;
const int ACK_RECEIVE_WAIT_TIME = 2;
const int ACCEPTED_RESPONSE_WINDOW = 5;
const int SERVER_PORT = 80;
const int RECIEVER_PORT = 65001;
const int SENDER_PORT = 65000;
const String DATA = 'oaiwejoiawejfoiajwoief';


//download and upload
const String SERVER_TEST_UPLOAD_URL = '/api/v0/submitSpeedTest';
const String FILE_PATH1 = '/downloads/file1';
const String FILE_PATH2 = '/downloads/file2';
const String FILE_PATH3 = '/downloads/file3';