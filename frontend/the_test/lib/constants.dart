// const String SERVER_IP="http://www.ethohampton.com/1kb_file.txt";
// const String SERVER_IP="https://www.google.com";
const String BACKEND_SERVER = '54.218.174.61';
const List<String> PING_SERVER_LIST = ['8.8.8.8', '1.1.1.1'];
const int NUMBER_OF_PINGS_TO_SEND_INITIAL = 1;
const int NUMBER_OF_PINGS_TO_SEND_JITTER = 1;
//used the max value for flutter web instead of the 64 version
const int MAX_INITIAL_PING = 9007199254740991;

//Homepage
const String HOMEPAGE_IMAGE_URL =
    'https://images.pexels.com/photos/53504/grass-rush-juicy-green-53504.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';

//Image urls
//https://media0.giphy.com/media/qGVrkvB0rDFcY/giphy.gif?cid=790b7611b4842f11a8e50307e6a08bf507c28b8193e5386f&rid=giphy.gif&ct=g
//https://media2.giphy.com/media/3og0ILgFOEXIL8Bsn6/giphy.gif?cid=790b76118a41395f76dafb1d468c8320127c688f1260adbb&rid=giphy.gif&ct=g

//Results
const COLUMN_TITLES_RESULTS = [
  'Date',
  'Down',
  'Up',
  'Jitter',
  'Latency',
  'Loss'
];
const String SERVER_RESULT_REQUEST_URL =
    'http://54.218.174.61:8080/api/v0/getSpeedTestResults/';
const String TEST_ID_FOR_TESTING = '072a0aa184427ef8';
const String SERVER_UPLOAD_URL_TEXT =
    'http://54.218.174.61:8080/api/v0/submitSpeedTest';
const String SERVER_ACCESS_PORT = '8080';

//jitter, packet loss, latency
const int UDP_PACKETS_TO_SEND_JITTER = 200;
const int UDP_PACKET_SIZE = 160;
const int ACK_RECEIVE_WAIT_TIME = 2;
const int ACCEPTED_RESPONSE_WINDOW = 5;
const int SERVER_PORT = 80;
const int RECIEVER_PORT = 65001;
const int SENDER_PORT = 65000;
const int UDP_SEND_PORT = 8372;
const String DATA =
    '0BY50D74GeozhLT20gICzl8TEN60mXU2G5wqRWjF2UTMBw55BkJLkQkNX08b6lnO5TO91dGqb30vChbfh4B5G478GI495bLZPx984ye3V445726bvODA2QwVz9Mg0r37508Utcl2fcFvTE9';

//download and upload
const String SERVER_TEST_UPLOAD_URL = '/api/v0/submitSpeedTest';
const String FILE_PATH1 = '/downloads/file1';
const String FILE_PATH2 = '/downloads/file2';
const String FILE_PATH3 = '/downloads/file3';


const String PERSONAL_INFO_UPLOAD_URL = 'http://54.218.174.61:8080/api/v0/submitPersonalInfo';
const String PERSONAL_INFO_DOWNLOAD_URL = 'http://54.218.174.61:8080/api/v0/getPersonalInfo/eventuallyIDHe';
//screen item sizes
const double SPACER_BOX_HEIGHT = .04;
