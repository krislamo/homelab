pipeline {
    agent any
    stages {
        stage('Build') {
            steps {

                dir ('environments') {
                    git credentialsId: 'b643c25a-d040-4692-8067-d82511509bd0',
                        url: 'git@github.com:krislamo/moxie-env.git'
                }

                ansiblePlaybook credentialsId: '4e3a5a7a-fca5-4f10-89a4-8996cf14fec7',
                    playbook: 'dockerbox.yml'

            }
        }
    }
}
