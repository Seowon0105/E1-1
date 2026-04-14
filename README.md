# 🖥️ 개발 워크스테이션 환경 구축

## 📌 프로젝트 개요

개발은 코드를 작성하는 순간이 아니라, 환경을 세팅하는 순간부터 시작됩니다.

이 미션은 **터미널(CLI), Docker(컨테이너), Git/GitHub(버전 관리)** 를 직접 손으로 세팅하며,
"코드가 내 컴퓨터에서만 돌아가는 문제"를 줄이고 팀원 누구나 같은 방식으로
실행·배포·디버깅할 수 있는 환경 구성을 목표로 합니다.

### 🎯 과제 목표

이 과제를 마친 후, 아래를 스스로 설명할 수 있어야 합니다.

- [ ] 절대 경로와 상대 경로의 차이를 예시를 들어 설명할 수 있다.
- [ ] 파일 권한(r/w/x)과 755, 644 같은 표기를 해석할 수 있다.
- [ ] 기존 Dockerfile을 기반으로 커스텀 이미지를 만들 수 있다.
- [ ] 포트 매핑이 필요한 이유를 설명할 수 있다.
- [ ] Docker 볼륨(영속 데이터)을 설명할 수 있다.
- [ ] Git과 GitHub의 역할 차이를 설명할 수 있다.

---

## ⚠️ 제약 사항

### 제출 방식
- 제출은 **GitHub Repository 링크**로 진행한다.
- 기술 문서(README.md)에 수행 로그와 증거가 모두 포함되어야 한다.
  - 별도 파일로 분리는 가능하나, **README에서 링크로 접근 가능**해야 한다.

### 실행 방식
- 모든 작업은 **터미널(CLI) 기반**으로 수행한다.
- Dockerfile은 **직접 작성**해야 한다.
- 포트 매핑과 마운트/볼륨은 **직접 설정하고 동작을 검증**해야 한다.

### 증거 수집 규칙
- 캡처/로그에는 **명령어 입력**과 **출력 결과**가 함께 포함되어야 한다.
- 브라우저 접속 증거는 **주소창(포트 포함)과 응답 화면**이 함께 보이도록 한다.
- **민감정보(토큰, 비밀번호, 개인키 등)는 반드시 마스킹**한다.

### 재현성
- README만 보고도 평가자가 동일 절차를 따라 결과물을 확인할 수 있어야 한다.
- 특정 개인 PC에 종속된 경로/설정이 있다면, **대체 방법 또는 주의사항**을 함께 기록한다.

---

## ⚙️ 실행 환경

| 항목 | 내용 |
| :--- | :--- |
| **OS** | macOS 15.7.4 |
| **Shell** | zsh 5.9 (x86_64-apple-darwin24.0) |
| **Docker 버전** | Docker version 28.5.2, build ecc6942 |
| **Git 버전** | git version 2.53.0 |
| **비고** | OrbStack 사용 (sudo 권한 제한 환경) |

## 실행환경 확인 명령어
  $ sw_vers
  ProductName:            macOS
  ProductVersion:         15.7.4
  BuildVersion:           24G517

  $ echo $SHELL
  /bin/zsh

  $ zsh --version
  zsh 5.9 (x86_64-apple-darwin24.0)

  $ docker --version
  Docker version 28.5.2, build ecc6942

  $ git --version
  git version 2.53.0
> **OrbStack 사용 이유**
> 서울캠퍼스 환경은 보안 정책상 `sudo` 권한이 제한되어 Docker 데몬을 직접 제어하기 어렵습니다.
> OrbStack은 별도의 `sudo` 없이도 Docker 엔진을 구동하고 `docker` 명령어를 그대로 사용할 수 있습니다.

---

## ✅ 수행 항목 체크리스트

| 항목 | 완료 여부 |
| :--- | :---: |
| 터미널 기본 조작 (이동/생성/복사/삭제 등) | ✅ |
| 파일 권한 확인 및 변경 | ✅ |
| Docker 설치 및 기본 점검 | ✅ |
| Docker 기본 운영 명령 수행 | ✅ |
| 컨테이너 실행 실습 (hello-world / ubuntu) | ✅ |
| Dockerfile 기반 커스텀 이미지 제작 | ✅ |
| 포트 매핑 및 브라우저 접속 확인 | ✅ |
| Docker 볼륨 영속성 검증 | ✅ |
| Git 설정 및 GitHub 연동 | ✅ |

---
## 1. 터미널 조작 로그

### 1-1. 기본 명령어 실습

