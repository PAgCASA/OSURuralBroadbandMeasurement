package main

import (
	"fmt"
	"net"
	"os"

	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/util"
	"github.com/VictoriaMetrics/fastcache"
	"github.com/gofiber/fiber/v2"
)

var udpCache *fastcache.Cache

func listenAndRecordUDPPackets() {
	//init cache
	udpCache = fastcache.New(1) // 32MB by default

	ServerAddr, err := net.ResolveUDPAddr("udp", ":8372")
	if err != nil {
		fmt.Println("Error: ", err)
		os.Exit(0)
	}

	/* Now listen at selected port */
	ServerConn, err := net.ListenUDP("udp", ServerAddr)
	if err != nil {
		fmt.Println("Error: ", err)
		os.Exit(0)
	}
	defer ServerConn.Close()

	buf := make([]byte, 1024)

	for {
		n, _, err := ServerConn.ReadFromUDP(buf)
		//fmt.Println("Received ", string(buf[0:n]), " from ", addr)

		//TODO change this to FCC value
		// We expect the UDP packets to be 16 bytes long and serve as a unique ID
		if n != 16 {
			continue
		}

		udpID := buf[0:n]

		if udpCache.Has(udpID) {
			times := udpCache.Get(nil, udpID)
			udpCache.Set(udpID, util.IntToByteArray(1+util.ByteArrayToInt(times)))
		} else {
			udpCache.Set(udpID, util.IntToByteArray(1))
		}

		if err != nil {
			fmt.Println("UDP Error: ", err)
		}
	}
}

// in the form of /url/:id
func getUDPPacketsRecieved(c *fiber.Ctx) error {
	id := c.Params("id")

	if udpCache.Has([]byte(id)) {
		times := udpCache.Get(nil, []byte(id))
		//remove from cache so they can reset
		udpCache.Del([]byte(id))

		return c.SendString(fmt.Sprintf("%d", util.ByteArrayToInt(times)))
	} else {
		return c.SendString("0")
	}
}
