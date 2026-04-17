# 공식 nginx 이미지를 기반으로 사용
FROM nginx:latest
#FROM 은 기반 이미지를 설정하기 위해 작성한다.
#AS 를 사용하여 빌드 단계의 이름을 지정할 수 있다. 이후 빌드 단계에서 해당 이미지를 참조할 수 있다.
#FROM 은 이전 명령어에 의해 생성된 모든 상태를 리셋한다.

# 작성자 정보
LABEL maintainer="seowon"

# 호스트의 html 파일을 컨테이너의 nginx 웹 루트로 복사
COPY index.html /usr/share/nginx/html/

# 포트 80 노출
EXPOSE 80

# nginx 실행
CMD ["nginx", "-g", "daemon off;"]
#CMD 명령어는 컨테이너가 실행될 때 기본으로 실행할 명령을 설정한다.
#CMD 는 특정 빌드 단계에서 한 번씩만 사용할 수 있다.
#여러 개의 CMD를 명시할 경우, 마지막으로 명시된 CMD를 사용한다.