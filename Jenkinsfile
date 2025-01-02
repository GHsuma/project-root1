pipeline {
    agent any
    environment {
        GITHUB_SSH_KEY = credentials('github-ssh-key')  // This is the Jenkins credential ID for your SSH private key
        REGISTRY_URL = 'us-south.icr.io/project-root'
        CLUSTER_NAME = 'my-cluster'
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Set SSH key permissions and use it for GitHub authentication
                    sh '''
                    mkdir -p ~/.ssh
                    echo "$GITHUB_SSH_KEY" > ~/.ssh/id_rsa
                    chmod 600 ~/.ssh/id_rsa
                    ssh-keyscan github.com >> ~/.ssh/known_hosts
                    git clone git@github.com:GHsuma/project-root1.git
                    '''
                }
            }
        }
        stage('Run Ansible Playbook for Configuration') {
            steps {
                script {
                    // Running the Ansible playbook for configuration
                    sh '''
                    ansible-playbook -i ansible/inventory/development ansible/playbooks/configure.yml --user ansible-user --private-key ~/.ssh/id_rsa
                    '''
                }
            }
        }
        stage('Deploy Configuration to Production') {
            steps {
                script {
                    // Running the Ansible playbook for production deployment
                    sh '''
                    ansible-playbook -i ansible/inventory/production ansible/playbooks/deploy.yml --user ansible-user --private-key ~/.ssh/id_rsa
                    '''
                }
            }
        }
        stage('Push Docker Image to IBM Cloud Container Registry') {
            steps {
                script {
                    sh 'docker build -t $REGISTRY_URL/my-app .'
                    sh 'docker push $REGISTRY_URL/my-app'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    ibmcloud login --apikey <API_KEY> -r <REGION> -g <RESOURCE_GROUP> ibmcloud ks cluster config --cluster $CLUSTER_NAME
                    kubectl apply -f k8s/deployment.yaml
                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
