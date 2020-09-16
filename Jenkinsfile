pipeline {
    agent any
    stages {
        stage('Build') {
            steps {

                dir ('environments') {
                    git branch: "${env.BRANCH}",
                        credentialsId: "${env.AUTHID}",
                        url: "${env.URL}"
                }

                ansiblePlaybook playbook: "${env.PLAYBOOK}",
                    inventory: "${env.INVENTORY}"
            }
        }
    }
}
