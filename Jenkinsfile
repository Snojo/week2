node {
    checkout scm
    env.NODEJS_HOME = "${tool 'recent node'}"
    // on linux / mac
    env.PATH="${env.NODEJS_HOME}/bin:${env.PATH}"
    stage('Build') {
        echo 'Initializing...'
        sh 'node --version'
        sh 'yarn install'
       // sh 'npm cache clean -f'
        //sh 'npm install'
        //sh 'npm run installclient'
    }
    stage('Test') {
        echo 'Testing..'
        sh 'npm run test'
        sh 'npm run apitest'
        sh 'npm run loadtest'
    }
    stage('Build and Deploy') {
        echo 'Deploying....'
        sh './dockerbuild.sh'
       // sh 'npm run build'
       // sh 'npm run buildclient'
        //sh 'export GIT_COMMIT= <git hash used to tag your container>'
        //sh './provisioning/create-aws-docker-host-instance.sh'
        //sh './provisioniing/update-env.sh'
       // sh 'pwd'
       sh 'cd ./provisioning && ./provision-new-environment.sh'
       // sh 'pwd'
    }
}