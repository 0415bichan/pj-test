# --- STAGE 1: Build React App ---
# Node.js 18-alpine 버전을 리액트 앱 빌더로 사용
FROM node:20-alpine AS builder

WORKDIR /app

# package.json 파일을 먼저 복사하여 의존성을 설치
COPY package*.json ./
RUN npm install

# 나머지 프론트엔드 소스 코드를 복사
COPY . .

# React 애플리케이션을 프로덕션용으로 빌드
# 결과물은 /app/dist 폴더에 생성
RUN npm run build

# --- STAGE 2: Serve with Nginx ---
# 최종 이미지를 위해 가벼운 Nginx 웹서버를 사용
FROM nginx:alpine

# 1단계(builder)에서 빌드된 프론트엔드 결과물(/app/dist)을
# Nginx의 기본 웹 루트 디렉토리로 복사
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx는 기본적으로 80번 포트를 사용
EXPOSE 80

# 컨테이너가 시작될 때 Nginx 서버를 실행
CMD ["nginx", "-g", "daemon off;"]