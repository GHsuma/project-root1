pipeline {
    agent any

    environment {
        // Define environment variables
        ANSIBLE_INVENTORY = 'ansible/inventory/production'
        ANSIBLE_PLAYBOOK = 'ansible/playbooks/configure.yml'
        ANSIBLE_USER = 'ansible-user'  // Specify your Ansible user
        ANSIBLE_PRIVATE_KEY = credentials('ansible-private-key')  // Use Jenkins credentials plugin
        REGISTRY_URL = 'us-south.icr.io/project-root'
        CLUSTER_NAME = 'my-cluster'
        APP_NAME = 'my-app'
    }

    stages {
        // Checkout code from GitHub
        stage('Checkout') {
            steps {
                git 'https://github.com/GHsuma/project-root1.git'
            }
        }

        // Run Ansible Playbook for Configuration Management
        stage('Run Ansible Playbook') {
            steps {
                script {
                    // Running Ansible playbook to configure the server
                    sh '''
                    ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --user $ANSIBLE_USER --private-key $ANSIBLE_PRIVATE_KEY
                    '''
                }
            }
        }

        // Build Docker image and push to registry
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t $REGISTRY_URL/$APP_NAME .'
                    // Push Docker image to IBM Cloud Container Registry
                    sh 'docker push $REGISTRY_URL/$APP_NAME'
                }
            }
        }

        // Deploy the application to Kubernetes
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Configure kubectl for IBM Cloud
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
        success {
            echo 'Pipeline executed successfully.'
        }

        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
