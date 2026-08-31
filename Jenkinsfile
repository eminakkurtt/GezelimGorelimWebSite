pipeline {
    agent any

    stages {
        stage('Deploy to Windows') {
            steps {
                sshagent(['windows-server']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no vanora@192.168.68.98"docker --version"
                    '''
                }
            }
        }
    }
}
