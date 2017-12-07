node {
    checkout scm
    stage('Build') {
        echo 'Building..'
        //sh 'yarn install'
        
        sh 'npm install'
        //sh 'npm run installclient'
    }
    stage('Test') {
        echo 'Testing..'
        sh 'npm run test'
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}