<div align="center">

<img src="https://github.com/woowa-beavers.png" width="130" />

<br/>

<sub>woowa-beavers · Infrastructure as Code</sub>

# 우아한 비버 Infra

> AWS 멀티 계정 보안 인프라를 코드로 관리합니다

<br/>

![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat-square&logo=amazonwebservices&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=flat-square&logo=ansible&logoColor=white)
![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?style=flat-square&logo=cloudflare&logoColor=white)

---

우아한 비버 Infra는 **Baby Beavers 클라우드 보안 1기** CERT 팀의 인프라 코드 저장소입니다.  
쇼핑몰 서비스 인프라(dev 계정)와 보안 서버 인프라(sec 계정)를 코드로 관리하며,  
Wazuh, TheHive, MISP 등 침해 탐지·분석·대응 환경의 기반을 구성합니다.

> **Terraform** — 인프라 리소스 프로비저닝  
> **Ansible** — 소프트웨어 설치 및 서버 설정

</div>

---

## 🛠 기술 스택

<div align="center">

| 구분 | 기술 |
|:---:|:---|
| IaC | ![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white) ![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=flat-square&logo=ansible&logoColor=white) |
| 클라우드 | ![AWS](https://img.shields.io/badge/AWS_dev_/_sec-232F3E?style=flat-square&logo=amazonwebservices&logoColor=white) |
| DNS / 보안 | ![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?style=flat-square&logo=cloudflare&logoColor=white) |
| 형상관리 | ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white) |

</div>

---

## 🏗 계정 구조

<div align="center">

| 계정 | 역할 | Terraform |
|:---:|:---|:---:|
| Root | SCP, Organizations | 보류 |
| sec | Wazuh, TheHive, MISP, GuardDuty, SecurityHub | ✅ |
| ops | CI/CD, Terraform 실행 주체 | 보류 |
| dev | 쇼핑몰 인프라 | ✅ |
| billing | 비용 알림 | - |

</div>

---

## 📁 디렉토리 구조

```
woowa-beavers-infra/
├── .github/
│   └── workflows/
│       └── terraform.yml           # PR: fmt·validate / 수동: plan·apply
├── terraform/
│   ├── dev/                        # dev 계정 - 쇼핑몰 인프라
│   │   ├── modules/
│   │   │   ├── compute/            # EC2-1~5 인스턴스 및 보안그룹
│   │   │   ├── networking/         # Bastion Host, NAT Instance
│   │   │   ├── cdn/                # ALB, CloudFront, WAF, 타겟 그룹, 리스너, 라우팅 규칙 (미작성 일부)
│   │   │   ├── storage/            # S3 (미작성)
│   │   │   └── database/           # RDS (미작성)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars.example
│   ├── sec/                        # sec 계정 - 보안 서버
│   │   ├── modules/
│   │   │   ├── compute/            # EC2 (TheHive, MISP) (미작성)
│   │   │   ├── networking/         # VPC, 서브넷, 보안그룹 (미작성)
│   │   │   ├── security/           # GuardDuty, SecurityHub, KMS, CloudTrail Lake (미작성)
│   │   │   └── iam/                # IAM Role (미작성)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars.example
│   └── cloudflare/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars.example
│
├── ansible/
│   ├── inventory/                  # 호스트 목록 (dev, sec 서버)
│   ├── playbooks/                  # 플레이북
│   └── roles/
│       ├── wazuh/                  # Wazuh 설치 및 설정
│       ├── thehive/                # TheHive 설치 및 설정
│       └── misp/                   # MISP 설치 및 설정
│
└── README.md
```

---

## 💬 커밋 컨벤션

```
[ 분류 ] 커밋 내용
```

<div align="center">

| 분류 | 설명 |
|:---:|:---|
| `feat` | 새 모듈 또는 리소스 추가 |
| `fix` | 오류 수정 |
| `chore` | 설정, 패키지, 기타 |
| `docs` | 문서 수정 |
| `refactor` | 리팩토링 |
| `remove` | 리소스 또는 파일 삭제 |

</div>

```
[ feat ] dev networking 모듈 추가
[ feat ] ansible wazuh role 추가
[ fix ] sec 보안그룹 인바운드 포트 수정
[ chore ] .gitignore tfvars 제외 설정
[ docs ] README 계정 구조 업데이트
```

---

## 🌿 브랜치 전략

```
main
├── ksy
├── kjm
├── ann
└── yjw
```

- 각 팀원은 본인 브랜치에서 작업
- 작업 완료 후 `main` 브랜치로 PR
- 최소 1명 이상 코드 리뷰 후 머지

---

## 🚀 시작하기

### Terraform (로컬 실행)

```bash
cd terraform/dev   # 또는 terraform/sec, terraform/cloudflare
cp terraform.tfvars.example terraform.tfvars  # 값 채운 후 사용
terraform init
terraform plan
terraform apply
```

### Terraform (CI/CD)

- **PR 생성** → 7개 모듈 전체 `fmt check` + `init` + `validate` 자동 실행
- **workflow_dispatch** → 디렉토리 지정 + plan / apply 선택 수동 실행
- `terraform.tfvars` 없음 — CI/CD는 GitHub Secrets의 `TF_VAR_*` 환경변수로 주입

### Ansible

```bash
cd ansible
ansible-playbook -i inventory/ playbooks/<playbook>.yml
```

---

<div align="center">
<sub>Maintained by <a href="https://github.com/woowa-beavers">woowa-beavers</a></sub>
</div>
