package app

import (
	"net"

	"bubble/internal/db"
	"bubble/internal/grpcapi"
	"bubble/internal/handler"
	"bubble/pkg/config"
	"bubble/pkg/logger"

	"google.golang.org/grpc"
)

func Run() {
	cfg := config.Load()
	log := logger.New()
	client := db.InitEnt(cfg, log)

	lis, err := net.Listen("tcp", cfg.GRPCPort)
	if err != nil {
		log.Fatal("failed to listen: ", err)
	}

	server := grpc.NewServer()
	grpcapi.RegisterGreeterServiceServer(server, handler.NewGreeterHandler(client, log))

	log.Infof("🚀 gRPC Server started on %s", cfg.GRPCPort)
	if err := server.Serve(lis); err != nil {
		log.Fatal("server stopped: %v", err)
	}
}