```bash
# 현재 위치 확인
$ pwd
/home/user/E1-1

# 목록 확인 (숨김 파일 포함)
$ ls -al
total 8
drwxr-xr-x 2 user user 4096 Jan 15 09:00 .
drwxr-xr-x 8 user user 4096 Jan 15 08:55 ..

# 디렉토리 생성
$ mkdir -p ~/project/practice
mkdir -p 옵션은 리눅스/유닉스에서 디렉토리를 생성할 때 부모 디렉토리(상위 경로)가 없으면 함께 생성하고, 이미 디렉토리가 존재해도 에러를 발생시키지 않는 편리한 옵션
$ mkdir my-workspace
$ mkdir -p project/practice
$ ls
my-workspace  project

# 파일 생성 & 내용 넣기
echo "내용" > {파일명} 해당 경로에 파일명이 존재하지 않으면 echo 출력 내용으로 파일 생성
해당 경로에 파일명이 존재한다면 echo출력 내용으로 덮어쓰기로 저장.
echo "내용" >> {파일명} 해당 경로에 파일명이 존재하지 않으면 echo 출력 내용으로 파일 생성
해당 경로에 파일명이 존재한다면 echo출력 내용으로 이어쓰기로 저장.
$ touch sample.txt
$ echo "Hello, Docker\!" > sample.txt

# 파일 내용 확인
$ cat sample.txt
Hello, Docker!

# 파일 복사
$ cp hello.txt hello-copy.txt

# 파일 이동 / 이름 변경
$ mv hello-copy.txt my-workspace/
$ ls my-workspace/
hello-copy.txt

# 파일 삭제
$ rm hello.txt
$ ls
my-workspace  project

# 디렉토리 삭제
rm -rf : 디렉토리가 비어있지 않을 때 강제삭제(조심) rmdir : 디렉토리가 비었을 때
$ rm -rf my-workspace
$ ls
project
```

### 1-2. 파일 권한 확인 및 변경

    # 권한 확인
    $ ls -l
    -rw-r--r-- 1 user group 0 Jan 1 00:00 sample.txt
**권한 변경** (chmod)

숫자 방식 (권장)

r(read) : 4 w(write) : 2 x(execute) : 1

숫자 / 권한  /주요 수행 역할 

---

755/     rwxr-xr-x/	실행 파일 , 디렉토리

644/     rw-r--r--/	일반 텍스트 , 데이터 파일

