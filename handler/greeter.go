package handler

import (
	"context"
	"golang-grpc-example/grpcapi"
)

type GreeterHandler struct {
	grpcapi.UnimplementedGreeterServiceServer
}

func (h *GreeterHandler) SayHello(ctx context.Context, req *grpcapi.SayHelloRequest) (*grpcapi.SayHelloResponse, error) {
	return &grpcapi.SayHelloResponse{
		ResponseCode:    200,
		ResponseMessage: "Hi, Nice to meet you, too",
	}, nil
}
