node {
    checkout scm
    stage('Build') {
        echo 'Building..'
        sh 'npm install'
        //sh 'npm run installclient'
    }
    stage('Test') {
        echo 'Testing..'
        sh 'npm run tests'
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}