600/    rw-------/	개인 키 , 비밀 파일

    # 실행 파일 권한 설정
    $ chmod 755 run.sh

    # 일반 파일 권한 설정
    $ chmod 644 config.yml

    # 개인 키 파일 보안 강화
    $ chmod 600 private-key.pem

    # 변경 후 확인
    $ ls -l

  ### 권한 변경 수행로그
  ***파일 권한 변경***

    $ touch run.sh
    $ ls -l
    -rwxr-xr-x  1 yelp89890317  yelp89890317     0 Apr 14 09:13 run.sh
    $ chmod 777 run.sh
    $ ls -l
    -rwxrwxrwx  1 yelp89890317  yelp89890317     0 Apr 14 09:13 run.sh 
    # 모든 권한을 주었기 때문에 모든 rwx가 on

  ***디렉토리 권한 변경***

    $ mkdir test
    $ ls -l
    drwxr-xr-x  2 yelp89890317  yelp89890317    64 Apr 14 09:25 test
    $ chmod 111 test # 디렉토리에 실행권한만 부여
    $ ls -l
    d--x--x--x  2 yelp89890317  yelp89890317    64 Apr 14 09:25 test

  ### Docker 설치 및 기본 점검
  ***Docker 버전 확인***

    % Docker --version
    Docker version 28.5.2, build ecc6942
  ***Docker 데몬 동작 확인***

    docker ps : 제일 간단한 방법, Docker 데몬이 실행 중이면 컨테이너 목록을 표시합니다.
    데몬이 안 켜져있으면 에러가 발생합니다.

    docker info : Docker 데몬의 상세 정보를 표시합니다.
    버전, 스토리지 드라이버, 컨테이너 수 등을 확인할 수 있습니다.

    % docker info

    Client:
    Version:    28.5.2
    Context:    orbstack
    Debug Mode: false
    Plugins:
      buildx: Docker Buildx (Docker Inc.)
        Version:  v0.29.1
        Path:     /Users/yelp89890317/.docker/cli-plugins/docker-buildx
      compose: Docker Compose (Docker Inc.)
        Version:  v2.40.3
        Path:     /Users/yelp89890317/.docker/cli-plugins/docker-compose

    Server:
    Containers: 0
      Running: 0
      Paused: 0
      Stopped: 0
    Images: 0
    Server Version: 28.5.2
    Storage Driver: overlay2
      Backing Filesystem: btrfs
      Supports d_type: true
      Using metacopy: false
      Native Overlay Diff: true
      userxattr: false
    Logging Driver: json-file
    Cgroup Driver: cgroupfs
    Cgroup Version: 2
    Plugins:
      Volume: local
      Network: bridge host ipvlan macvlan null overlay
      Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
    CDI spec directories:
      /etc/cdi
      /var/run/cdi
    Swarm: inactive
    Runtimes: io.containerd.runc.v2 runc
    Default Runtime: runc
    Init Binary: docker-init
    containerd version: 1c4457e00facac03ce1d75f7b6777a7a851e5c41
    runc version: d842d7719497cc3b774fd71620278ac9e17710e0
    init version: de40ad0
    Security Options:
      seccomp
      Profile: builtin
    cgroupns
    Kernel Version: 6.17.8-orbstack-00308-g8f9c941121b1
    Operating System: OrbStack
    OSType: linux
    Architecture: x86_64
    CPUs: 6
    Total Memory: 15.67GiB
    Name: orbstack
    ID: b0060e74-3c0f-454e-835b-86fd07a82b20
    Docker Root Dir: /var/lib/docker
    Debug Mode: false
    Experimental: false
    Insecure Registries:
      ::1/128
      127.0.0.0/8
    Live Restore Enabled: false
    Product License: Community Engine
    Default Address Pools:
      Base: 192.168.97.0/24, Size: 24
      Base: 192.168.107.0/24, Size: 24
      Base: 192.168.117.0/24, Size: 24
      Base: 192.168.147.0/24, Size: 24
      Base: 192.168.148.0/24, Size: 24
      Base: 192.168.155.0/24, Size: 24
      Base: 192.168.156.0/24, Size: 24
      Base: 192.168.158.0/24, Size: 24
      Base: 192.168.163.0/24, Size: 24
      Base: 192.168.164.0/24, Size: 24
      Base: 192.168.165.0/24, Size: 24
      Base: 192.168.166.0/24, Size: 24
      Base: 192.168.167.0/24, Size: 24
      Base: 192.168.171.0/24, Size: 24
      Base: 192.168.172.0/24, Size: 24
      Base: 192.168.181.0/24, Size: 24
      Base: 192.168.183.0/24, Size: 24
      Base: 192.168.186.0/24, Size: 24
      Base: 192.168.207.0/24, Size: 24
      Base: 192.168.214.0/24, Size: 24
      Base: 192.168.215.0/24, Size: 24
      Base: 192.168.216.0/24, Size: 24
      Base: 192.168.223.0/24, Size: 24
      Base: 192.168.227.0/24, Size: 24
      Base: 192.168.228.0/24, Size: 24
      Base: 192.168.229.0/24, Size: 24
      Base: 192.168.237.0/24, Size: 24
      Base: 192.168.239.0/24, Size: 24
      Base: 192.168.242.0/24, Size: 24
      Base: 192.168.247.0/24, Size: 24
      Base: fd07:b51a:cc66:d000::/56, Size: 64

    WARNING: DOCKER_INSECURE_NO_IPTABLES_RAW is set #환경변수가 설정되어 있다는 뜻
 
### Docker 기본 운영 명령 수행

```bash
  docker images : 이미지 다운로드/목록 확인
  docker ps : 컨테이너 실행/중지/목록 확인 # -a : 중지된 목록도 보여줌
  docker logs : 로그 확인

  주요 옵션
  # 마지막 100줄만 보기
  docker logs --tail 100 my-app

  # 실시간 로그 스트리밍 (tail -f처럼)
  docker logs -f my-app

  # 타임스탬프 함께 표시
  docker logs -t my-app

  # 특정 시간 이후의 로그만
  docker logs --since 2024-01-15T10:00:00 my-app

  # 마지막 10분의 로그
  docker logs --since 10m my-app

  docker stats : 리소스 확인
  ```

### 컨테이너 실행 실습

docker run - 컨테이너 실행

옵션/	설명/	                예시

-d/ 백그라운드 실행 (detach)/	docker run -d nginx

-it/	대화형 모드/	            docker run -it ubuntu bash

--name/	컨테이너 이름 지정/	  docker run --name my-app nginx

-p/	포트 매핑/	              docker run -p 8080:80 nginx

