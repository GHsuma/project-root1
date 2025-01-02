pipeline {
    agent any
    environment {
        // GitHub Repository details
        GIT_REPO = 'git@github.com:GHsuma/project-root1.git'  // Replace with your actual GitHub repository SSH URL
        SSH_CREDENTIALS_ID = 'ansible-private-key'  // Replace with the ID of your SSH private key in Jenkins credentials store
        ANSIBLE_INVENTORY = 'ansible/inventory/development'  // Update according to your inventory file
        ANSIBLE_PLAYBOOK = 'ansible/playbooks/configure.yml'  // Update according to your playbook
        ANSIBLE_USER = 'ansible-user'  // Update according to your Ansible user
        REGISTRY_URL = 'us-south.icr.io/project-root'  // Update with your registry URL
        CLUSTER_NAME = 'my-cluster'  // Update with your Kubernetes cluster name
    }

    stages {
        // Checkout Git repository
        stage('Checkout') {
            steps {
                script {
                    // Checkout the Git repository using SSH credentials stored in Jenkins
                    git credentialsId: SSH_CREDENTIALS_ID, url: GIT_REPO
                }
            }
        }

        // Run Ansible playbook for configuration
        stage('Run Ansible Playbook for Configuration') {
            steps {
                script {
                    sh '''
                    ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --user $ANSIBLE_USER --private-key $ANSIBLE_PRIVATE_KEY
                    '''
                }
            }
        }

        // Build Docker image
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $REGISTRY_URL/my-app .'
                }
            }
        }

        // Push Docker image to IBM Cloud Container Registry
        stage('Push Docker Image to IBM Cloud') {
            steps {
                script {
                    sh 'docker push $REGISTRY_URL/my-app'
                }
            }
        }

        // Deploy to Kubernetes
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    ibmcloud login --apikey <API_KEY> -r <REGION> -g <RESOURCE_GROUP> 
                    ibmcloud ks cluster config --cluster $CLUSTER_NAME
                    kubectl apply -f k8s/deployment.yaml
                    '''
                }
            }
        }
    }

    post {
        // Handle success or failure
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
