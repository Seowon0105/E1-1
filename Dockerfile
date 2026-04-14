# 공식 nginx 이미지를 기반으로 사용
FROM nginx:latest

# 작성자 정보
LABEL maintainer="seowon"

# 호스트의 html 파일을 컨테이너의 nginx 웹 루트로 복사
COPY index.html /usr/share/nginx/html/

# 포트 80 노출
EXPOSE 80

# nginx 실행 (기본 CMD는 이미 정의되어 있음)
CMD ["nginx", "-g", "daemon off;"]