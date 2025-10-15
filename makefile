# ------------------------------
# Go + gRPC + Ent Project Makefile
# ------------------------------

APP_NAME = bubble
MAIN_PATH = ./cmd/main.go
PROTO_PATH = ./grpcapi
ENT_PATH = ./db/ent

# Go settings
GO = go
GOFMT = gofmt -s -w

# ------------------------------
# 1️⃣ .proto → .pb.go 생성
# ------------------------------
proto:
	@echo "🧩 Generating gRPC code from proto..."
	protoc --go_out=. --go-grpc_out=. $(PROTO_PATH)/*.proto
	@echo "✅ Done generating protobuf files."

# ------------------------------
# 2️⃣ Ent ORM 코드 생성
# ------------------------------
ent:
	@echo "🧱 Generating Ent ORM schema..."
	$(GO) run entgo.io/ent/cmd/ent generate $(ENT_PATH)/schema
	@echo "✅ Ent schema generated successfully."

# ------------------------------
# 3️⃣ 빌드 / 실행 / 정리
# ------------------------------
build:
	@echo "⚙️  Building binary..."
	$(GO) build -o bin/$(APP_NAME) $(MAIN_PATH)
	@echo "✅ Build complete: ./bin/$(APP_NAME)"

run:
	@echo "🚀 Running $(APP_NAME)..."
	$(GO) run $(MAIN_PATH)

tidy:
	@echo "🧹 Running go mod tidy..."
	$(GO) mod tidy

clean:
	@echo "🗑️  Cleaning up..."
	rm -rf bin
	rm -rf $(ENT_PATH)/ent
	find . -name "*.pb.go" -delete
	@echo "✅ Clean complete."
