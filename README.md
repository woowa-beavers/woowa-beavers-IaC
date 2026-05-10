# woowa-beavers-terraform-temp

우아한형제들 비버즈 팀 인프라 Terraform 코드 저장소 (임시)

> 팀 리뷰 후 팀 레포로 합류 예정

---

## 폴더 구조

```
woowa-beavers-terraform-temp/
├── dev/                        # dev 계정 - 쇼핑몰 인프라
│   ├── modules/
│   │   ├── compute/            # EC2 (웹서버, WAS, Bastion 등)
│   │   ├── networking/         # VPC, 서브넷, 보안그룹, 라우팅
│   │   ├── cdn/                # CloudFront, WAF, ALB
│   │   ├── storage/            # S3
│   │   └── database/           # RDS (Auth DB, Commerce DB)
│   ├── main.tf
│   ├── variables.tf
│   ├── output.tf
│   └── terraform.tfvars
│
├── sec/                        # sec 계정 - 보안 서버
│   ├── modules/
│   │   ├── compute/            # EC2 (Wazuh, TheHive, MISP)
│   │   ├── networking/         # VPC, 서브넷, 보안그룹
│   │   ├── security/           # GuardDuty, SecurityHub, KMS
│   │   └── iam/                # IAM Role
│   ├── main.tf
│   ├── variables.tf
│   ├── output.tf
│   └── terraform.tfvars
│
├── cloudflare/                 # Cloudflare - DNS, Zero Trust, Tunnel
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
│
└── README.md
```

---

## 계정 구조

| 계정    | 역할                                         | Terraform |
|---------|----------------------------------------------|-----------|
| Root    | SCP, Organizations                           | 보류      |
| sec     | Wazuh, TheHive, MISP, GuardDuty, SecurityHub | ✅        |
| ops     | CI/CD, Terraform 실행 주체                   | 보류      |
| dev     | 쇼핑몰 인프라                                | ✅        |
| billing | 비용 알림                                    | -         |

---

## 작업 분담

- **Terraform**: 인프라 틀 (VPC, EC2, RDS, ALB 등 리소스 프로비저닝)
- **Ansible**: 소프트웨어 설치 및 설정 (Wazuh, TheHive, MISP 등)
