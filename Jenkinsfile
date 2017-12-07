node {
    checkout scm
    stage('Build') {
        echo 'Building..'
        //sh 'yarn install'
        sh 'npm cache clean -f'
        sh 'npm install'
        sh 'npm update'
        sh 'npm run installclient'
    }
    stage('Test') {
        echo 'Testing..'
        //sh 'npm run test'
        sh 'npm run apitest'
        sh 'npm run loadtest'
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}