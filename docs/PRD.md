크로스핏 회원관리 앱 (cfq) PRD (Product Requirements Document)

# 1. 프로젝트 개요

## 1.1 프로젝트 개념

프로젝트명: cfq (크로스핏 회원관리 앱)
목적: 크로스핏 회원들이 자신의 운동 기록을 쉽게 관리하고, 매일의 운동(WOD)을 편리하게 확인하며, 회원 간 랭킹을 공유함으로써 운동 동기부여와 커뮤니티 활성화를 돕는 앱을 개발한다.

## 1.2 주요 타겟 유저

크로스핏 센터 회원
개인 운동 기록 및 회원권 정보를 손쉽게 확인하고 싶은 사용자

## 1.3 기대 효과

회원들의 운동 기록 관리 효율 상승
매일 업데이트되는 WOD 확인 용이
운동 성과를 서로 비교하고 랭킹을 통해 동기 부여
나아가 회원권 정보 확인과 개인 RM(1RM, 3RM, 5RM) 관리를 통한 전문적인 운동 데이터 축적

## 1.4 디자인 컨셉

컬러 팔레트: 블랙, 화이트, 그레이(1~6단계), 민트
UI 컨셉: 심플하면서도 직관적인 인터페이스를 지향
명확한 구분선, 깔끔한 폰트
주요 버튼에 민트 컬러 포인트 적용

# 2. 유저 플로우

앱 실행

스플래시 화면(또는 로딩 화면) → 메인 페이지 또는 로그인 화면 표시(최초 로그인 시)
메인 네비게이션

하단 탭(또는 Drawer, AppBar 메뉴 등)을 통해 Ranking, WOD, My Page로 이동 가능
WOD 페이지 이동

달력(Calendar Widget)에서 원하는 날짜 클릭 → 해당 날짜의 WOD가 페이지 상단 혹은 중앙에 표시
이전/다음 날짜 탐색 가능
Ranking 페이지 이동

현재 회원들의 운동 기록과 랭킹 정보 실시간 조회
랭킹 기재를 위해 개인 기록 입력(텍스트 필드) → 제출 시 바로 테이블(또는 리스트 뷰)에 반영 및 랭킹 재정렬
My Page 이동

개인 프로필 및 회원권 정보 확인(Firebase Firestore에서 불러온 데이터)
RM(1RM, 3RM, 5RM) 기록 입력 및 수정
필요 시 알림 설정, 프로필 사진 변경 등(확장 가능)
앱 사용 종료

로그아웃 또는 앱 종료

# 3. 핵심 기능

## 3.1 날짜별 WOD 관리

달력(Calendart Widget)
Flutter용 달력 라이브러리(예: table_calendar 등) 활용
각 날짜 클릭 시 해당 날짜의 WOD 조회 및 페이지 렌더링
WOD 표시
현재 날짜의 WOD 기본 표시
과거/미래 날짜 선택 시 해당 날짜의 WOD를 불러와 표시
Firebase Firestore 혹은 로컬 DB/JSON으로부터 WOD 데이터 로드(추후 백엔드 API 연동 가능)

## 3.2 Ranking(운동 기록 및 순위)

실시간 랭킹 테이블
사용자들이 입력한 기록(예: 시간, 횟수, 중량 등)을 바탕으로 실시간 랭킹 반영
텍스트 필드 입력 → 제출 → 목록 업데이트 → 랭킹 재계산 및 UI 갱신
데이터 저장/불러오기
Firebase Firestore 또는 다른 DB 솔루션(추후 확장)에 기록 저장
BLoC를 통한 상태 관리 및 UI 실시간 갱신

## 3.3 My Page(개인 정보 및 RM 관리)

개인 RM(1RM, 3RM, 5RM) 기록
사용자가 해당 중량 데이터를 직접 입력 또는 수정
Firebase Firestore에 저장
BLoC를 통해 스테이트 반영
회원권 정보 조회
Firebase Firestore에서 사용자별 회원권 상태(예: 이용 기간, 종류 등) 조회
My Page 상단 또는 별도 섹션에서 표시

## 3.4 UI/UX

컬러 팔레트 적용
블랙, 화이트, 그레이(6단계), 민트 조합
반응형 및 심플 디자인
복잡한 네비게이션을 지양, 핵심 기능 위주로 탭 구성
주요 버튼(Submit, Save 등)에 민트 컬러 적용 → 사용자 주목도 상승

# 4. 기술 스택

## 4.1 Dart & Flutter

Dart: 메인 프로그래밍 언어
Flutter: UI 구현을 위한 프레임워크
iOS와 Android 크로스 플랫폼 개발

## 4.2 BLoC (Business Logic Component)

상태 관리
Clean Architecture에 부합하는 계층 분리(프레젠테이션, 도메인, 데이터)
WOD, Ranking, My Page 각각에 대한 별도 BLoC or Cubit 구성
Firebase 연동 로직을 Repository 계층에서 처리

## 4.3 Firebase Firestore

데이터베이스
회원권 정보, 사용자 랭킹 기록, WOD 데이터 관리
Firebase Authentication (확장 시)
추후 로그인/회원가입 기능을 위한 인증 확장 고려

## 4.4 Clean Architecture 패턴 구성

Presentation Layer
UI(Dart/Flutter Widget), BLoC(Cubit)
Domain Layer
UseCase(비즈니스 로직), Entities(주요 데이터 객체)
Data Layer
Repository 구현체, Firebase API 연동, DTO/Data Mapper

## 4.5 주요 라이브러리

Flutter Calendar 라이브러리 (예: table_calendar 등)
Firebase Core/Firestore (예: cloud_firestore)
Flutter BLoC
기타 유용한 플러그인
flutter_hooks, equatable, freezed 등(옵션)

# 5. MVP 기능 개발 이후 추가 개선사항

## 5.1 추가 기능 및 확장 가능성

회원 개별 채팅/알림 기능
Firebase Cloud Messaging(FCM) 연동, 푸시 알림 기능 추가
운동 루틴/프로그래밍 작성 기능
코치가 직접 WOD를 등록/수정, 주별 혹은 월별 프로그램 설정
랭킹 카테고리 세분화
운동 종목별, 시간별(오늘, 주간, 월간) 랭킹
소셜 연동
친구 추가, 좋아요, 댓글 기능 등
출석 체크 기능
센터 출석 체크 및 예약 관리

## 5.2 퍼포먼스 및 UX 개선

오프라인 모드
네트워크 연결이 없을 때 임시 저장 → 재연결 시 동기화
UI/UX 리서치 기반 리디자인
사용자 피드백을 반영해 내비게이션/화면 동선 최적화
테스트 & QA
유닛 테스트, 위젯 테스트, 통합 테스트 자동화
BLoC 테스트 (각 Cubit/Bloc 마다)

## 5.3 결론

본 PRD는 크로스핏 회원관리 앱(cfq)을 빠르게 MVP 수준으로 구현하는 데 필요한 요구사항을 정의하였다.

심플한 UI/UX, 핵심 기능(WOD, 랭킹, My Page) 구현, Firebase Firestore 연동을 통해 사용자에게 최소한의 필수 기능을 빠르게 제공하는 것이 1차 목표이다.
이후 점진적인 기능 확장(알림, 소셜, 세분화된 랭킹 등)을 통해 사용자 만족도를 높여나갈 수 있다.
개발팀은 Clean Architecture와 BLoC 패턴을 사용해 유지보수성과 확장성을 고려한 구조를 설계하고, MVP 릴리즈 이후 사용자의 피드백을 수렴하여 순차적으로 고도화해 나가는 것을 권장한다.
