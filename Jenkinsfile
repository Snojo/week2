pipeline {
    agent any

    stages {
        checkout scm
        stage('Build') {
            steps {
                sh 'npm install'
                
                sh 'npm run startpostgres && npm run startsever'

                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                sh 'npm run test'

                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}