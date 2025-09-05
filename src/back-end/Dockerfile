
FROM node:20-alpine AS builder

WORKDIR /app

# package.json 파일을 먼저 복사하여 의존성 설치
COPY package*.json ./
RUN npm install

# --- STAGE 2: Create Final Image ---
# 최종 이미지를 위해 깨끗한 Node.js 이미지에서 다시 시작
FROM node:20-alpine

WORKDIR /app

# 빌더 스테이지에서 소스 코드와 설치된 node_modules를 복사
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# 애플리케이션이 3000번 포트를 사용한다고 외부에 알림
EXPOSE 3000

# 컨테이너가 시작되면 백엔드 서버를 실행
CMD [ "node", "index.js" ]

