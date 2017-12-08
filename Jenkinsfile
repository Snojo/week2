node {
    checkout scm
    env.NODEJS_HOME = "${tool 'node'}"
    // on linux / mac
    env.PATH="${env.NODEJS_HOME}/bin:${env.PATH}"
    stage('Build') {
        echo 'Initializing...'
        sh 'node --version'
        sh 'yarn install'
       // sh 'npm install -g create-react-app'
        //sh 'npm cache clean -f'
        //sh 'npm install'
        sh 'cd ./client && yarn install -d'
        //sh 'npm cache clean -f'
    }
    stage('Test') {
        echo 'Testing..'
        sh 'npm run test'
        //sh 'cd ./client && npm run test'
        sh 'npm run apitest'
        sh 'npm run loadtest'
    }
    stage('Build and Deploy') {
        echo 'Deploying....'
        //sh './dockerbuild.sh'
        sh 'npm run build'
        sh './pushToDocker.sh'
       // sh 'npm run build'
       // sh 'npm run buildclient'
        //sh 'export GIT_COMMIT= <git hash used to tag your container>'
        //sh './provisioning/create-aws-docker-host-instance.sh'
        //sh './provisioniing/update-env.sh'
       // sh 'pwd'
       sh 'cd ./provisioning && ./create-aws-docker-host-instance.sh && ./deploy-on-instance.sh'
       // sh 'pwd'
    }
}