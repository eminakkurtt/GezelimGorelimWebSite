pipeline {
    agent any

    stages {

        stage('Test') {
            steps {
                echo 'Proje dosyalari kontrol ediliyor...'

                sh '''
                    test -f GezelimGorelimWebsite-main/index.html
                    test -f GezelimGorelimWebsite-main/css/style.css
                    test -d GezelimGorelimWebsite-main/img

                    echo "Temel dosya kontrolleri basarili."
                '''
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Docker image olusturuluyor...'

                sh '''
                    docker build -t gezelim-gorelim:latest .
                '''
            }
        }

        stage('Stop Old Container') {
            steps {
                echo 'Eski container kaldiriliyor...'

                sh '''
                    docker rm -f gezelim-gorelim || true
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Yeni container baslatiliyor...'

                sh '''
                    docker run -d \
                    --name gezelim-gorelim \
                    --restart unless-stopped \
                    -p 8080:80 \
                    gezelim-gorelim:latest
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo 'Web sitesi kontrol ediliyor...'

                sh '''
                    sleep 3
                    curl -f http://host.docker.internal:8080
                '''
            }
        }

        stage('Verify') {
            steps {
                echo 'Deployment durumu kontrol ediliyor...'

                sh '''
                    echo "----- CONTAINERS -----"
                    docker ps

                    echo "----- WEBSITE CHECK -----"
                    curl -I http://host.docker.internal:8080

                    echo "Deployment kontrolu basarili."
                '''
            }
        }
    }

    post {

        success {
            echo '========================================'
            echo 'Deployment basariyla tamamlandi!'
            echo 'Website: http://localhost:8080'
            echo '========================================'
        }

        failure {
            echo '========================================'
            echo 'Deployment basarisiz oldu!'
            echo '========================================'
        }
    }
}