-e/	환경변수 설정/	            docker run -e DB_HOST=localhost nginx

-v/	볼륨 마운트/	            docker run -v /host:/container nginx

--rm/	종료 시 자동 삭제/	      docker run --rm ubuntu echo "hi"


```bash
  % docker run hello-world
  Unable to find image 'hello-world:latest' locally #hello-world 이미지가 없어서 이미지를 받아옴
  latest: Pulling from library/hello-world
  4f55086f7dd0: Pull complete 
  Digest: sha256:452a468a4bf985040037cb6d5392410206e47db9bf5b7278d281f94d1c2d0931
  Status: Downloaded newer image for hello-world:latest

  Hello from Docker!
  This message shows that your installation appears to be working correctly.

  To generate this message, Docker took the following steps:
  1. The Docker client contacted the Docker daemon.
  2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
      (amd64)
  3. The Docker daemon created a new container from that image which runs the
      executable that produces the output you are currently reading.
  4. The Docker daemon streamed that output to the Docker client, which sent it
      to your terminal.

  To try something more ambitious, you can run an Ubuntu container with:
  $ docker run -it ubuntu bash

  Share images, automate workflows, and more with a free Docker ID:
  https://hub.docker.com/

  For more examples and ideas, visit:
  https://docs.docker.com/get-started/

  % docker run -it ubuntu bash
  Unable to find image 'ubuntu:latest' locally
  latest: Pulling from library/ubuntu
  689b91d88a0f: Pull complete 
  Digest: sha256:84e77dee7d1bc93fb029a45e3c6cb9d8aa4831ccfcc7103d36e876938d28895b
  Status: Downloaded newer image for ubuntu:latest
  root@1ac1cef58b4d:/# ls 
  bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
  root@1ac1cef58b4d:/# echo hello # 명령어들이 동일하게 실행됨
  hello
  root@1ac1cef58b4d:/# exit #빠져나올땐 exit
  exit
```

  ### attach vs exec 차이점

  ***attach***

  컨테이너의 표준 입출력(stdin, stdout, stderr)에 연결

  이미 실행 중인 프로세스에 접속하는 것
  
  컨테이너 내 메인 프로세스와 상호작용
  
  메인 프로세스가 종료되면 컨테이너도 종료됨

  로그 확인 용도
  ```bash
  docker attach <container>
  ```
  ***exec***

  새로운 프로세스를 컨테이너 내에서 실행

  컨테이너가 실행 중일 때 추가 명령어 실행
  
  메인 프로세스와 독립적으로 동작
  
  실행한 프로세스만 종료되고 컨테이너는 계속 실행됨

  디버깅, 파일수정 용도

  ```bash
  docker exec -it <container> /bin/bash
  ```

### 기존 Dockerfile 기반 커스텀 이미지 제작

웹서버 베이스의 이미지인 nginx사용.

***프로젝트 구조***
  
    E1-1/
    ├── Dockerfile
    └── index.html

***Dockerfile의 정의***

Dockerfile은 Docker 이미지를 생성하기 위한 스크립트 파일.

이미지 빌드 과정에서 실행할 명령어와 설명을 순서대로 기술

***Dockefile이 필요한 이유***

재사용성 : 동일한 이미지를 언제든지 동일한 환경에서 생성가능.

자동화 : 명령어를 수동으로 입력하지 않아도 자동으로 이미지를 생성.

버전관리 : Dockerfile을 git에 저장하여 빌드 프로세스를 추적 가능.

***Dockerfile 명령어***

RUN :


*** 실행 과정 ***

```bash
# 1. 이미지 빌드
docker build -t my-nginx:1.0 .

# 2. 컨테이너 실행
docker run -d -p 8080:80 --name seowon-nginx my-nginx:1.0 # -d : 백그라운드에서 실행 -p : 포트 매핑 --name : 컨테이너 이름 지정

# 3. 브라우저에서 확인
# http://localhost:8080 접속

컨테이너를 종료하려면?
# 1. 실행 중인 컨테이너 확인
docker ps

# 2. 컨테이너 중지
docker stop seowon-nginx

# 3. 중지된 컨테이너 확인
docker ps -a

# 4. 컨테이너 삭제 (선택사항)
docker rm seowon-nginx
```

### 포트매핑 접속 증거 ###


### Docker 볼륨 영속성 

*** 볼륨 생성 ***

    % docker volume create test-v
    test-v

*** 볼륨 생성 확인 ***

    % docker volume ls
    DRIVER    VOLUME NAME
    local     test-v


