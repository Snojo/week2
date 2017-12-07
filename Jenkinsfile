node {
    checkout scm
    stage('Build') {
        echo 'Building..'
        sh 'npm install'
        sh 'npm run startpostgres && npm run startserver'
        sh 'npm run installclient'
    }
    stage('Test') {
        echo 'Testing..'
        sh 'npm tests'
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}