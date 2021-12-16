# API Design

There are several main events that we need to deal with between the backend and app:

- Speed test
- Document data capture (photo of bill and other information)
- Submit challenge request (if consumer feels like they aren't getting the speeds they requested)
- Get challenge status (this could be several sub-queries, but can be filled out as we learn more)



Speed test data will look very similar to the FCC data:

```json
{
  "metadata" : {
    "app_version" : "v4.2.0 b1"
  },
  "device_environment" : {
    "operating_system_version" : "iOS 15.0.2",
    "manufacturer" : "Apple",
    "model" : "iPhone11,8",
    "operating_system" : "iOS",
    "os_version" : "15.0.2",
    "carrier_name" : "Verizon"
  },
  "tests" : {
    "Latency" : {
      "referenceNumber" : "3295208592",
      "testServer" : "Seattle, US",
      "latitude" : 44.xxxx,
      "testProvider" : "Comcast Cable",
      "PacketLoss" : {
        "referenceNumber" : "3295208592",
        "timestamp" : 1635018907.10166,
        "utc_datetime" : "2021-10-23T19:55:06Z",
        "testIndex" : 0,
        "local_datetime" : "2021-10-23T12:55:06-07:00",
        "testResult" : 0,
        "success" : true,
        "isWiFi" : true,
        "testServer" : "Seattle, US"
      },
      "testResult" : 17.702747474747472,
      "testNetwork" : "********",
      "isWiFi" : true,
      "longitude" : -123.xxxx,
      "utc_datetime" : "2021-10-23T19:55:06Z",
      "local_datetime" : "2021-10-23T12:55:06-07:00",
      "timestamp" : 1635018907.1016378,
      "success" : true,
      "testIndex" : 0,
      "Jitter" : {
        "testIndex" : 0,
        "timestamp" : 1635018907.10165,
        "referenceNumber" : "3295208592",
        "utc_datetime" : "2021-10-23T19:55:06Z",
        "success" : true,
        "testResult" : 2.3530000000000002,
        "testServer" : "Seattle, US",
        "local_datetime" : "2021-10-23T12:55:06-07:00",
        "isWiFi" : true
      }
    },
    "Download" : {
      "utc_datetime" : "2021-10-23T19:54:52Z",
      "testIndex" : 0,
      "testNetwork" : "********",
      "testProvider" : "Comcast Cable",
      "testResult" : 128.10699439551834,
      "latitude" : 44.xxx,
      "testServer" : "Seattle, US",
      "local_datetime" : "2021-10-23T12:54:52-07:00",
      "isWiFi" : true,
      "longitude" : -123.xxx,
      "timestamp" : 1635018907.101619,
      "success" : true,
      "referenceNumber" : "3295208592"
    },
    "Upload" : {
      "timestamp" : 1635018907,
      "referenceNumber" : "3295208592",
      "utc_datetime" : "2021-10-23T19:55:00Z",
      "testIndex" : 0,
      "testServer" : "Seattle, US",
      "testResult" : 39.259037513239875,
      "testProvider" : "Comcast Cable",
      "testNetwork" : "********",
      "isWiFi" : true,
      "success" : true,
      "local_datetime" : "2021-10-23T12:55:00-07:00",
      "latitude" : 44.xxx,
      "longitude" : -123.xxx
    }
  }
}
```