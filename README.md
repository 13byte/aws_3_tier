# AWS 3 Tier with Terrafrom

</br>

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
</br></br>

## 3. 실행 방법

</br>

1. terraform.tfvars의 항목에서 domain_name and internal_domain_name을 원하는것으로 변경한다.
2. domain_name 이름을 가지는 폴더를 생성해서 빌드한 웹 파일들을 넣는다.
3. ec2 user data에 들어갈 settings.sh를 만들고 작성한다.
4. rds 파일에서 resource "aws_db_instance"에서 password와 db_name(초기 database)을 추가한다.
5. terraform init -> terraform plan -> terraform apply
</br></br>

## 4. 고난과 역경

</br>

### 1. s3에 web 빌드파일 자동 업로드 및 삭제 문제

</br>

테라폼을 이 프로젝트를 구상하고 만들면서부터 사용해봤다.

그래서 어떻게 이 문제를 해결해야 고민을 하다가 null_resource와 provisioner에 대해서 알게 되어 쉽게 해결
</br></br>

### 2. aws 콘솔상의 acm 검증과 테라폼의 acm 검증의 차이

</br>

테라폼 공식 docs에 있는 acm 검증 code이다.

```hcl
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}
```

이 코드로 domain_name과 *.domain_name을 검증하면 생성은 되지만, 삭제 할 때 에러가 뜬다. 왜 그러는걸까 생각을 해봤는데
생성을 할 때는 allow_overwrite가 있어서 덮어씌워져서 생성이 되지만, 삭제할 때는 테라폼에서는 domain_name과 *.domain_name 총 2개를 찾는데 1개만 존재하지 않아서 그런다.

나는 aws 콘솔에서는 acm을 생성할 때, 두개를 넣고 생성을 했고 검증도 2개를 했기 때문에 테라폼에서도 그런줄 알았는데 그게 아니였던 거다.

결론은 코드에 작성한것처럼 1개만 생성을 하였다. 명확하게 이게 어떤 것이다!! 라는건 아직까지도 잘 모르겠다. 아마 acm의 dns 검증 개념을 명확하게 모르는게 아닌가 싶다.
</br></br>

### 3. 공식 문서를 제대로 읽지 않아서 생기는 문제

</br>

모든걸 배포하고 테스트를 하는데, ec2에서 route53에 등록된 db endpoint 주소로 접근을 하는데, 찾을 수 없는 에러가 난다.
분명 record에 정상 등록이 됐는데 왜 못찾는걸까 vpc의 dns 설정문제인가? subnet에 dns 설정이 상속이 안되서 그런건가? 수많은 생각을 하며 찾았지만
결국 찾지 못하고 직접 내부 zone을 생성하고 record로 했는데 이때는 또 잘 찾았다. 뭐지 하고 싶어서 terraform으로 생성한것과 콘솔로 생성한것을 비교를 하고 있는데

terraform으로 생성한 record에 port가 들어가있었다..!!!!
나는 당연히 aws_db_instance.xxx.endpoint가 aws 콘솔에 써져있는 rds의 endpoint를 말하는건줄 알았는데 address + port라고 한다..

공식 docs를 잘 읽어야겠다는 깨달음을 얻었다.
</br></br>
