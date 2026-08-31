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

                sh '''
                    docker build -t gezelim-gorelim:latest .
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Container deploy ediliyor...'

                sh '''
                    docker stop gezelim-gorelim || true
                    docker rm gezelim-gorelim || true

                    docker run -d \
                        --name gezelim-gorelim \
                        -p 8080:80 \
                        gezelim-gorelim:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'GezelimGorelimWebSite başarıyla deploy edildi.'
        }

        failure {
            echo 'Deployment başarısız oldu.'
        }
    }
}