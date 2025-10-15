package main

import (
	"golang-grpc-example/grpcapi"
	"golang-grpc-example/handler"
	"log"
	"net"

	"google.golang.org/grpc"
)

func main() {
	lis, err := net.Listen("tcp", ":19001")
	if err != nil {
		log.Fatal("An error has occurred while retrieving on launch: ", err)
	}

	grpcServer := grpc.NewServer()
	grpcapi.RegisterGreeterServiceServer(grpcServer, &handler.GreeterHandler{})

	log.Println("Grpc Server will be start..")
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatal("An error has occurred while retriving on launch: ", err)
	}
}
