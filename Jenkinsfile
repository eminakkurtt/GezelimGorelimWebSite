pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'GitHub repository checkout ediliyor...'

                git branch: 'main',
                    url: 'https://github.com/eminakkurtt/GezelimGorelimWebSite.git'
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
                echo 'Eski container kontrol ediliyor...'

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
                echo 'Web sitesi health check yapiliyor...'

                sh '''
                    sleep 5

                    echo "Health status:"
                    docker inspect gezelim-gorelim \
                        --format "{{.State.Health.Status}}"

                    STATUS=$(docker inspect gezelim-gorelim \
                        --format "{{.State.Health.Status}}")

                    test "$STATUS" = "healthy"

                    echo "Health check basarili."
                '''
            }
        }

        stage('Verify') {
            steps {
                echo 'Deployment ve container kontrol ediliyor...'

                sh '''
                    set -e

                    echo "===== CONTAINER DURUMU ====="
                    docker ps --filter "name=gezelim-gorelim"

                    echo "===== HEALTH STATUS ====="
                    docker inspect gezelim-gorelim \
                        --format "{{.State.Health.Status}}"

                    echo "===== RESOURCE USAGE ====="
                    docker stats gezelim-gorelim --no-stream

                    echo "===== SON LOGLAR ====="
                    docker logs --tail 20 gezelim-gorelim

                    echo "===== DEPLOYMENT BASARILI ====="
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
