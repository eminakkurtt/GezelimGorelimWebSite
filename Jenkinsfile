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
                echo 'Docker image oluşturuluyor...'

                sh '''
                    docker build \
                    -t gezelim-gorelim:${BUILD_NUMBER} \
                    -t gezelim-gorelim:latest \
                    .
                '''
            }
        }

        stage('Stop Old Container') {
            steps {
                echo 'Eski container kaldırılıyor...'

                sh '''
                    docker rm -f gezelim-gorelim || true
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Yeni container başlatılıyor...'

                sh '''
                    docker run -d \
                    --name gezelim-gorelim \
                    --restart unless-stopped \
                    -p 8080:80 \
                    gezelim-gorelim:${BUILD_NUMBER}
                '''
            }
        }

        stage('Verify') {
            steps {
                echo 'Deployment kontrol ediliyor...'

                sh '''
                    docker ps
                    docker images gezelim-gorelim --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}"
                '''
            }
        }
    }

    post {

        success {
            echo 'Deployment başarıyla tamamlandı!'
        }

        failure {
            echo 'Deployment başarısız oldu.'
        }
    }
}