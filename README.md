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
| **OS** | |
| **Shell / Terminal** | |
| **Docker 버전** | |
| **Git 버전** | |
| **비고** | OrbStack 사용 (sudo 권한 제한 환경) |

> **OrbStack 사용 이유**
> 서울캠퍼스 환경은 보안 정책상 `sudo` 권한이 제한되어 Docker 데몬을 직접 제어하기 어렵습니다.
> OrbStack은 별도의 `sudo` 없이도 Docker 엔진을 구동하고 `docker` 명령어를 그대로 사용할 수 있습니다.

---

## ✅ 수행 항목 체크리스트

| 항목 | 완료 여부 |
| :--- | :---: |
| 터미널 기본 조작 (이동/생성/복사/삭제 등) | ☐ |
| 파일 권한 확인 및 변경 | ☐ |
| Docker 설치 및 기본 점검 | ☐ |
| Docker 기본 운영 명령 수행 | ☐ |
| 컨테이너 실행 실습 (hello-world / ubuntu) | ☐ |
| Dockerfile 기반 커스텀 이미지 제작 | ☐ |
| 포트 매핑 및 브라우저 접속 확인 | ☐ |
| Docker 볼륨 영속성 검증 | ☐ |
| Git 설정 및 GitHub 연동 | ☐ |

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

| 숫자 |	    권한	   | 주요 사용처|

---

755     rwxr-xr-x	실행 파일 / 디렉토리

644     rw-r--r--	일반 텍스트 / 데이터 파일

600	    rw-------	개인 키 / 비밀 파일

    # 실행 파일 권한 설정
    $ chmod 755 run.sh

    # 일반 파일 권한 설정
    $ chmod 644 config.yml

    # 개인 키 파일 보안 강화
    $ chmod 600 private-key.pem

    # 변경 후 확인
    $ ls -l