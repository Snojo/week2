pipeline {
    agent any

    stages {
        checkout scm
        stage('Build') {
            steps {
                npm run build
                npm run clean
                npm run startpostgres

                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                npm run test
                
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