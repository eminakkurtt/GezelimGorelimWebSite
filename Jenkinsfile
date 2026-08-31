pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'GitHub repository checkout edildi.'
            }
        }

        stage('Build') {
            steps {
                echo 'Build aşaması başladı.'
            }
        }

        stage('Test') {
            steps {
                echo 'Test aşaması başladı.'
            }
        }
    }

    post {
        success {
            echo 'Pipeline başarıyla tamamlandı.'
        }

        failure {
            echo 'Pipeline başarısız oldu.'
        }
    }
}