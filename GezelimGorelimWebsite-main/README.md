# Gezelim Görelim – DevOps & CI/CD

Bu proje, statik bir web uygulamasının **Docker ve Jenkins kullanılarak CI/CD pipeline üzerinden otomatik olarak build edilmesi, deploy edilmesi ve kontrol edilmesi** amacıyla hazırlanmıştır.

## Kullanılan Teknolojiler

* **Git / GitHub** – Kaynak kod yönetimi
* **Jenkins** – CI/CD pipeline
* **Docker** – Containerization
* **Nginx** – Web sunucusu
* **Shell Script** – Pipeline içerisindeki otomasyon işlemleri

---

## DevOps Mimarisi

```text
Developer
    │
    ▼
   Git
    │
    ▼
  GitHub
    │
    ▼
  Jenkins
    │
    ├── Checkout
    │
    ├── Test
    │
    ├── Docker Build
    │
    ├── Stop Old Container
    │
    ├── Deploy
    │
    ├── Health Check
    │
    └── Verify
    │
    ▼
 Docker Container
    │
    ▼
   Nginx
    │
    ▼
Web Application
```

## Jenkins Pipeline

Pipeline aşağıdaki aşamalardan oluşmaktadır:

### 1. Checkout

Jenkins, GitHub repository içerisindeki `main` branch'ini otomatik olarak checkout eder.

```groovy
stage('Checkout') {
    steps {
        git branch: 'main',
            url: 'https://github.com/eminakkurtt/GezelimGorelimWebSite.git'
    }
}
```

### 2. Test

Deployment işleminden önce projenin temel dosyalarının mevcut olup olmadığı kontrol edilir.

Kontrol edilen dosyalar:

* `index.html`
* `css/style.css`
* `img/`

Bu aşamada gerekli dosyalardan biri bulunamazsa pipeline başarısız olur.

### 3. Docker Build

Uygulama Docker image haline getirilir.

```bash
docker build -t gezelim-gorelim:latest .
```

Oluşturulan image:

```text
gezelim-gorelim:latest
```

### 4. Stop Old Container

Yeni deployment öncesinde mevcut container kaldırılır.

```bash
docker rm -f gezelim-gorelim || true
```

`|| true` kullanılması sayesinde container daha önce mevcut değilse pipeline gereksiz yere başarısız olmaz.

### 5. Deploy

Yeni Docker container çalıştırılır.

```bash
docker run -d \
    --name gezelim-gorelim \
    --restart unless-stopped \
    -p 8080:80 \
    gezelim-gorelim:latest
```

Uygulama:

```text
http://localhost:8080
```

adresinden erişilebilir.

`--restart unless-stopped` sayesinde container, Docker servisi yeniden başlatıldığında otomatik olarak tekrar çalıştırılır.

### 6. Health Check

Deployment sonrasında container'ın health durumunun kontrol edilmesi amaçlanmıştır.

```bash
docker inspect gezelim-gorelim \
    --format "{{.State.Health.Status}}"
```

Container'ın:

```text
healthy
```

durumunda olması beklenir.

### 7. Verify

Deployment sonrasında container ve uygulama hakkında çeşitli kontroller gerçekleştirilir.

Kontrol edilen bilgiler:

* Container çalışma durumu
* Health status
* CPU / RAM kullanımı
* Son container logları

Kullanılan Docker komutları:

```bash
docker ps
docker inspect
docker stats
docker logs
```

---

## Docker Deployment

Dockerfile kullanılarak web uygulaması container içerisinde çalıştırılmaktadır.

Temel deployment akışı:

```text
Source Code
     │
     ▼
Dockerfile
     │
     ▼
Docker Image
     │
     ▼
Docker Container
     │
     ▼
Nginx :80
     │
     ▼
Host :8080
```

Host makinedeki `8080` portu container içerisindeki `80` portuna yönlendirilmiştir.

```text
localhost:8080 → container:80
```

---

## CI/CD Akışı

Projede temel CI/CD süreci şu şekilde çalışmaktadır:

```text
Git Push
   │
   ▼
GitHub
   │
   ▼
Jenkins Pipeline
   │
   ▼
Checkout
   │
   ▼
Test
   │
   ▼
Docker Build
   │
   ▼
Old Container Stop
   │
   ▼
New Container Deploy
   │
   ▼
Health Check
   │
   ▼
Verify
   │
   ▼
Deployment Successful
```

Bu yapı sayesinde kod GitHub'a gönderildikten sonra uygulamanın Docker image oluşturma ve deployment süreçleri Jenkins tarafından otomatikleştirilebilir.

---

## Jenkins Pipeline Yapısı

Pipeline içerisindeki temel stages:

```text
Checkout
   ↓
Test
   ↓
Docker Build
   ↓
Stop Old Container
   ↓
Deploy
   ↓
Health Check
   ↓
Verify
```

Pipeline başarılı olduğunda Jenkins:

```text
Deployment basariyla tamamlandi!
```

mesajını üretmektedir.

Pipeline herhangi bir aşamada hata alırsa:

```text
Deployment basarisiz oldu!
```

mesajı görüntülenmektedir.

---

## Projede Kullanılan DevOps Yaklaşımları

Bu projede aşağıdaki DevOps konseptleri uygulanmıştır:

* Version Control
* Git Workflow
* GitHub Repository Management
* CI/CD
* Jenkins Pipeline
* Infrastructure Automation
* Docker Containerization
* Automated Deployment
* Container Health Check
* Deployment Verification
* Container Monitoring
* Application Logging
* Port Mapping
* Container Restart Policy

## Sonuç

Proje kapsamında statik web uygulamasının manuel olarak çalıştırılması yerine **GitHub → Jenkins → Docker → Nginx** tabanlı bir deployment süreci oluşturulmuştur.

Jenkins pipeline sayesinde uygulamanın:

**kod kontrolü → test → Docker image oluşturma → container deployment → health check → monitoring**

adımları tek bir CI/CD pipeline içerisinde yönetilmektedir.
# finalwebsite
