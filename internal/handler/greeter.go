package handler

import (
	"context"

	"bubble/internal/db/ent"
	"bubble/internal/grpcapi"
	"bubble/pkg/logger"
)

type GreeterHandler struct {
	grpcapi.UnimplementedGreeterServiceServer
	db  *ent.Client
	log *logger.Logger
}

func NewGreeterHandler(db *ent.Client, log *logger.Logger) *GreeterHandler {
	return &GreeterHandler{
		db:  db,
		log: log,
	}
}

func (h *GreeterHandler) SayHello(ctx context.Context, req *grpcapi.SayHelloRequest) (*grpcapi.SayHelloResponse, error) {
	h.log.Infof("Received SayHello request: %+v", req)

	// (db를 사용하려면 h.db.User.Create() 이런 식으로 사용 가능)
	return &grpcapi.SayHelloResponse{
		ResponseCode:    200,
		ResponseMessage: "Hi, Nice to meet you, too",
	}, nil
}
