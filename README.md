# AWS 3 Tier with Terrafrom

## 목차

</br>

[1. 아키텍처](#1-아키텍처)

[2. 개발 기간](#2-개발-기간)

[3. 실행 방법](#3-실행-방법)

[4. 고난과 역경](#4-고난과-역경)
</br></br>

## 1. 아키텍처

</br>

<p align="center"><img src="https://github.com/13byte/aws_3_tier/assets/105263779/d97d4d40-0aca-4051-95a2-515a6a49f546" width="650" height="100%" />
</br></br>

## 2. 개발 기간

</br>

**2024/05/27 ~ 2024/06/07**

로그 및 백업 설정 고도화는 계속 진행 중..
</br></br>

## 3. 실행 방법

</br>

1. terraform.tfvars의 항목에서 domain_name을 원하는것으로 변경한다.
2. domain_name 이름을 가지는 폴더를 생성해서 빌드한 웹 파일들을 넣는다.
3. ec2 user data에 들어갈 settings.sh를 만들고 작성한다.
4. rds 파일에서 resource "aws_db_instance"에서 password와 db_name(초기 database)을 추가한다.
5. terraform init -> terraform plan -> terraform apply

rds endpoint db.{internal_domain_name}
elasticache endpoint primary.redis.{internal_domain_name} & reader.redis.{internal_domain_name}
</br></br>

## 4. 고난과 역경
