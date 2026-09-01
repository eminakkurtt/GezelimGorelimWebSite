pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'GitHub repository checkout edildi.'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Docker image oluşturuluyor...'
                sh 'docker build -t gezelim-gorelim:latest .'
            }
        }

        stage('Stop Old Container') {
            steps {
                echo 'Eski container kontrol ediliyor...'
                sh 'docker rm -f gezelim-gorelim || true'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Yeni container başlatılıyor...'
                sh 'docker run -d --name gezelim-gorelim --restart unless-stopped -p 8080:80 gezelim-gorelim:latest'
            }
        }

        stage('Verify') {
            steps {
                echo 'Deployment kontrol ediliyor...'
                sh 'docker ps'
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