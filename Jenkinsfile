node {
    checkout scm
    env.NODEJS_HOME = "${tool 'Node 6.x'}"
    // on linux / mac
    env.PATH="${env.NODEJS_HOME}/bin:${env.PATH}"
    stage('Build') {
        echo 'Building..'
        sh 'node --version'
        //sh 'yarn install'
       // sh 'npm cache clean -f'
        sh 'npm install'
        //sh 'npm run installclient'
    }
    stage('Test') {
        echo 'Testing..'
        sh 'npm run test'
        // sh 'npm run apitest'
        // sh 'npm run loadtest'
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}