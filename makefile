# ------------------------------
# Go + gRPC + Ent + Kafka + SQLite Project Makefile
# ------------------------------

APP_NAME = bubble
MAIN_PATH = ./cmd/main.go
PROTO_PATH = ./internal/grpcapi
ENT_PATH = ./internal/db/ent

GO = go
GOFMT = gofmt -s -w

# ------------------------------
# 0️⃣ 초기 세팅 (모듈 설치, go.sum 복구 포함)
# ------------------------------
setup:
	@echo " Setting up Go project dependencies..."
	$(GO) mod tidy
	@echo " Installing core libraries (Kafka, SQLite, gRPC, Ent)..."
	$(GO) get -u github.com/confluentinc/confluent-kafka-go/v2/kafka
	$(GO) get -u github.com/mattn/go-sqlite3
	$(GO) get -u google.golang.org/grpc/status
	$(GO) get -u entgo.io/ent/cmd/ent@v0.14.5
	$(GO) get -u entgo.io/ent/entc/load@v0.14.5
		$(GO) get -u github.com/olekukonko/tablewriter@v1.1.0
	$(GO) get -u github.com/spf13/cobra@v1.10.1

	$(GO) get -u entgo.io/ent/cmd/internal/base@v0.14.5
	$(GO) get -u entgo.io/ent/entc/gen@v0.14.5
	$(GO) get -u entgo.io/ent/cmd/internal/printer@v0.14.5
	$(GO) get -u github.com/spf13/cobra
	$(GO) mod tidy
	@echo " All dependencies installed successfully."

# ------------------------------
# 1️⃣ .proto → .pb.go 생성
# ------------------------------
proto:
	@echo " Generating gRPC code from proto..."
	@if [ ! -d "$(PROTO_PATH)" ]; then \
		echo " ERROR: $(PROTO_PATH) directory not found."; \
		exit 1; \
	fi
	protoc --go_out=$(PROTO_PATH) --go-grpc_out=$(PROTO_PATH) $(PROTO_PATH)/*.proto
	@echo " Done generating protobuf files."

# ------------------------------
# 2️⃣ Ent ORM 코드 생성

# 
# ------------------------------
ent:
	@echo " Generating Ent ORM schema..."
	@if ! command -v ent >/dev/null 2>&1; then \
		echo " Installing Ent CLI..."; \
		go install entgo.io/ent/cmd/ent@v0.14.5; \
	fi
	ent generate $(ENT_PATH)/schema
	@echo "Ent schema generated successfully."
# ------------------------------
# 3️⃣ 빌드 / 실행 / 정리
# ------------------------------
build:
	@echo "  Building binary..."
	$(GO) build -o bin/$(APP_NAME) $(MAIN_PATH)
	@echo " Build complete: ./bin/$(APP_NAME)"

run:
	@echo " Running $(APP_NAME)..."
	$(GO) run $(MAIN_PATH)

tidy:
	@echo "🧹 Running go mod tidy..."
	$(GO) mod tidy
	@echo " Go modules cleaned and synced."

clean:
	@echo " Cleaning up..."
	rm -rf bin
	rm -rf $(ENT_PATH)/ent
	find . -name "*.pb.go" -delete
	@echo " Clean complete."

# ------------------------------
# 4️⃣ 전체 자동 빌드 파이프라인
# ------------------------------
all: setup proto ent build run
	@echo "🎉 All steps completed successfully!"


# ------------------------------
#  Kafka infra control
# ------------------------------

kafka-up:
	@echo " Starting Kafka, Zookeeper, and Kafka-UI..."
	docker-compose up -d
	@echo " Kafka cluster running at localhost:9092"
	@echo " Kafka UI available at http://localhost:8081"

kafka-down:
	@echo " Stopping Kafka and related services..."
	docker-compose down
	@echo "Kafka cluster stopped."

kafka-logs:
	@echo " Showing Kafka logs..."
	docker-compose logs -f kafka